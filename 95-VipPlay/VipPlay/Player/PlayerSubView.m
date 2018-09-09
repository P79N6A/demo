//
//  SPVideoSlider.m
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "PlayerSubView.h"
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



@interface SPBrightnessView ()

@property (nonatomic, strong) UIImageView        *backImage;
@property (nonatomic, strong) UILabel            *title;
@property (nonatomic, strong) UIView            *longView;
@property (nonatomic, strong) NSMutableArray    *tipArray;

@end

@implementation SPBrightnessView


- (instancetype)init {
    if (self = [super init]) {
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

        self.frame = CGRectMake(screenWidth * 0.5, screenHeight * 0.5, 155, 155);

        self.layer.cornerRadius  = 10;
        self.layer.masksToBounds = YES;
        
        // 使用UIToolbar实现毛玻璃效果，简单粗暴，支持iOS7+
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        toolbar.alpha = 0.97;
        [self addSubview:toolbar];
        
        self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 79, 76)];
        self.backImage.image =  [UIImage imageFromBundleWithName:@"fullplayer_brightness"];
        [self addSubview:self.backImage];
        self.backImage.center = CGPointMake(155 * 0.5, 155 * 0.5);

        self.title      = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 30)];
        self.title.font          = [UIFont boldSystemFontOfSize:16];
        self.title.textColor     = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.text          = @"亮度";
        [self addSubview:self.title];
        
        self.longView         = [[UIView alloc]initWithFrame:CGRectMake(13, 132, self.bounds.size.width - 26, 7)];
        self.longView.backgroundColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
        [self addSubview:self.longView];
        
        [self createTips];
        self.alpha = 0.0;
    }
    return self;
}

// 创建 Tips
- (void)createTips {
    
    self.tipArray = [NSMutableArray arrayWithCapacity:16];
    
    CGFloat tipW = (self.longView.bounds.size.width - 17) / 16;
    CGFloat tipH = 5;
    CGFloat tipY = 1;
    
    for (int i = 0; i < 16; i++) {
        CGFloat tipX          = i * (tipW + 1) + 1;
        UIImageView *image    = [[UIImageView alloc] init];
        image.backgroundColor = [UIColor whiteColor];
        image.frame           = CGRectMake(tipX, tipY, tipW, tipH);
        [self.longView addSubview:image];
        [self.tipArray addObject:image];
    }
    [self updateLongView:[UIScreen mainScreen].brightness];
}



- (void)setBrightness:(CGFloat)brightness{
    _brightness = brightness;
    [self appearSoundView];
    [self updateLongView:brightness];
}


#pragma mark - Methond

- (void)appearSoundView {
    if (self.alpha == 0.0) {
        self.alpha = 1.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self disAppearSoundView];
        });
    }
}

- (void)disAppearSoundView {
    
    if (self.alpha == 1.0) {
        [UIView animateWithDuration:0.8 animations:^{
            self.alpha = 0.0;
        }];
    }
}

#pragma mark - Update View

- (void)updateLongView:(CGFloat)sound {
    CGFloat stage = 1 / 15.0;
    NSInteger level = sound / stage;
    
    for (int i = 0; i < self.tipArray.count; i++) {
        UIImageView *img = self.tipArray[i];
        
        if (i <= level) {
            img.hidden = NO;
        } else {
            img.hidden = YES;
        }
    }
}


@end



#pragma mark - 快进的view

@implementation SPVideoPlayerFastView

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
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.fastIconView];
    [self addSubview:self.fastTimeLabel];
//    [self addSubview:self.fastVideoImageView];
    [self addSubview:self.fastProgressView];
}

- (UIImageView *)fastIconView {
    
    if (!_fastIconView) {
        _fastIconView = [[UIImageView alloc] init];
        
    }
    return _fastIconView;
}

- (UILabel *)fastTimeLabel {
    if (!_fastTimeLabel) {
        _fastTimeLabel               = [[UILabel alloc] init];
        _fastTimeLabel.textColor     = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font          = [UIFont systemFontOfSize:14.0];
    }
    return _fastTimeLabel;
}

//- (UIImageView *)fastVideoImageView {
//    if (!_fastVideoImageView) {
//        _fastVideoImageView = [[UIImageView alloc] init];
//        _fastVideoImageView.layer.cornerRadius = 6;
//        _fastVideoImageView.layer.masksToBounds = YES;
//        _fastVideoImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _fastVideoImageView.backgroundColor = [UIColor blackColor];
//    }
//    return _fastVideoImageView;
//}

- (UIProgressView *)fastProgressView {
    if (!_fastProgressView) {
        _fastProgressView                   = [[UIProgressView alloc] init];
        _fastProgressView.progressTintColor = [UIColor greenColor];
        _fastProgressView.trackTintColor    = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    }
    return _fastProgressView;
}


- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.userInteractionEnabled = YES;
    }
    return _backgroundImageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat selfW = self.bounds.size.width;
//    CGFloat selfH = self.bounds.size.height;
    
    self.backgroundImageView.frame = self.bounds;
    
    CGFloat padding = 10;
    
//    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
//    if (currentOrientation == UIDeviceOrientationPortrait || !self.fastVideoImageView.image)
    { // 竖屏

        self.fastProgressView.hidden = NO;
        //self.fastVideoImageView.hidden = YES;

        CGFloat fastIconViewX = 0;
        CGFloat fastIconViewY = 5;
        CGFloat fastIconViewH = 30;
        CGFloat fastIconViewW = fastIconViewH;
        self.fastIconView.frame = CGRectMake(fastIconViewX, fastIconViewY, fastIconViewW, fastIconViewH);
        CGPoint fastIconViewCenter = self.fastIconView.center;
        fastIconViewCenter.x = selfW*0.5;
        self.fastIconView.center = fastIconViewCenter;

        CGFloat fastProgressViewX = padding;
        CGFloat fastProgressViewY = CGRectGetMaxY(self.fastIconView.frame)+5;
        CGFloat fastProgressViewW = selfW-2*fastProgressViewX;
        CGFloat fastProgressViewH = 20;
        self.fastProgressView.frame = CGRectMake(fastProgressViewX, fastProgressViewY, fastProgressViewW, fastProgressViewH);

        CGFloat fastTimeLabelX = padding;
        CGFloat fastTimeLabelY = CGRectGetMaxY(self.fastProgressView.frame)+5;
        CGFloat fastTimeLabelW = selfW-2*fastTimeLabelX;
        CGFloat fastTimeLabelH = fastIconViewH;
        self.fastTimeLabel.frame = CGRectMake(fastTimeLabelX, fastTimeLabelY, fastTimeLabelW, fastTimeLabelH);

    }
//    else
//    { // 横屏
//
//        self.fastProgressView.hidden = YES;
//        self.fastVideoImageView.hidden = NO;
//
//        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//
//        // 要与屏幕宽高成比例
//        CGFloat fastVideoImageViewX = padding;
//        CGFloat fastVideoImageViewW = 180;
//        CGFloat fastVideoImageViewH = fastVideoImageViewW*screenHeight/screenWidth;
//        CGFloat fastVideoImageViewY = 35;
//        self.fastVideoImageView.frame = CGRectMake(fastVideoImageViewX, fastVideoImageViewY, fastVideoImageViewW, fastVideoImageViewH);
//
//        CGFloat fastIconViewX = 20;
//        CGFloat fastIconViewY = 5;
//        CGFloat fastIconViewH = 30;
//        CGFloat fastIconViewW = fastIconViewH;
//        self.fastIconView.frame = CGRectMake(fastIconViewX, fastIconViewY, fastIconViewW, fastIconViewH);
//
//        CGFloat fastTimeLabelX = CGRectGetMaxX(self.fastIconView.frame);
//        CGFloat fastTimeLabelY = fastIconViewY;
//        CGFloat fastTimeLabelW = 100;
//        CGFloat fastTimeLabelH = fastIconViewH;
//        self.fastTimeLabel.frame = CGRectMake(fastTimeLabelX, fastTimeLabelY, fastTimeLabelW, fastTimeLabelH);
//    }
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
        configuration.allowsInlineMediaPlayback = YES;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
        configuration.selectionGranularity = YES;
        if (@available(iOS 9.0, *)) {
            configuration.requiresUserActionForMediaPlayback = NO;
        } else {
            // Fallback on earlier versions
            configuration.mediaPlaybackRequiresUserAction = NO;
        }//把手动播放设置NO ios(8.0, 9.0)
        if (@available(iOS 9.0, *)) {
            configuration.allowsAirPlayForMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
            configuration.mediaPlaybackAllowsAirPlay = YES;
        }//允许播放，ios(8.0, 9.0)

        
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
        _reloadBtn.frame = CGRectMake(0, 0, 200, 170);//140
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
        
        UIImage* backImage = [[[UINavigationBar appearance] backIndicatorImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]?:[[UIImage imageFromBundleWithName:@"fullplayer_web_back"]  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setImage:backImage forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
//
//        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 44)];
//        [backView addSubview:button];
//        button.frame = CGRectMake(-33, 0, 66, 44);
//        _backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
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
    _urlString=[_urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    

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
    self.view.backgroundColor = [UIColor blackColor];
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
    //[_wkWebView reload];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_wkWebView.URL?_wkWebView.URL : [NSURL URLWithString:_urlString]];
    [_wkWebView loadRequest:request];
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


@implementation UIImage (Bundle)
+ (UIImage *)imageFromBundleWithName:(NSString *)imageName{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PlayerView" ofType:@".bundle"];
    NSString *fullImageName = [path stringByAppendingPathComponent:imageName];
    return [UIImage imageNamed:fullImageName];
}
@end

