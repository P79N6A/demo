//
//  PlayView.m
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "PlayerView.h"
#import "PlayerSubView.h"

//#import <AliyunPlayerSDK/AlivcMediaPlayer.h>
#import <PLPlayerKit/PLPlayer.h>
#import <MediaPlayer/MediaPlayer.h>
//#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>

#import <objc/runtime.h>

#define  kScreenWidth [UIScreen mainScreen].bounds.size.width
#define  kScreenHeight [UIScreen mainScreen].bounds.size.height
//#define  iPhoneXX (kScreenHeight == 375.f && kScreenWidth == 812.f ? YES : NO)
//#define  iPhoneXX ([self.topViewController respondsToSelector:@selector(setNeedsUpdateOfHomeIndicatorAutoHidden)])
//typedef NS_ENUM(NSUInteger, Direction) {
//    DirectionLeftOrRight,
//    DirectionUpOrDown,
//    DirectionNone
//};

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};

typedef NS_ENUM(NSUInteger, PlayViewState) {
    PlayViewStateSmall,
    PlayViewStateAnimating,
    PlayViewStateFullScreenRight,
    PlayViewStateFullScreenLeft,
};



@interface PlayerView()<PLPlayerDelegate,WKNavigationDelegate,WKUIDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) PLPlayer *mediaPlayer;
//@property (nonatomic, weak) AVPlayerItem *playerItem;
//@property (nonatomic, weak) AVPlayerLayer *playerLayer;
/** 视频View的父控件 */
@property (weak, nonatomic) IBOutlet UIView *contentView;
/** 顶部控件 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 顶部控件的背景视图 */
@property (weak, nonatomic) IBOutlet UIImageView *topBgView;
/** 低部控件 */
@property (weak, nonatomic) IBOutlet UIView *buttomView;
/** 低部控件的背景视图 */
@property (weak, nonatomic) IBOutlet UIImageView *buttomBgView;

/** 全屏按键 */
@property (weak, nonatomic) IBOutlet UIButton *fullButton;
/** loading菊花 */
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
/** 返回按键 */
@property (weak, nonatomic) IBOutlet UIButton *backButton;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 播放\暂停按钮 */
@property (nonatomic, strong) UIButton *playOrPauseButton;
/** 时间 - 进度 - 播放 - 暂停 的 父控件*/
@property (nonatomic, strong) UIView *videoButtomView;
/** 进度 */
@property (nonatomic, strong) UIProgressView *progressView;
/** 快进 */
@property (nonatomic, strong) SPVideoSlider *videoSlider;
/** 67:56/98:08 */
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, weak) NSTimer *timer;


/** 错误按钮 */
@property (weak, nonatomic) IBOutlet UIButton *errorBtn;

/** 记录小屏时的parentView */
@property (nonatomic, weak) UIView *playViewParentView;

/** 记录小屏时的frame */
@property (nonatomic, assign) CGRect playViewSmallFrame;

/** 屏幕状态 */
@property (nonatomic, assign) PlayViewState state;

@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic, strong) UISlider *volumeViewSlider;

/*锁屏 */
@property (weak, nonatomic) IBOutlet UIButton *lockBtn;

/*静默进度条 */
@property (weak, nonatomic) IBOutlet UIProgressView *fullProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *fullBufView;

/** 是否正在拖 */
@property (nonatomic, assign) BOOL progressDragging;

//@property (assign, nonatomic) CGPoint startPoint;
//@property (assign, nonatomic) CGFloat volumeValue;
//@property (assign, nonatomic) Direction direction;

/** 平移方向 */
@property (nonatomic, assign) PanDirection           panDirection;
/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat                sumTime;
/** 是否在调节音量*/
@property (nonatomic, assign) BOOL                   isVolume;
/** 快进view */
@property (nonatomic, strong) SPVideoPlayerFastView *fastView ;
/** 亮度view */
@property (nonatomic, strong) SPBrightnessView       *brightnessView;

/** 切换模式 */
@property (weak, nonatomic) IBOutlet UIButton *modeButton;

/** 重试 */
@property (strong, nonatomic)  UIButton *rePlayButton;

/** 浏览器 */
@property (strong, nonatomic)  UIButton *safariButton;
/*流量监控*/
@property (weak, nonatomic) IBOutlet UILabel *networkSpeedLabel;
/** 是否iPhoneX*/
@property (nonatomic, assign,) BOOL iPhoneXX;

/** 网速检测*/
@property (nonatomic, strong,) SpeedMonitor *speedMonitor;

@property (nonatomic, assign) NSInteger reconnectCount;
@property (nonatomic, assign) NSInteger rePlayCount;


@property (strong, nonatomic)  WKWebView *danmuView;

@end


@implementation VideoModel
@end
@implementation PlayerView


//FIXME:  -  生命周期
+ (instancetype)playerView{
    return [[NSBundle mainBundle] loadNibNamed:@"PlayerView" owner:nil options:nil].firstObject;
}

//FIXME:  -  添加控件
- (void)awakeFromNib{
    [super awakeFromNib];
    self.iPhoneXX = ([UIApplication sharedApplication].statusBarFrame.size.height > 20);
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
    [self addGestureRecognizer:tapGestureRecognizer];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDirection:)];
    [self addGestureRecognizer:pan];
    
    
    [self.buttomView addSubview:self.videoButtomView];
    [self.videoButtomView addSubview:self.playOrPauseButton];
    [self.videoButtomView addSubview:self.timeLabel];
    [self.videoButtomView addSubview:self.progressView];
    [self.videoButtomView addSubview:self.videoSlider];
    [self addSubview:self.fastView];
    [self addSubview:self.brightnessView];
    [self.errorBtn addSubview:self.rePlayButton];
    [self.errorBtn addSubview:self.safariButton];
    
    [self insertSubview:self.danmuView aboveSubview:self.contentView];

    [self initUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

//FIXME:  -  初次化图片和文本
- (void)initUI{
    self.errorBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];

    
    self.topBgView.image = [UIImage imageFromBundleWithName:@"fullplayer_bg_top"];
    [self.backButton setImage:[UIImage imageFromBundleWithName:@"fullplayer_icon_back"] forState:UIControlStateNormal];
    
    self.buttomBgView.image = [UIImage imageFromBundleWithName:@"fullplayer_bg_buttom"];
    [self.fullButton setImage:[UIImage imageFromBundleWithName:@"fullplayer_icon_small"] forState:UIControlStateNormal];
    [self.fullButton setImage:[UIImage imageFromBundleWithName:@"fullplayer_icon_full"] forState:UIControlStateSelected];
    
    [self.lockBtn setImage:[UIImage imageFromBundleWithName:@"fullplayer_lockScreen_off_iphone_44x44_"] forState:UIControlStateNormal];
    [self.lockBtn setImage:[UIImage imageFromBundleWithName:@"fullplayer_lockScreen_on_iphone_44x44_"] forState:UIControlStateSelected];
    
    [self.modeButton setImage:[UIImage imageFromBundleWithName:@"fullplayer_icon_mode"] forState:UIControlStateNormal];
    
    //项目名称
    NSString *fileName = [NSString stringWithFormat:@"%@.html",[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleExecutableKey]];
    NSString *url = [NSString stringWithFormat:@"https://jaysongd.github.io/api/banner/%@?r=%ld",fileName,rand()*random()];
    [self.danmuView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

}
//FIXME:  -  处理弹幕
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSURL *url = navigationAction.request.URL;
    if (![url.absoluteString containsString:@"https://jaysongd.github.io"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        });
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 返回内容是否允许加载
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSString *fileName = [NSString stringWithFormat:@"%@.html",[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleExecutableKey]];
    if (response.statusCode != 200 && [response.suggestedFilename isEqualToString:fileName]) {
        decisionHandler(WKNavigationResponsePolicyCancel);
        dispatch_async(dispatch_get_main_queue(), ^{
            [webView removeFromSuperview];
        });
        return;
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if ([webView.URL.absoluteString containsString:@"https://jaysongd.github.io"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            webView.hidden = NO;
        });
        return;
    }
}
//页面加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    if ([webView.URL.absoluteString containsString:@"https://jaysongd.github.io"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [webView removeFromSuperview];
        });
        return;
    }
}
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    NSLog(@"创建一个新的webView");
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
// 展示
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    // Get host name of url.
    //NSString *host = webView.URL.host;
    // Init the alert view controller.
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle: UIAlertControllerStyleAlert];
    // Init the cancel action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        if (completionHandler != NULL) {
            completionHandler();
        }
    }];
    
    // Add actions.
    [alert addAction:cancelAction];
    [self.viewController?self.viewController:self.topViewController presentViewController:alert animated:YES completion:NULL];
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    // Get the host name.
    //NSString *host = webView.URL.host;
    // Initialize alert view controller.
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    // Initialize cancel action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        if (completionHandler != NULL) {
            completionHandler(NO);
        }
    }];
    // Initialize ok action.
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        if (completionHandler != NULL) {
            completionHandler(YES);
        }
    }];
    // Add actions.
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self.viewController?self.viewController:self.topViewController presentViewController:alert animated:YES completion:NULL];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    //NSString *host = webView.URL.host;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    // Add text field.
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入";
        textField.text = defaultText;
    }];
    // Initialize cancel action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
    }];
    // Initialize ok action.
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        // Get inputed string.
        NSString *string = [alert.textFields firstObject].text;
        if (completionHandler != NULL) {
            completionHandler(string?:defaultText);
        }
    }];
    // Add actions.
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self.viewController?self.viewController:self.topViewController presentViewController:alert animated:YES completion:NULL];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

//FIXME:  -  布局位置
- (void)layout{
    
    BOOL iPhoneXX = self.iPhoneXX && (kScreenWidth > kScreenHeight);
    
    CGFloat spacing = iPhoneXX? 24 : 0;
    
    self.danmuView.frame = self.bounds;

    self.contentView.frame = self.bounds;
    self.mediaPlayer.playerView.frame = self.contentView.bounds;
    
    self.loadingView.frame = self.bounds;
    self.loadingLabel.center = CGPointMake(self.loadingView.center.x, self.loadingView.center.y + 20);
    //self.loadingView.center = CGPointMake(self.bounds.size.width * 0.5 - 30, self.bounds.size.height * 0.5);
    //self.loadingLabel.frame = CGRectMake(CGRectGetMaxX(self.loadingView.frame) + 5, self.loadingView.frame.origin.y, 50, self.loadingView.frame.size.height);
    
    self.lockBtn.frame = CGRectMake(0, 0, 40, 40);
    self.lockBtn.center = CGPointMake(15+20+spacing, self.loadingView.center.y);
    self.modeButton.frame = CGRectMake(0, 0, 70, 70);
    self.modeButton.center = CGPointMake(self.bounds.size.width - (35+spacing), self.lockBtn.center.y);
    self.errorBtn.center = self.contentView.center;//CGPointMake(self.loadingView.center.x + 30, self.loadingView.center.y );
    
    if (self.allowSafariPlay) {
        self.rePlayButton.frame = CGRectMake(0, 0, 44, 44);
        self.safariButton.frame = CGRectMake(44, 0, 44, 44);
        self.rePlayButton.center = CGPointMake(self.errorBtn.bounds.size.width *0.333, self.errorBtn.bounds.size.height - 22);
        self.safariButton.center = CGPointMake(self.errorBtn.bounds.size.width *0.666, self.errorBtn.bounds.size.height - 22);
    }else{
        self.rePlayButton.frame = CGRectMake(0, 0, 44, 44);
        self.rePlayButton.center = CGPointMake(self.errorBtn.bounds.size.width *0.5, self.errorBtn.bounds.size.height - 22);
    }
    
    
    self.topView.frame = CGRectMake(0, 0, self.bounds.size.width, 84);
    self.topBgView.frame = self.topView.bounds;
    self.backButton.frame = CGRectMake(spacing, 20+spacing*0.5, 44, 44);
    self.titleLabel.frame = CGRectMake(44+spacing, 20+spacing*0.5, self.topView.bounds.size.width - 44, 44);
    self.networkSpeedLabel.frame = CGRectMake(self.topView.frame.size.width * 0.75-85 , 0, 85, iPhoneXX?46:20);
    
    
    self.buttomView.frame = CGRectMake(0, self.bounds.size.height - 64, self.bounds.size.width , 64);
    self.buttomBgView.frame = self.buttomView.bounds;
    
    self.fullButton.frame = CGRectMake(self.buttomView.bounds.size.width - 44 - spacing, self.buttomView.bounds.size.height - 44, 44, 44);
    
    self.videoButtomView.frame = CGRectMake(spacing, self.buttomView.bounds.size.height - 44, self.buttomView.bounds.size.width - 44 - 2 * spacing, 44);
    self.playOrPauseButton.frame = CGRectMake(0, 0, 44, 44);
    self.timeLabel.frame = CGRectMake(44, 0, 75, 44);
    
    self.progressView.frame = CGRectMake(44 + 75+10, 0, self.videoButtomView.bounds.size.width - 44 - 75-10, 44);
    self.progressView.center = CGPointMake(self.progressView.center.x, self.videoButtomView.bounds.size.height * 0.5);
    
    self.videoSlider.frame = CGRectMake(self.progressView.frame.origin.x - 2, self.progressView.frame.origin.y, self.progressView.frame.size.width+2, 44);
    self.videoSlider.center = CGPointMake(self.videoSlider.center.x, self.progressView.center.y);
    
    
    self.fullProgressView.frame = CGRectMake(iPhoneXX?34:0, self.bounds.size.height - 2, self.bounds.size.width - 2*(iPhoneXX?34:0), 2);
    self.fullBufView.frame = CGRectMake(iPhoneXX?34:0, self.bounds.size.height - 2, self.bounds.size.width - 2*(iPhoneXX?34:0), 2);
    
    self.fastView.frame = CGRectMake(0, 0, 80*self.playViewSmallFrame.size.width/(self.playViewSmallFrame.size.height?self.playViewSmallFrame.size.height:320), 80);
    self.fastView.center = self.errorBtn.center;
    
    self.brightnessView.center = self.errorBtn.center;
    
    self.volumeView.frame = CGRectMake(0, 0, kScreenWidth ,kScreenWidth* 9.0 / 16.0);
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layout];
    //[self timer];
}

- (void)dealloc{
    [self stop];
    //[_mediaPlayer pause];
    [_speedMonitor stopNetworkSpeedMonitor];
    //取消设置屏幕常亮
    //[UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s", __func__);
}
//FIXME:  -  防代理服务器
- (BOOL)isProtocolService{
    
#ifdef DEBUG
    return NO;
#else
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    //NSLog(@"\n%@",proxies);
    
    NSDictionary *settings = proxies[0];
    //NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    //NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    //NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        //NSLog(@"没代理");
        return NO;
    }
    else
    {
        NSLog(@"设置了代理");
        return YES;
    }
#endif
}
#pragma mark  开始播放
- (void)playWithModel:(id<TTZPlayerModel>)model{
    self.model = model;
    //设置屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self.loadingView startAnimating];
    self.loadingLabel.text = @"loading...";
    self.loadingLabel.hidden = self.loadingView.isHidden;
    self.errorBtn.hidden = !self.loadingView.isHidden;
    self.titleLabel.text = model.title;
    self.videoButtomView.hidden = YES;
    
    [self timer];

    
    NSURL *url = [NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
    if ([model.url hasPrefix:@"http://"] || [model.url hasPrefix:@"https://"]) {
        url = [NSURL URLWithString:model.url];
    }else if ([model.url hasPrefix:@"rtmp"] || [model.url hasPrefix:@"flv"]){
        url = [NSURL URLWithString:model.url];
    }else if(model.url.length){ //本地视频 需要完整路径
        url = [NSURL fileURLWithPath:model.url];
    }
    
    if ([self isProtocolService]) {
        url = [NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];
    }
    


    [self.mediaPlayer playWithURL:url];
    
    
    NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    NSLog(@"%s----URL-----%@", __func__,url.absoluteString);
    NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    
}
- (void)play{
        // Fallback on earlier versions
    [self.mediaPlayer resume];
}

- (void)stop{
    [self.mediaPlayer stop];
    self.mediaPlayer = nil;
}

- (void)pause{
    [self.mediaPlayer pause];
}

- (BOOL)isPlaying
{
    return self.mediaPlayer.isPlaying;
}

//FIXME:  -  隐藏状态栏
- (void)setStatusBarHidden:(BOOL)statusBarHidden{
    _statusBarHidden = statusBarHidden;
    if(statusBarHidden) [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelStatusBar + 1];
    else [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelStatusBar - 1];
}
//FIXME:  -  重新播放
- (IBAction)rePlay:(UIButton *)sender {
    
    if (self.allowSafariPlay && sender.tag) {
        [self exitFullscreen];
        WHWebViewController *web = [[WHWebViewController alloc] init];
        //web.iPhoneXX = self.iPhoneXX;
        web.urlString = self.model.url;
        web.canDownRefresh = YES;
        web.navigationItem.title = self.model.title;
        
        UINavigationController *webVC = [[UINavigationController alloc] initWithRootViewController:web];
        //webVC.navigationBar.barTintColor = [UIColor colorWithRed:10/255 green:149/255 blue:31/255 alpha:1.0];
        //webVC.navigationBar.tintColor = [UIColor whiteColor];
        //[webVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [self.viewController?self.viewController:self.topViewController presentViewController:webVC animated:YES completion:nil];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.live_stream]];
        return;
    }
    [self playWithModel:self.model];
}

//FIXME:  -  屏幕旋转回调
- (void)changeRotate:(NSNotification*)noti {
    
    NSLog(@"playView所在的控制器:%@;topVC:%@",[self viewController],[self topViewController]);
    
    
    if(self.lockBtn.isSelected) return;
    
    if(self.state == PlayViewStateAnimating) return;
    
    // 播放器所在的控制器不是最顶层的控制器就不执行
    if([self viewController] && [self topViewController] && [self viewController] != [self topViewController]) return;
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (self.state == PlayViewStateSmall) {
        
        switch (orientation) {
            case UIDeviceOrientationLandscapeRight://home button就在左边了。
                NSLog(@"home向左");
                [self enterFullscreenLeft];
                break;
            case UIDeviceOrientationLandscapeLeft:
                NSLog(@"home向右");
                [self enterFullscreenRight];
                break;
                
            default:
                
                break;
                
        }
        
    }else  if (self.state != PlayViewStateSmall){
        switch (orientation) {
            case UIDeviceOrientationPortrait:
                NSLog(@"竖屏");
                [self exitFullscreen];
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                NSLog(@"倒屏");
                break;
            case UIDeviceOrientationLandscapeRight://home button就在左边了。
                NSLog(@"home向左");
                [self enterFullscreenLeft];
                
                
                break;
            case UIDeviceOrientationLandscapeLeft:
                NSLog(@"home向右");
                [self enterFullscreenRight];
                
                
                break;
                
            default:
                
                break;
        }
        
    }
    
}

//FIXME:  -  处理音量和亮度
- (void)verticalMoved:(CGFloat)value {
    if (self.isVolume) {
        self.volumeViewSlider.value -= value / 10000;
        return;
    }
    [UIScreen mainScreen].brightness -= value / 10000;
    self.brightnessView.brightness = [UIScreen mainScreen].brightness;
}

//FIXME:  -  快进和后退
- (void)horizontalMoved:(CGFloat)value {
    //self.isDragged = YES;
    
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    // 需要限定sumTime的范围
    NSTimeInterval totalMovieDuration = CMTimeGetSeconds(self.mediaPlayer.totalDuration);
    
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    if (value == 0) { return; }
    
    self.fastView.alpha = 1.0;
    
    
    NSTimeInterval total = totalMovieDuration;
    NSTimeInterval current = self.sumTime;
    
    
    
    NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld",(NSInteger)current/60,(NSInteger)current%60,(NSInteger)total/60,(NSInteger)total%60];
    NSString *currentTimeString = [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)current/60,(NSInteger)current%60];
    
    
    
    NSMutableAttributedString *timeAttString = [[NSMutableAttributedString alloc] initWithString:timeString];
    
    [timeAttString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, currentTimeString.length)];
    self.fastView.fastTimeLabel.attributedText = timeAttString;
    if (value > 0) { // 快进
        self.fastView.fastIconView.image = [UIImage imageFromBundleWithName:@"fullplayer_progress_r"];
    } else { // 快退
        self.fastView.fastIconView.image = [UIImage imageFromBundleWithName:@"fullplayer_progress_l"];
    }
    
    self.fastView.fastProgressView.progress = current/total;
}

//FIXME:  -  手势处理事件
- (void)panDirection:(UIPanGestureRecognizer *)pan {
    
    if(self.state == PlayViewStateSmall) return;
    if(self.lockBtn.isSelected) return;
    
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                // 取消隐藏
                self.panDirection = PanDirectionHorizontalMoved;
                // 给sumTime初值 (点播)
                if(!self.videoButtomView.isHidden) self.sumTime = CMTimeGetSeconds(self.mediaPlayer.currentTime);
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width * 0.4) {
                    self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    if(!self.videoButtomView.isHidden) [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    NSLog(@"%s--水平移动的方法只要x方向", __func__);
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    NSLog(@"%s-垂直移动方法只要y方向的值", __func__);
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    
                    if(!self.videoButtomView.isHidden){
                        [self.mediaPlayer seekTo:CMTimeMake(self.sumTime, 1)];
                        // 把sumTime滞空，不然会越加越多
                        self.sumTime = 0;
                        [UIView animateWithDuration:0.50 animations:^{
                            self.fastView.alpha = 0.0;
                        }];
                    }
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}


//- (void)panGesture:(UIPanGestureRecognizer *)sender{
//    
//
//    if(self.state == PlayViewStateSmall) return;
//    
//    if(self.lockBtn.isSelected) return;
//    
//    CGPoint point = [sender translationInView:self];
//    
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        //记录首次触摸坐标
//        self.startPoint = point;
//        //音/量
//        self.volumeValue = self.volumeViewSlider.value;
//    }else if (sender.state == UIGestureRecognizerStateChanged) {
//        //得出手指在Button上移动的距离
//        CGPoint panPoint = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
//        //分析出用户滑动的方向
//        if (panPoint.x >= 30 || panPoint.x <= -30) {
//            //进度
//            self.direction = DirectionLeftOrRight;
//        } else if (panPoint.y >= 30 || panPoint.y <= -30) {
//            //音量和亮度
//            self.direction = DirectionUpOrDown;
//        }
//        
//        if (self.direction == DirectionNone) {
//            return;
//        } else if (self.direction == DirectionUpOrDown) {
//            
//            //音量
//            if (panPoint.y < 0) {
//                //增大音量
//                [self.volumeViewSlider setValue:self.volumeValue + (-panPoint.y / 30.0 / 10) animated:YES];
//                if (self.volumeValue + (-panPoint.y / 30 / 10) - self.volumeViewSlider.value >= 0.1) {
//                    [self.volumeViewSlider setValue:0.1 animated:NO];
//                    [self.volumeViewSlider setValue:self.volumeValue + (-panPoint.y / 30.0 / 10) animated:YES];
//                }
//                
//            } else {
//                //减少音量
//                [self.volumeViewSlider setValue:self.volumeValue - (panPoint.y / 30.0 / 10) animated:YES];
//            }
//            
//        }
//        
//    }
//    
//}
- (IBAction)videoViewMode:(UIButton *)sender {
    
    static UIViewContentMode modes[] = {
        UIViewContentModeScaleAspectFit,
        UIViewContentModeScaleToFill,
        UIViewContentModeScaleAspectFill
    };
    static int curModeIdx = 0;
    curModeIdx = (curModeIdx + 1) % (int)(sizeof(modes)/sizeof(modes[0]));
    self.mediaPlayer.playerView.contentMode = modes[curModeIdx];
    
}
//FIXME:  -  视频触摸的回调
- (void)handleTapGesture{
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenControll) object:nil];
    if (self.buttomView.isHidden) {//不隐藏的时候
        [self performSelector:@selector(hiddenControll) withObject:nil afterDelay:5.0];
    }
    
    
    if (self.state == PlayViewStateSmall) {
        self.buttomView.hidden = !self.buttomView.isHidden;
        return;
    }
    self.lockBtn.hidden =  !self.lockBtn.isHidden;
    self.fullProgressView.hidden = !self.lockBtn.isHidden;
    self.fullBufView.hidden = self.fullProgressView.isHidden;
    
    if (self.lockBtn.isSelected)  return;
    self.topView.hidden = !self.buttomView.isHidden;
    self.buttomView.hidden = !self.buttomView.isHidden;
    self.statusBarHidden = self.buttomView.isHidden;
    self.modeButton.hidden = self.buttomView.isHidden;
    
}

//FIXME:  -  隐藏工具菜单
- (void)hiddenControll{
    
    if (self.state == PlayViewStateSmall) {
        self.buttomView.hidden = YES;
        return;
    }
    
    self.lockBtn.hidden =  YES;
    // min 进度 打开
    self.fullProgressView.hidden = NO;
    self.fullBufView.hidden = NO;
    
    if (self.lockBtn.isSelected)  return;
    self.topView.hidden = YES;
    self.buttomView.hidden = YES;
    self.statusBarHidden = YES;
    self.modeButton.hidden = YES;
    
}

//FIXME:  -  返回
- (IBAction)backAction {
    [self fullAciton:self.fullButton];
}
//FIXME:  -  全屏
- (IBAction)fullAciton:(UIButton *)sender {
    
    if (self.state == PlayViewStateSmall) {
        [self enterFullscreenRight];
        self.buttomView.hidden = NO;
        self.topView.hidden = NO;
        sender.selected = YES;
    }
    else if (self.state != PlayViewStateSmall) {
        [self exitFullscreen];
        self.buttomView.hidden = YES;
        self.topView.hidden = YES;
        sender.selected = NO;
    }
}
//FIXME:  -  🔐屏
- (IBAction)lockScrrenAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.topView.hidden = !self.buttomView.isHidden;
    self.buttomView.hidden = !self.buttomView.isHidden;
    self.statusBarHidden = self.buttomView.isHidden;
    self.modeButton.hidden = self.buttomView.isHidden;
    
}

//FIXME:  -  向左
- (void)enterFullscreenLeft {
    
    self.lockBtn.hidden = NO;
    self.modeButton.hidden = NO;
    self.buttomView.hidden = NO;
    self.topView.hidden = NO;
    self.fullButton.selected = YES;
    
    if (self.state == PlayViewStateFullScreenLeft) {
        return;
    }
    
    UIViewController *currViewController = self.viewController ? self.viewController : self.topViewController;
    currViewController.spHomeIndicatorAutoHidden = YES;
    
    
    self.state = PlayViewStateAnimating;
    
    /*
     * 记录进入全屏前的parentView和frame
     */
    if(CGRectEqualToRect(CGRectZero, self.playViewSmallFrame)) {
        self.playViewSmallFrame = self.frame;
        self.playViewParentView = self.superview;
    }
    /*
     * movieView移到window上
     */
    CGRect rectInWindow = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
    [self removeFromSuperview];
    self.frame = rectInWindow;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    /*
     * 执行动画
     */
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.bounds = CGRectMake(0, 0, CGRectGetHeight(self.superview.bounds), CGRectGetWidth(self.superview.bounds));
        self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
        
        
    } completion:^(BOOL finished) {
        self.state = PlayViewStateFullScreenLeft;
    }];
    
    [self refreshStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
}

//FIXME:  -  向右
- (void)enterFullscreenRight {
    
    self.lockBtn.hidden = NO;
    self.modeButton.hidden = NO;
    self.buttomView.hidden = NO;
    self.topView.hidden = NO;
    self.fullButton.selected = YES;
    
    if (self.state == PlayViewStateFullScreenRight) {
        return;
    }
    
    UIViewController *currViewController = self.viewController ? self.viewController : self.topViewController;
    currViewController.spHomeIndicatorAutoHidden = YES;
    
    
    self.state = PlayViewStateAnimating;
    
    /*
     * 记录进入全屏前的parentView和frame
     */
    if(CGRectEqualToRect(CGRectZero, self.playViewSmallFrame)) {
        self.playViewSmallFrame = self.frame;
        self.playViewParentView = self.superview;
    }
    /*
     * movieView移到window上
     */
    CGRect rectInWindow = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
    [self removeFromSuperview];
    self.frame = rectInWindow;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    /*
     * 执行动画
     */
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.bounds = CGRectMake(0, 0, CGRectGetHeight(self.superview.bounds), CGRectGetWidth(self.superview.bounds));
        self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
        
        
    } completion:^(BOOL finished) {
        self.state = PlayViewStateFullScreenRight;
    }];
    
    [self refreshStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
}
//FIXME:  -  竖屏
- (void)exitFullscreen {
    self.lockBtn.hidden = YES;
    self.modeButton.hidden = YES;
    self.buttomView.hidden = YES;
    self.topView.hidden = YES;
    self.fullButton.selected = NO;
    
    if (self.state == PlayViewStateSmall) {
        return;
    }
    
    UIViewController *currViewController = self.viewController ? self.viewController : self.topViewController;
    currViewController.spHomeIndicatorAutoHidden = NO;
    
    self.state = PlayViewStateAnimating;
    
    CGRect frame = [self.playViewParentView convertRect:self.playViewSmallFrame toView:[UIApplication sharedApplication].keyWindow];
    
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformIdentity;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        /*
         * movieView回到小屏位置
         */
        [self removeFromSuperview];
        self.frame = self.playViewSmallFrame;
        [self.playViewParentView addSubview:self];
        self.state = PlayViewStateSmall;
        self.statusBarHidden = NO;
    }];
    
    [self refreshStatusBarOrientation:UIInterfaceOrientationPortrait];
}
//FIXME:  -  旋转状态栏
- (void)refreshStatusBarOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:YES];
    [self.topView setNeedsLayout];
    [self.topView layoutIfNeeded];
    
    NSLog(@"%s--%@", __func__,NSStringFromCGRect(self.topView.frame));
    NSLog(@"%s--%@", __func__,NSStringFromCGRect(self.frame));
    
}


#pragma mark  -  get/set 方法
- (PLPlayer *)mediaPlayer{
    if (!_mediaPlayer) {
        //        //创建播放器
        //        _mediaPlayer = [[AliVcMediaPlayer alloc] init];
        //        //创建播放器视图，其中contentView为UIView实例，自己根据业务需求创建一个视图即可
        //        /*self.mediaPlayer:NSObject类型，需要UIView来展示播放界面。
        //         self.contentView：承载mediaPlayer图像的UIView类。
        //         self.contentView = [[UIView alloc] init];
        //         [self.view addSubview:self.contentView];
        //         */
        //        //self.contentView = [[UIView alloc] init];
        //
        //        //[_mediaPlayer create:self.contentView];
        //        [_mediaPlayer create:self.contentView];
        //
        //        //设置播放类型，0为点播、1为直播，默认使用自动
        //        _mediaPlayer.mediaType = MediaType_AUTO;
        //        //设置超时时间，单位为毫秒
        //        _mediaPlayer.timeout = 20000;
        //        //缓冲区超过设置值时开始丢帧，单位为毫秒。直播时设置，点播设置无效。范围：500～100000
        //        _mediaPlayer.dropBufferDuration = 8000;
        //
        [self addNotification];
        
        //如果要切换视频需要调AVPlayer的replaceCurrentItemWithPlayerItem:方法
        //        _mediaPlayer = [AVPlayer playerWithPlayerItem:nil];
        //        if (@available(iOS 10.0, *)) {
        //            _mediaPlayer.automaticallyWaitsToMinimizeStalling = NO;
        //        }
        //
        //        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_mediaPlayer];
        //        playerLayer.frame = self.contentView.bounds;
        //        [self.contentView.layer addSublayer:playerLayer];
        //        self.playerLayer = playerLayer;
        //
        NSError *error = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        
        // 初始化 PLPlayerOption 对象
        PLPlayerOption *option = [PLPlayerOption defaultOption];
        
        // 更改需要修改的 option 属性键所对应的值
        [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
        [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
        [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
        [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
        [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
        //[option setOptionValue:@(YES) forKey:PLPlayerOptionKeyVODFFmpegEnable];
        // 初始化 PLPlayer
        _mediaPlayer = [PLPlayer playerWithURL:nil option:option];
        _mediaPlayer.delegate = self;
        [self.contentView insertSubview:_mediaPlayer.playerView atIndex:0];
        _mediaPlayer.playerView.frame = self.contentView.bounds;
        _mediaPlayer.playerView.contentMode = UIViewContentModeScaleAspectFit;
        _mediaPlayer.backgroundPlayEnable = YES;
        // 增加下面这行可以解决iOS10兼容性问题了
        if (@available(iOS 10.0, *)) {
        _mediaPlayer.avplayer.automaticallyWaitsToMinimizeStalling = NO;
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    return _mediaPlayer;
}

- (void)addNotification{
    // 监听耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initaudioRouteChangeObserver:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    //进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    //进入后他
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil ];

//    //一、播放器初始化视频文件完成通知，调用prepareToPlay函数，会发送该通知，代表视频文件已经准备完成，此时可以在这个通知中获取到视频的相关信息，如视频分辨率，视频时长等
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnVideoPrepared:)
//                                                 name:AliVcMediaPlayerLoadDidPreparedNotification object:self.mediaPlayer];
//    //二、播放完成通知。视频正常播放完成时触发。
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnVideoFinish:)
//                                                 name:AliVcMediaPlayerPlaybackDidFinishNotification object:self.mediaPlayer];
//    //三、播放器播放失败发送该通知，并在该通知中可以获取到错误码。
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnVideoError:)
//                                                 name:AliVcMediaPlayerPlaybackErrorNotification object:self.mediaPlayer];
//    //四、播放器Seek完成后发送该通知。
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnSeekDone:)
//                                                 name:AliVcMediaPlayerSeekingDidFinishNotification object:self.mediaPlayer];
//    //五、播放器开始缓冲视频时发送该通知，当播放网络文件时，网络状态不佳或者调用seekTo时，此通知告诉用户网络下载数据已经开始缓冲。
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnStartCache:)
//                                                 name:AliVcMediaPlayerStartCachingNotification object:self.mediaPlayer];
//    //六、播放器结束缓冲视频时发送该通知，当数据已经缓冲完，告诉用户已经缓冲结束，来更新相关UI显示。
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnEndCache:)
//                                                 name:AliVcMediaPlayerEndCachingNotification object:self.mediaPlayer];
//    //七、播放器主动调用Stop功能时触发。
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onVideoStop:)
//                                                 name:AliVcMediaPlayerPlaybackStopNotification object:self.mediaPlayer];
//    //八、播放器状态首帧显示后发送的通知。
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onVideoFirstFrame:)
//                                                 name:AliVcMediaPlayerFirstFrameNotification object:self.mediaPlayer];
//    //九、播放器开启循环播放功能，开始循环播放时发送的通知。
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onCircleStart:)
//                                                 name:AliVcMediaPlayerCircleStartNotification object:self.mediaPlayer];
    
}

- (NSTimer *)timer{
    if (!_timer) {
        __weak typeof(self) weakSelf = self;
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.25 target:weakSelf selector:@selector(timeChange:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

- (SpeedMonitor *)speedMonitor{
    if (!_speedMonitor) {
        _speedMonitor = [[SpeedMonitor alloc] init];
        [_speedMonitor startNetworkSpeedMonitor];
    }
    return _speedMonitor;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (! newSuperview && self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
//FIXME:  -  定时刷新进度
- (void)timeChange:(NSTimer *)sender{
    
    if(self.progressDragging) return;
    
    NSTimeInterval total = CMTimeGetSeconds(self.mediaPlayer.totalDuration);
    NSTimeInterval current = CMTimeGetSeconds(self.mediaPlayer.currentTime);
    
    
    NSArray *array = self.mediaPlayer.avplayerItem.loadedTimeRanges;
    CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
    double startSeconds = CMTimeGetSeconds(timeRange.start);
    double durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
    
    
    self.progressView.progress = totalBuffer / total;
    self.videoSlider.value = current / total;
    
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld",(NSInteger)current/60,(NSInteger)current%60,(NSInteger)total/60,(NSInteger)total%60];
    
    self.fullProgressView.progress = self.videoSlider.value;
    self.fullBufView.progress = self.progressView.progress;
    
    self.networkSpeedLabel.text = self.speedMonitor.downloadNetworkSpeed;
    
    
    if(!self.rePlayCount && self.mediaPlayer.status != PLPlayerStatusPaused && self.mediaPlayer.status != PLPlayerStatusPlaying && totalBuffer > (2+current) ){
     NSLog(@"%s=================================禅师播放================================PLPlayerStatusCaching --%f ---%f=================================================================", __func__,totalBuffer,current);
        [self.mediaPlayer play];
        self.rePlayCount = 10;
    }
    
    if(self.rePlayCount) self.rePlayCount--;
    
    int progress = (totalBuffer - current) * 1000 / 45.0;
    if (self.loadingView.isAnimating && ![self.loadingLabel.text isEqualToString:@"(100%)"] && progress < 100 && (progress > 0)) {
        NSLog(@"加载进度：%d%%", progress);
        self.loadingLabel.text = [NSString stringWithFormat:@"(%d%%)",progress];
    }

}

- (void)tryReconnect:(nullable NSError *)error {
    if (self.reconnectCount < 2) {
        _reconnectCount ++;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * pow(2, self.reconnectCount) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.mediaPlayer play];
        });
    }else {
        [self OnVideoError:error];
    }
}


- (void)player:(nonnull PLPlayer *)player codecError:(nonnull NSError *)error{
    [self OnVideoError:error];
}
- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error{
    [self tryReconnect:error];
}
static NSString *status[] = {
    @"PLPlayerStatusUnknow",
    @"PLPlayerStatusPreparing",
    @"PLPlayerStatusReady",
    @"PLPlayerStatusOpen",
    @"PLPlayerStatusCaching",
    @"PLPlayerStatusPlaying",
    @"PLPlayerStatusPaused",
    @"PLPlayerStatusStopped",
    @"PLPlayerStatusError",
    @"PLPlayerStatusCompleted"
};
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state{

    if(state ==  PLPlayerStatusUnknow){
    //PLPlayerStatusUnknow = 0,PLPlayer 未知状态，只会作为 init 后的初始状态，开始播放之后任何情况下都不会再回到此状态
    }else if (state == PLPlayerStatusPreparing){
    //PLPlayerStatusPreparing,PLPlayer 正在准备播放所需组件，在调用 -play 方法时出现。

    }else if (state == PLPlayerStatusReady){

    //PLPlayerStatusReady,PLPlayer 播放组件准备完成，准备开始播放，在调用 -play 方法时出现
    }else if (state == PLPlayerStatusCaching){

    //PLPlayerStatusCaching,PLPlayer 缓存数据为空状态。
        [self OnStartCache:nil];
    }else if (state == PLPlayerStatusPlaying){

    //PLPlayerStatusPlaying,PLPlayer 正在播放状态。
        [self OnVideoPrepared:nil];
        [self OnEndCache:nil];
    }else if (state == PLPlayerStatusPaused){

    //PLPlayerStatusPaused,PLPlayer 暂停状态。

    }else if (state == PLPlayerStatusStopped){

    //PLPlayerStatusStopped,PLPlayer 停止状态

    }else if (state == PLPlayerStatusError){
        [self OnVideoError:nil];
    //PLPlayerStatusError,PLPlayer 错误状态，播放出现错误时会出现此状态。
    
    }else if (state == PLPlayerStateAutoReconnecting){

    //PLPlayerStateAutoReconnecting PLPlayer 自动重连的状态
    }
    NSLog(@"PLPlayerState---%@---", status[state]);
}




#pragma mark  - 获取到视频的相关信息
- (void)OnVideoPrepared:(NSNotification *)noti{
    NSLog(@"%s--获取到视频的相关信息--时长：%f秒", __func__,CMTimeGetSeconds(self.mediaPlayer.totalDuration));
    //视频的总时间
    NSTimeInterval total = CMTimeGetSeconds(self.mediaPlayer.totalDuration);
    NSTimeInterval current = CMTimeGetSeconds(self.mediaPlayer.currentTime);

    BOOL islive = !(total > 0);
    self.videoButtomView.hidden = islive;
//    if(islive){
//        self.fullBufView = nil;
//        self.fullProgressView = nil;
//    }
    self.fullBufView.alpha = (CGFloat)!islive;
    self.fullProgressView.alpha = self.fullBufView.alpha;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld",(NSInteger)current/60,(NSInteger)current%60,(NSInteger)total/60,(NSInteger)total%60];
    self.reconnectCount = 0;
}

#pragma mark  - 视频正常播放完成
- (void)OnVideoFinish:(NSNotification *)noti{
    //    NSLog(@"%s--视频正常播放完成", __func__);
}

#pragma mark  - 播放器播放失败
- (void)OnVideoError:(NSError *)error{
    NSLog(@"%s--播放器播放失败--%@", __func__,error.localizedDescription);
    //NSString *errorMsg = [noti.userInfo valueForKey:@"errorMsg"];
    NSString *errorMsg = error.localizedDescription;//[self error:[NSString stringWithFormat:@"%@",self.mediaPlayer.currentItem.error.localizedDescription]];
    errorMsg = errorMsg? errorMsg : @"未知错误";
    
    if (self.allowSafariPlay) {
        [self.errorBtn setTitle:[NSString stringWithFormat:@"%@\n(推荐使用万能极速播放)",errorMsg] forState:UIControlStateNormal];
    }else{
        [self.errorBtn setTitle:[NSString stringWithFormat:@"%@\n(重新播放或切换视频源)",errorMsg] forState:UIControlStateNormal];
    }
    
    self.errorBtn.hidden = NO;
    
    [self.loadingView stopAnimating];
    self.loadingLabel.hidden = self.loadingView.isHidden;
    
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark  - 播放器Seek完成后
- (void)OnSeekDone:(NSNotification *)noti{
    //    NSLog(@"%s--播放器Seek完成后", __func__);
}

#pragma mark  - 播放器开始缓冲视频时
- (void)OnStartCache:(NSNotification *)noti{
    NSLog(@"%s--播放器开始缓冲视频时", __func__);
    //!(_playerLoading)? : _playerLoading();
    [self.loadingView startAnimating];
    //self.loadingLabel.text = @"缓存中...";
    self.loadingLabel.text = [NSString stringWithFormat:@"(0%%)"];
    self.loadingLabel.hidden = self.loadingView.isHidden;
    self.errorBtn.hidden = !self.loadingView.isHidden;
    
}

#pragma mark  - 播放器结束缓冲视频
- (void)OnEndCache:(NSNotification *)noti{
    NSLog(@"%s--播放器结束缓冲视频", __func__);

    self.loadingLabel.text = [NSString stringWithFormat:@"(100%%)"];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.loadingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.loadingView stopAnimating];
        self.loadingLabel.hidden = self.loadingView.isHidden;
        self.errorBtn.hidden = YES;
        self.loadingView.alpha = 1.0;
    }];
    
    //if(self.mediaPlayer.duration) [self timer];
    
    NSTimeInterval current = CMTimeGetSeconds(self.mediaPlayer.currentTime);
    
    NSArray *array = self.mediaPlayer.avplayerItem.loadedTimeRanges;
    CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
    double startSeconds = CMTimeGetSeconds(timeRange.start);
    double durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度

    NSLog(@"%s--播放器结束缓冲视频 - %f -%f -%f", __func__,totalBuffer,current, totalBuffer-current);

}

#pragma mark  - 播放器主动调用Stop功能
- (void)onVideoStop:(NSNotification *)noti{
    //    NSLog(@"%s--播放器主动调用Stop功能", __func__);
}

#pragma mark  - 播放器状态首帧显示
- (void)onVideoFirstFrame:(NSNotification *)noti{
    //    NSLog(@"%s--播放器状态首帧显示", __func__);
    //    //!(_playerCompletion)? : _playerCompletion();
    //    if(self.mediaPlayer.duration) {[self timer];self.errorBtn.hidden = YES;}
}

#pragma mark  - 播放器开启循环播放
- (void)onCircleStart:(NSNotification *)noti{
    //    NSLog(@"%s--播放器开启循环播放", __func__);
}

//FIXME:  -  耳机插入拔出
- (void)initaudioRouteChangeObserver:(NSNotification *)notification {
    NSDictionary *interuptionDict = [notification userInfo];
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable: {
            // 耳机拔掉
            break;
        }
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}
//FIXME:  -  前台
- (void)applicationDidBecomeActive {
    if (!self.isPlaying) {
        [self play];
    }
}

//FIXME:  -  即将进入后台
- (void)applicationWillResignActive {
//    [self pause];
}


//FIXME:  -  get/set 方法

- (UIView *)videoButtomView{
    if (!_videoButtomView) {
        _videoButtomView = [[UIView alloc] init];
        _videoButtomView.hidden = YES;
    }
    return _videoButtomView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _progressView.trackTintColor    = [UIColor clearColor];
        //_progressView.progress = 0.76;
    }
    return _progressView;
}

- (SPVideoSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[SPVideoSlider alloc] init];
        [_videoSlider setMinimumTrackImage:[UIImage imageFromBundleWithName:@"fullplayer_progressbar_n_171x3_"] forState:UIControlStateNormal];
        [_videoSlider setThumbImage:[UIImage imageFromBundleWithName:@"fullplayer_slider_iphone_12x15_"] forState:UIControlStateNormal];
        
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        //_videoSlider.value = 0.6;
        //_videoSlider.backgroundColor = [UIColor orangeColor];
        [_videoSlider addTarget:self action:@selector(videoDurationChange:) forControlEvents:UIControlEventTouchUpInside];
        [_videoSlider addTarget:self action:@selector(progressDraggBegin:) forControlEvents:UIControlEventTouchDown];
        
        [_videoSlider addGestureRecognizer:({
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(progressSliderTapped:)];
            tap;
        })];
    }
    return _videoSlider;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.text = @"00:00/00:00";
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

- (UIButton *)playOrPauseButton {
    
    if (!_playOrPauseButton) {
        _playOrPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseButton setImage:[UIImage imageFromBundleWithName:@"fullplayer_icon_pause"] forState:UIControlStateSelected];
        [_playOrPauseButton setImage:[UIImage imageFromBundleWithName:@"fullplayer_icon_play"] forState:UIControlStateNormal];
        _playOrPauseButton.selected = YES;
        [_playOrPauseButton addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _playOrPauseButton;
}
/** 音量的view */
- (MPVolumeView *)volumeView {
    if (_volumeView == nil) {
        _volumeView  = [[MPVolumeView alloc] init];
        
        [_volumeView sizeToFit];
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeViewSlider = (UISlider*)view;
                break;
            }
        }
    }
    return _volumeView;
}

/** 亮度的view */
- (SPBrightnessView *)brightnessView {
    if (!_brightnessView) {
        _brightnessView = [[SPBrightnessView alloc] init];
    }
    return _brightnessView;
}

- (UIButton *)rePlayButton{
    if(!_rePlayButton){
        _rePlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rePlayButton setImage:[UIImage imageFromBundleWithName:@"fullplayer_icon_replay"] forState:UIControlStateNormal];
        [_rePlayButton setTitle:@"重新播放" forState:UIControlStateNormal];
        [_rePlayButton setTitleEdgeInsets:UIEdgeInsetsMake(50, -125, 0, -80)];
        _rePlayButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        _rePlayButton.tag = 0;
        _rePlayButton.showsTouchWhenHighlighted = YES;
        [_rePlayButton addTarget:self action:@selector(rePlay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rePlayButton;
}
- (UIButton *)safariButton{
    if(!_safariButton){
        _safariButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_safariButton setImage:[UIImage imageFromBundleWithName:@"fullplayer_icon_safari"] forState:UIControlStateNormal];
        [_safariButton setTitle:@"极速播放" forState:UIControlStateNormal];
        [_safariButton setTitleEdgeInsets:UIEdgeInsetsMake(50, -125, 0, -80)];
        _safariButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        _safariButton.tag = 1;
        _safariButton.showsTouchWhenHighlighted = YES;
        [_safariButton addTarget:self action:@selector(rePlay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _safariButton;
}
/** 快进快退的view */
- (SPVideoPlayerFastView *)fastView {
    if (!_fastView) {
        _fastView                     = [[SPVideoPlayerFastView alloc] init];
        _fastView.backgroundColor     =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.618];
        _fastView.layer.cornerRadius  = 10;
        _fastView.layer.masksToBounds = YES;
        _fastView.alpha = 0.0;
    }
    return _fastView;
}

- (WKWebView *)danmuView{
    if (_danmuView) return _danmuView;
    _danmuView = [[WKWebView alloc] initWithFrame:CGRectZero];
    _danmuView.backgroundColor = [UIColor clearColor];
    _danmuView.scrollView.backgroundColor = [UIColor clearColor];
    _danmuView.opaque = NO;
    _danmuView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
    tap.delegate = self;
    
    _danmuView.scrollView.scrollEnabled = NO;
    [_danmuView addGestureRecognizer:tap];
    _danmuView.navigationDelegate = self;
    _danmuView.UIDelegate = self;
    
    return _danmuView;
}


//- (NSString *)error:(NSString *)code{
//
//    NSDictionary * errorDic = @{
//                                @"4500":@"请求错误",
//                                @"4501":@"数据错误",
//                                @"4502":@"请求saas服务器错误",
//                                @"4503":@"请求mts服务器错误",
//                                @"4504":@"服务器返回参数无效",
//                                @"4521":@"非法的播放器状态",
//                                @"4022":@"没有设置显示窗口，请先设置播放视图",
//                                @"4023":@"内存不足",
//                                @"4024":@"系统权限被拒绝",
//                                @"4101":@"视频下载时连接不到服务器",
//                                @"4102":@"视频下载时网络超时",
//                                @"4103":@"请求saas服务器错误",
//                                @"4104":@"请求mts服务器错误",
//                                @"4105":@"服务器返回参数无效",
//                                @"4106":@"视频下载流无效或地址过期",
//                                @"4107":@"未找到加密文件，请从控制台下载加密文件并集成",
//                                @"4108":@"获取秘钥失败，请检查秘钥文件",
//                                @"4109":@"下载地址无效",
//                                @"4110":@"磁盘空间不够",
//                                @"4111":@"视频文件保存路径不存在，请重新设置",
//                                @"4112":@"当前视频不可下载",
//                                @"4113":@"下载模式改变无法继续下载",
//                                @"4114":@"当前视频已经添加到下载项，请避免重复添加",
//                                @"4115":@"未找到合适的下载项，请先添加",
//                                @"4001":@"参数非法",
//                                @"4002":@"鉴权过期",
//                                @"4003":@"视频源格式不支持",
//                                @"4004":@"视频源不存在",
//                                @"4005":@"读取视频源失败",
//                                @"4008":@"加载超时",
//                                @"4009":@"请求数据错误",
//
//                                @"4011":@"视频格式不支持",
//                                @"4012":@"解析失败",
//                                @"4013":@"解码失败",
//                                @"4019":@"编码格式不支持",
//                                @"4400":@"未知错误",
//
//                                };
//    NSString *msg = errorDic[code];
//
//    return msg?msg : @"未知错误";
//}


//FIXME:  -  事件监听
- (void)videoDurationChange:(SPVideoSlider *)sender{
    self.progressDragging = NO;
    [self.mediaPlayer seekTo:CMTimeMake(sender.value * CMTimeGetSeconds(self.mediaPlayer.totalDuration), 1)];
}
- (void)progressDraggBegin:(SPVideoSlider *)sender{
    self.progressDragging = YES;
}
-(void)progressSliderTapped:(UIGestureRecognizer *)g
{
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted) return;
    CGPoint pt = [g locationInView:s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
    [self.mediaPlayer seekTo:CMTimeMake(s.value * CMTimeGetSeconds(self.mediaPlayer.totalDuration), 1)];
}

- (void)playOrPause:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        [self play];
        
    }else{
        [self pause];
    }
}


@end

/////////////

@implementation UITabBarController (Player)
//FIXME:  -  旋转 状态栏
- (BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (BOOL)prefersStatusBarHidden{
    return self.selectedViewController.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.selectedViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return self.selectedViewController.preferredStatusBarUpdateAnimation;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return self.selectedViewController.prefersHomeIndicatorAutoHidden;
}
@end
@implementation UINavigationController (Player)
//FIXME:  -  旋转 状态栏
- (BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return self.topViewController.supportedInterfaceOrientations;
}

- (BOOL)prefersStatusBarHidden{
    return self.topViewController.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.topViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return self.topViewController.preferredStatusBarUpdateAnimation;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return self.topViewController.prefersHomeIndicatorAutoHidden;
}
@end
static char kSPStatusBarStyleKey;
static char kSPStatusBarHiddenKey;
static char kSPHomeIndicatorAutoHiddenKey;
@implementation UIViewController (Player)
//FIXME:  -  旋转 状态栏
- (BOOL)shouldAutorotate{
    
    NSString *className = NSStringFromClass([self class]);
    NSArray * fullScreenViewControllers = @[
                                            @"UIViewController",
                                            @"WHWebViewController",
                                            @"AVPlayerViewController",
                                            @"AVFullScreenViewController",
                                            @"AVFullScreenPlaybackControlsViewController"
                                            ];
    if ([fullScreenViewControllers containsObject:className]){
        return YES;
    }
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    NSString *className = NSStringFromClass([self class]);
    NSArray * fullScreenViewControllers = @[
                                            @"UIViewController",
                                            @"WHWebViewController",
                                            @"AVPlayerViewController",
                                            @"AVFullScreenViewController",
                                            @"AVFullScreenPlaybackControlsViewController"
                                            ];
    if ([fullScreenViewControllers containsObject:className]){
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden{
    return self.spStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.spStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationFade;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return self.spHomeIndicatorAutoHidden;
}
// statusBarStyle
- (UIStatusBarStyle)spStatusBarStyle {
    id style = objc_getAssociatedObject(self, &kSPStatusBarStyleKey);
    return (UIStatusBarStyle)(style != nil) ? [style integerValue] : UIStatusBarStyleLightContent;
}
- (void)setSpStatusBarStyle:(UIStatusBarStyle)spStatusBarStyle{
    objc_setAssociatedObject(self, &kSPStatusBarStyleKey, @(spStatusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];
}

//StatusBarHidden
- (BOOL)spStatusBarHidden {
    id isHidden = objc_getAssociatedObject(self, &kSPStatusBarHiddenKey);
    return (isHidden != nil) ? [isHidden boolValue] : NO;
}
- (void)setSpStatusBarHidden:(BOOL)spStatusBarHidden{
    objc_setAssociatedObject(self, &kSPStatusBarHiddenKey, @(spStatusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];
}
//HomeIndicatorAutoHidden
- (BOOL)spHomeIndicatorAutoHidden {
    id isHidden = objc_getAssociatedObject(self, &kSPHomeIndicatorAutoHiddenKey);
    return (isHidden != nil) ? [isHidden boolValue] : NO;
}
- (void)setSpHomeIndicatorAutoHidden:(BOOL)spHomeIndicatorAutoHidden{
    objc_setAssociatedObject(self, &kSPHomeIndicatorAutoHiddenKey, @(spHomeIndicatorAutoHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    }
}
@end


@implementation UIView (Player)
//FIXME:  -  View获取所在的Controller
- (UIViewController *)viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
        
    }
    return resultVC;
}
- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
@end
@implementation NSObject (StatusBar)

- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end







