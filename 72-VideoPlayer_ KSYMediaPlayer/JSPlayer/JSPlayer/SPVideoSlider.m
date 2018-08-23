//
//  SPVideoSlider.m
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPVideoSlider.h"
#import "PlayerView.h"

@interface SPVideoSlider()

@property (nonatomic, strong) UIImageView *thumbBackgroundImageView;

@end

@implementation SPVideoSlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self addSubview:self.thumbBackgroundImageView];
}

- (void)setThumbBackgroundImage:(UIImage *)thumbBackgroundImage {
    _thumbBackgroundImage = thumbBackgroundImage;
    self.thumbBackgroundImageView.image = thumbBackgroundImage;
}

// 获取滑动条上跟踪按钮的bounds
- (CGRect)thumbRect {
    return [self thumbRectForBounds:self.bounds
                          trackRect:[self trackRectForBounds:self.bounds]
                              value:self.value];
}

- (UIImageView *)thumbBackgroundImageView {
    
    if (!_thumbBackgroundImageView) {
        _thumbBackgroundImageView = [[UIImageView alloc] init];
    }
    return _thumbBackgroundImageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.thumbBackgroundImageView.frame = (CGRect){{0,0},_thumbBackgroundImage.size};
    CGRect thumbRect = [self thumbRect];
    CGFloat centerX = thumbRect.origin.x+thumbRect.size.width*0.5;
    CGFloat centerY = thumbRect.origin.y+thumbRect.size.height*0.5;
    self.thumbBackgroundImageView.center = CGPointMake(centerX, centerY);
    
}

@end


#import <WebKit/WebKit.h>

#define  NAV_HEIGHT  (iPhoneXX ? 88.f : 64.f)
#define  kScreenWidth [UIScreen mainScreen].bounds.size.width
#define  kScreenHeight [UIScreen mainScreen].bounds.size.height
#define  iPhoneXX (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)


@interface WHWebViewController ()<WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *wkWebView;  //  WKWebView
@property (nonatomic,strong) UIRefreshControl *refreshControl;  //刷新
@property (nonatomic,strong) UIProgressView *progress;  //进度条
@property (nonatomic,strong) UIButton *reloadBtn;  //重新加载按钮

@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;   //返回按钮
@property (nonatomic, strong) UIBarButtonItem *closeBarButtonItem;  //关闭按钮

@end

@implementation WHWebViewController

#pragma mark lazy load
- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        // 设置WKWebView基本配置信息
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = [[WKPreferences alloc] init];
        configuration.allowsInlineMediaPlayback = YES;
        configuration.selectionGranularity = YES;
        
        
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height-NAV_HEIGHT) configuration:configuration];
        _wkWebView.allowsBackForwardNavigationGestures = YES;/**这一步是，开启侧滑返回上一历史界面**/

        // 设置代理
        _wkWebView.navigationDelegate = self;
        
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        // 是否开启下拉刷新
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0 && _canDownRefresh) {
            if (@available(iOS 10.0, *)) {
                _wkWebView.scrollView.refreshControl = self.refreshControl;
            } else {
                // Fallback on earlier versions
            }
        }
        // 添加进度监听
        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:(NSKeyValueObservingOptionNew) context:nil];
        
    }
    return _wkWebView;
}

- (UIRefreshControl *)refreshControl{
    if (!_refreshControl) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(wkWebViewReload) forControlEvents:(UIControlEventValueChanged)];
    }
    return _refreshControl;
}

- (UIProgressView* )progress {
    if (!_progress) {
        self.progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, self.view.bounds.size.width, 2.5)];
        _progress.progressTintColor = _loadingProgressColor?_loadingProgressColor:[UIColor colorWithRed:0.15 green:0.49 blue:0.96 alpha:1.0];
    }
    return _progress;
}

- (UIButton *)reloadBtn{
    if (!_reloadBtn) {
        self.reloadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _reloadBtn.frame = CGRectMake(0, 0, 200, 140);
        _reloadBtn.center = self.view.center;
        [_reloadBtn setBackgroundImage:[UIImage imageFromBundleWithName:@"fullplayer_web_error"] forState:UIControlStateNormal];
        [_reloadBtn setTitle:@"网络异常，点击重新加载" forState:UIControlStateNormal];
        [_reloadBtn addTarget:self action:@selector(wkWebViewReload) forControlEvents:(UIControlEventTouchUpInside)];
        [_reloadBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _reloadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_reloadBtn setTitleEdgeInsets:UIEdgeInsetsMake(200, -50, 0, -50)];
        _reloadBtn.titleLabel.numberOfLines = 0;
        _reloadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGRect rect = _reloadBtn.frame;
        rect.origin.y -= 100;
        _reloadBtn.frame = rect;
        _reloadBtn.hidden = YES;
    }
    return _reloadBtn;
}

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageFromBundleWithName:@"fullplayer_web_back"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 44)];
        [backView addSubview:button];
        button.frame = CGRectMake(-33, 0, 66, 44);
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)closeBarButtonItem {
    if (!_closeBarButtonItem) {
        _closeBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageFromBundleWithName:@"fullplayer_web_close"] style:UIBarButtonItemStyleDone target:self action:@selector(close:)];
    }
    return _closeBarButtonItem;
}
#pragma mark viewDidload
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupUI];
    [self loadRequest];
    
}

#pragma mark private Methods
- (void)setupUI{
    if (@available(iOS 11.0, *)) {
        self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0];
    [self showLeftBarButtonItem];
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progress];
    [self.view addSubview:self.reloadBtn];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];

}

//FIXME:  -  屏幕旋转回调
- (void)changeRotate:(NSNotification*)noti {
    
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarH = self.navigationController.navigationBar.frame.size.height;

    self.progress.frame = CGRectMake(0, navBarH + statusBarH, self.view.bounds.size.width, 2.5);
    self.wkWebView.frame  = CGRectMake(0, navBarH + statusBarH, self.view.bounds.size.width, self.view.bounds.size.height - navBarH - statusBarH);
    
    self.reloadBtn.center = self.view.center;

}
- (void)loadRequest {
    if (![self.urlString hasPrefix:@"http"]) {//容错处理 不要忘记plist文件中设置http可访问 App Transport Security Settings
        self.urlString = [NSString stringWithFormat:@"http://%@",self.urlString];
    }
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlString]];
    [_wkWebView loadRequest:request];
}

- (void)wkWebViewReload{
    [_wkWebView reload];
}

- (void)showLeftBarButtonItem {
    if ([_wkWebView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem,self.closeBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
    }
}
#pragma mark 导航按钮
- (void)back:(UIBarButtonItem*)item {
    if ([_wkWebView canGoBack]) {
        [_wkWebView goBack];
    } else {
        [self close:nil];
    }
}

- (void)close:(UIBarButtonItem*)item {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        _progress.progress = [change[@"new"] floatValue];
        if (_progress.progress == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _progress.hidden = YES;
                [_refreshControl endRefreshing];
            });
        }
    }
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    _progress.hidden = NO;
    _wkWebView.hidden = NO;
    _reloadBtn.hidden = YES;
    // 看是否加载空网页
    if ([webView.URL.scheme isEqual:@"about"]) {
        webView.hidden = YES;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //执行JS方法获取导航栏标题
    //__weak typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        //weakSelf.navigationItem.title = title;
    }];
    
    [self showLeftBarButtonItem];
    [_refreshControl endRefreshing];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"%s---%@", __func__,navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}
// 返回内容是否允许加载
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    webView.hidden = YES;
    _reloadBtn.hidden = NO;
}


#pragma mark Dealloc
- (void)dealloc{
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wkWebView stopLoading];
    _wkWebView.UIDelegate = nil;
    _wkWebView.navigationDelegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end


