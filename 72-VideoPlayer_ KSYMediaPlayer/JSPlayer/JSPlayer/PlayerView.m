//
//  PlayView.m
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "PlayerView.h"
#import "SPVideoSlider.h"

#import <KSYMediaPlayer/KSYMediaPlayer.h>
#import <MediaPlayer/MediaPlayer.h>
#import <SafariServices/SafariServices.h>
#import <objc/runtime.h>

#define  kScreenWidth [UIScreen mainScreen].bounds.size.width
#define  kScreenHeight [UIScreen mainScreen].bounds.size.height
#define  iPhoneXX (kScreenHeight == 375.f && kScreenWidth == 812.f ? YES : NO)

typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
};





@interface PlayerView()

@property (nonatomic, strong) KSYMoviePlayerController *mediaPlayer;

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

@property (weak, nonatomic) IBOutlet UIButton *lockBtn;

/*静默进度条 */
@property (weak, nonatomic) IBOutlet UIProgressView *fullProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *fullBufView;


@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) CGFloat volumeValue;
@property (assign, nonatomic) Direction direction;
/*流量监控*/
@property (weak, nonatomic) IBOutlet UILabel *networkSpeedLabel;

/** 是否正在拖 */
@property (nonatomic, assign) BOOL progressDragging;

/** 切换模式 */
@property (weak, nonatomic) IBOutlet UIButton *modeButton;

/** 重试 */
@property (strong, nonatomic)  UIButton *rePlayButton;

/** 浏览器 */
@property (strong, nonatomic)  UIButton *safariButton;


@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, strong) NSArray *status;
@property (nonatomic, strong) NSArray *loadStatus;
@property (nonatomic, assign) long long int prepared_time;
@property (nonatomic, assign) NSTimeInterval lastCheckTime;
@property (nonatomic, assign) double lastSize;
@property (nonatomic, assign) int fvr_costtime;
@property (nonatomic, assign) int far_costtime;
@end


@implementation VideoModel
@end
@implementation PlayerView


//FIXME:  -  生命周期
+ (instancetype)playerView{
    return [[NSBundle mainBundle] loadNibNamed:@"PlayerView" owner:nil options:nil].firstObject;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
    
    _loadStatus = @[@"加载情况未知",@"加载完成，可以播放",@"加载完成，如果shouldAutoplay为YES，将自动开始播放",@"",@"如果视频正在加载中"];
    _status = @[@"播放停止",@"正在播放",@"播放暂停",@"播放被打断",@"向前seeking中",@"向后seeking中"];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:pan];
    
    
    [self.buttomView addSubview:self.videoButtomView];
    [self.videoButtomView addSubview:self.playOrPauseButton];
    [self.videoButtomView addSubview:self.timeLabel];
    [self.videoButtomView addSubview:self.progressView];
    [self.videoButtomView addSubview:self.videoSlider];
    
    [self.errorBtn addSubview:self.rePlayButton];
    [self.errorBtn addSubview:self.safariButton];

    
    [self initUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)initUI{
    self.errorBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    self.topBgView.image = [UIImage imageFromBundleWithName:@"fullplayer_bg_top"];
    [self.backButton setImage:[UIImage imageFromBundleWithName:@"fullplayer_icon_back"] forState:UIControlStateNormal];
    
    self.buttomBgView.image = [UIImage imageFromBundleWithName:@"fullplayer_bg_buttom"];
    [self.fullButton setImage:[UIImage imageFromBundleWithName:@"fullplayer_icon_small"] forState:UIControlStateNormal];
    [self.fullButton setImage:[UIImage imageFromBundleWithName:@"fullplayer_icon_full"] forState:UIControlStateSelected];
    
    [self.lockBtn setImage:[UIImage imageFromBundleWithName:@"fullplayer_lockScreen_off_iphone_44x44_"] forState:UIControlStateNormal];
    [self.lockBtn setImage:[UIImage imageFromBundleWithName:@"fullplayer_lockScreen_on_iphone_44x44_"] forState:UIControlStateSelected];
    
    [self.modeButton setImage:[UIImage imageFromBundleWithName:@"fullplayer_icon_mode"] forState:UIControlStateNormal];
    
}

- (void)layout{
    CGFloat spacing = iPhoneXX? 24 : 0;
    
    self.contentView.frame = self.bounds;
    
    self.volumeView.frame = CGRectMake(0, 0, kScreenWidth ,kScreenWidth* 9.0 / 16.0);
    
    self.loadingView.center = CGPointMake(self.bounds.size.width * 0.5 - 30, self.bounds.size.height * 0.5);
    self.loadingLabel.frame = CGRectMake(CGRectGetMaxX(self.loadingView.frame) + 5, self.loadingView.frame.origin.y, 50, self.loadingView.frame.size.height);
    
    self.lockBtn.frame = CGRectMake(0, 0, 70, 70);
    self.lockBtn.center = CGPointMake(35+spacing, self.loadingView.center.y);
    self.modeButton.frame = CGRectMake(0, 0, 70, 70);
    self.modeButton.center = CGPointMake(self.bounds.size.width - (35+spacing), self.lockBtn.center.y);
    self.errorBtn.center = CGPointMake(self.loadingView.center.x + 30, self.loadingView.center.y );
    
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
    
    self.buttomView.frame = CGRectMake(0, self.bounds.size.height - 64, self.bounds.size.width, 64);
    self.buttomBgView.frame = self.buttomView.bounds;
    self.fullButton.frame = CGRectMake(self.buttomView.bounds.size.width - 44-spacing, self.buttomView.bounds.size.height - 44, 44, 44);
    
    self.videoButtomView.frame = CGRectMake(spacing, self.buttomView.bounds.size.height - 44, self.buttomView.bounds.size.width - 44 - 2 * spacing, 44);
    self.playOrPauseButton.frame = CGRectMake(0, 0, 44, 44);
    self.timeLabel.frame = CGRectMake(44, 0, 75, 44);
    self.progressView.frame = CGRectMake(44 + 75+10, 0, self.videoButtomView.bounds.size.width - 44 - 75-10, 44);
    self.progressView.center = CGPointMake(self.progressView.center.x, self.videoButtomView.bounds.size.height * 0.5);
    self.videoSlider.frame = CGRectMake(self.progressView.frame.origin.x - 2, self.progressView.frame.origin.y, self.progressView.frame.size.width+2, 44);
    self.videoSlider.center = CGPointMake(self.videoSlider.center.x, self.progressView.center.y);
    
    
    self.fullProgressView.frame = CGRectMake(iPhoneXX?34:0, self.bounds.size.height - 2, self.bounds.size.width - 2*(iPhoneXX?34:0), 2);
    self.fullBufView.frame = CGRectMake(iPhoneXX?34:0, self.bounds.size.height - 2, self.bounds.size.width - 2*(iPhoneXX?34:0), 2);
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layout];
    [self timer];
}

- (void)dealloc{
    [_mediaPlayer stop];
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
- (void)playWithModel:(id<SPPlayerModel>)model{
    
    //设置屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self.loadingView startAnimating];
    self.loadingLabel.text = @"加载中...";
    self.loadingLabel.hidden = self.loadingView.isHidden;
    self.errorBtn.hidden = !self.loadingView.isHidden;
    
    
    NSURL *url = [NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
    if ([model.url hasPrefix:@"http://"] || [model.url hasPrefix:@"https://"]) {
        url = [NSURL URLWithString:model.url];
    }else if ([model.url hasPrefix:@"rtmp"] || [model.url hasPrefix:@"flv"]){
        url = [NSURL URLWithString:model.url];
    }else { //本地视频 需要完整路径
        url = [NSURL fileURLWithPath:model.url];
    }
    
    if ([self isProtocolService]) {
        url = [NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];
    }
    
    self.model = model;
    
//    [self.mediaPlayer reset:NO];
//    [self.mediaPlayer setUrl:url];
//    [self.mediaPlayer prepareToPlay];
    [self.mediaPlayer reload:url flush:NO mode:MPMovieReloadMode_Fast];
    //开始播放
    //[self play];
    
    self.titleLabel.text = model.title;
    
    
    NSLog(@"%s----URL---%@", __func__,url.absoluteString);
}

- (void)play
{
    [self.mediaPlayer play];
}

- (void)stop{
    [self.mediaPlayer stop];
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

- (IBAction)rePlay:(UIButton *)sender {
    
    if (self.allowSafariPlay && sender.tag) {
        [self exitFullscreen];
        WHWebViewController *web = [[WHWebViewController alloc] init];
        web.urlString = self.model.url;
        web.canDownRefresh = YES;
        web.navigationItem.title = self.model.title;
        
        UINavigationController *webVC = [[UINavigationController alloc] initWithRootViewController:web];
        webVC.navigationBar.barTintColor = [UIColor colorWithRed:10/255 green:149/255 blue:31/255 alpha:1.0];
        webVC.navigationBar.tintColor = [UIColor whiteColor];
        [webVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [self.viewController?self.viewController:self.topViewController presentViewController:webVC animated:YES completion:nil];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.live_stream]];
        return;
    }
    [self playWithModel:self.model];
}



//FIXME:  -  屏幕旋转回调
- (void)changeRotate:(NSNotification*)noti {
    
    NSLog(@"%s--playView->VC:%@;topVC:%@", __func__,[self viewController],[self topViewController]);
    
    
    if(self.lockBtn.isSelected) return;
    
    if(self.state == PlayViewStateAnimating) return;
    
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

- (void)panGesture:(UIPanGestureRecognizer *)sender{
    
    
    if(self.state == PlayViewStateSmall) return;
    
    if(self.lockBtn.isSelected) return;
    
    CGPoint point = [sender translationInView:self];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        //记录首次触摸坐标
        self.startPoint = point;
        //音/量
        self.volumeValue = self.volumeViewSlider.value;
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        //得出手指在Button上移动的距离
        CGPoint panPoint = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
        //分析出用户滑动的方向
        if (panPoint.x >= 30 || panPoint.x <= -30) {
            //进度
            self.direction = DirectionLeftOrRight;
        } else if (panPoint.y >= 30 || panPoint.y <= -30) {
            //音量和亮度
            self.direction = DirectionUpOrDown;
        }
        
        if (self.direction == DirectionNone) {
            return;
        } else if (self.direction == DirectionUpOrDown) {
            
            //音量
            if (panPoint.y < 0) {
                //增大音量
                [self.volumeViewSlider setValue:self.volumeValue + (-panPoint.y / 30.0 / 10) animated:YES];
                if (self.volumeValue + (-panPoint.y / 30 / 10) - self.volumeViewSlider.value >= 0.1) {
                    [self.volumeViewSlider setValue:0.1 animated:NO];
                    [self.volumeViewSlider setValue:self.volumeValue + (-panPoint.y / 30.0 / 10) animated:YES];
                }
                
            } else {
                //减少音量
                [self.volumeViewSlider setValue:self.volumeValue - (panPoint.y / 30.0 / 10) animated:YES];
            }
            
        }
        
    }
    
}
- (IBAction)videoViewMode:(UIButton *)sender {
    
    static MPMovieScalingMode modes[] = {
        MPMovieScalingModeAspectFill,//同比填充，某个方向的显示内容可能被裁剪
        MPMovieScalingModeFill,//满屏填充，与原始视频比例不一致
        MPMovieScalingModeNone,//无缩放
        MPMovieScalingModeAspectFit,//同比适配，某个方向会有黑边
    };
    static int curModeIdx = 0;
    
    curModeIdx = (curModeIdx + 1) % (int)(sizeof(modes)/sizeof(modes[0]));
    [self.mediaPlayer setScalingMode:modes[curModeIdx]];//
    // Determines how the content scales to fit the view. Defaults to MPMovieScalingModeAspectFit.


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
    self.buttomView.hidden = !self.buttomView.isHidden;
    self.topView.hidden = self.buttomView.isHidden;
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

- (KSYMoviePlayerController *)mediaPlayer{
    if (!_mediaPlayer) {
        //创建播放器
        _mediaPlayer = [[KSYMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"]];
        _mediaPlayer.controlStyle = MPMovieControlStyleNone;
        [_mediaPlayer.view setFrame: self.contentView.bounds];  // player's frame must match parent's
        [self.contentView addSubview: _mediaPlayer.view];
        _mediaPlayer.view.autoresizingMask =
        UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|
        UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|
        UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
        _mediaPlayer.shouldAutoplay = YES;
        _mediaPlayer.scalingMode = MPMovieScalingModeAspectFit;
        [self setupObservers:_mediaPlayer];
        _prepared_time = (long long int)([self getCurrentTime] * 1000);
        [_mediaPlayer prepareToPlay];
    }
    return _mediaPlayer;
}



- (void)registerObserver:(NSString *)notification
                  player:(KSYMoviePlayerController*)player {
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(notification)
                                              object:player];
}

- (void)setupObservers:(KSYMoviePlayerController*)player
{
    [self registerObserver:MPMediaPlaybackIsPreparedToPlayDidChangeNotification player:player];
    [self registerObserver:MPMoviePlayerPlaybackStateDidChangeNotification player:player];
    [self registerObserver:MPMoviePlayerPlaybackDidFinishNotification player:player];
    [self registerObserver:MPMoviePlayerLoadStateDidChangeNotification player:player];
    [self registerObserver:MPMovieNaturalSizeAvailableNotification player:player];
    [self registerObserver:MPMoviePlayerFirstVideoFrameRenderedNotification player:player];
    [self registerObserver:MPMoviePlayerFirstAudioFrameRenderedNotification player:player];
    [self registerObserver:MPMoviePlayerSuggestReloadNotification player:player];
    [self registerObserver:MPMoviePlayerPlaybackStatusNotification player:player];
    [self registerObserver:MPMoviePlayerNetworkStatusChangeNotification player:player];
    [self registerObserver:MPMoviePlayerSeekCompleteNotification player:player];
    [self registerObserver:MPMoviePlayerPlaybackTimedTextNotification player:player];
}


-(void)handlePlayerNotify:(NSNotification*)notify
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!_mediaPlayer) {
            return;
        }
#pragma mark  - 获取到视频的相关信息
        if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification ==  notify.name) {
            if(_mediaPlayer.shouldAutoplay == NO) [_mediaPlayer play];
            _reloading = NO;
            [self OnVideoPrepared:notify];
            
            NSLog(@"总时长：%f-----player prepared",_mediaPlayer.duration);
            NSLog(@"视频源: %@ -- 服务器ip:%@", [[_mediaPlayer contentURL] absoluteString], [_mediaPlayer serverAddress]);
            NSLog(@"媒体mediaMeta：%@",[_mediaPlayer getMetadata]);
    
            return;
        }
#pragma mark  - 播放状态
        if (MPMoviePlayerPlaybackStateDidChangeNotification ==  notify.name) {
            NSLog(@"播放状态: %@", _status[(long)_mediaPlayer.playbackState]);
            return;
        }
#pragma mark  - 加载状态
        if (MPMoviePlayerLoadStateDidChangeNotification ==  notify.name) {
            NSLog(@"加载状态: %@", _loadStatus[(long)_mediaPlayer.loadState]);
            if (MPMovieLoadStateStalled & _mediaPlayer.loadState) {
                NSLog(@"开始缓存。。。");
                [self OnStartCache:notify];
            }
            
            if (_mediaPlayer.bufferEmptyCount &&
                (MPMovieLoadStatePlayable & _mediaPlayer.loadState ||
                 MPMovieLoadStatePlaythroughOK & _mediaPlayer.loadState)){
                    NSLog(@"缓存结束。。。%f",_mediaPlayer.playableDuration);
                    [self OnEndCache:notify];
                    
                    NSString *message = [[NSString alloc]initWithFormat:@"loading occurs, %d - %0.3fs",
                                         (int)_mediaPlayer.bufferEmptyCount,
                                         _mediaPlayer.bufferEmptyDuration];
                    NSLog(@"%@",message);
                }
            return;
        }
#pragma mark  - 播放完成
        if (MPMoviePlayerPlaybackDidFinishNotification ==  notify.name) {
            NSLog(@"player finish state: %@", _status[(long)_mediaPlayer.playbackState]);
            NSLog(@"player download flow size: %f MB", _mediaPlayer.readSize);
            NSLog(@"buffer monitor  result: \n   empty count: %d, lasting: %f seconds",
                  (int)_mediaPlayer.bufferEmptyCount,
                  _mediaPlayer.bufferEmptyDuration);
            //结束播放的原因
            int reason = [[[notify userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
            if (reason ==  MPMovieFinishReasonPlaybackEnded) {
                NSLog(@"player finish");
                
            }else if (reason == MPMovieFinishReasonPlaybackError){
                NSLog(@"%@",[NSString stringWithFormat:@"player Error : %@", [[notify userInfo] valueForKey:@"error"]]);
                [self OnVideoError:notify];
                
            }else if (reason == MPMovieFinishReasonUserExited){
                NSLog(@"player userExited");
                
                
            }
            return;
        }
        
        if (MPMovieNaturalSizeAvailableNotification ==  notify.name) {
            NSLog(@"video size %.0f-%.0f, rotate:%ld\n", _mediaPlayer.naturalSize.width, _mediaPlayer.naturalSize.height, (long)_mediaPlayer.naturalRotate);
            if(((_mediaPlayer.naturalRotate / 90) % 2  == 0 && _mediaPlayer.naturalSize.width > _mediaPlayer.naturalSize.height) ||
               ((_mediaPlayer.naturalRotate / 90) % 2 != 0 && _mediaPlayer.naturalSize.width < _mediaPlayer.naturalSize.height)){
                //如果想要在宽大于高的时候横屏播放，你可以在这里旋转
            }
            return;
        }
        if (MPMoviePlayerFirstVideoFrameRenderedNotification == notify.name){
            _fvr_costtime = (int)((long long int)([self getCurrentTime] * 1000) - _prepared_time);
            NSLog(@"first video frame show, cost time : %dms!\n", _fvr_costtime);
            [self onVideoFirstFrame:notify];
            return;
        }
        
        if (MPMoviePlayerFirstAudioFrameRenderedNotification == notify.name){
            _far_costtime = (int)((long long int)([self getCurrentTime] * 1000) - _prepared_time);
            NSLog(@"first audio frame render, cost time : %dms!\n", _far_costtime);
            return;
        }
        
        if (MPMoviePlayerSuggestReloadNotification == notify.name){
            NSLog(@"suggest using reload function!\n");
            if(!_reloading){
                _reloading = YES;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(){
                    if (_mediaPlayer) {
                        NSLog(@"reload stream");
                        [_mediaPlayer reload:[NSURL URLWithString:self.model.url] flush:YES mode:MPMovieReloadMode_Accurate];
                    }
                });
            }
            return;
        }
        
        if(MPMoviePlayerPlaybackStatusNotification == notify.name){
            int status = [[[notify userInfo] valueForKey:MPMoviePlayerPlaybackStatusUserInfoKey] intValue];
            if(MPMovieStatusVideoDecodeWrong == status)
                NSLog(@"Video Decode Wrong!\n");
            else if(MPMovieStatusAudioDecodeWrong == status)
                NSLog(@"Audio Decode Wrong!\n");
            else if (MPMovieStatusHWCodecUsed == status )
                NSLog(@"Hardware Codec used\n");
            else if (MPMovieStatusSWCodecUsed == status )
                NSLog(@"Software Codec used\n");
            else if(MPMovieStatusDLCodecUsed == status)
                NSLog(@"AVSampleBufferDisplayLayer  Codec used");
            
            return;
        }
        if(MPMoviePlayerNetworkStatusChangeNotification == notify.name){
            int currStatus = [[[notify userInfo] valueForKey:MPMoviePlayerCurrNetworkStatusUserInfoKey] intValue];
            int lastStatus = [[[notify userInfo] valueForKey:MPMoviePlayerLastNetworkStatusUserInfoKey] intValue];
            NSLog(@"network reachable change from %@ to %@\n", [self netStatus2Str:lastStatus], [self netStatus2Str:currStatus]);
            return;
        }
        if(MPMoviePlayerSeekCompleteNotification == notify.name){
            NSLog(@"Seek complete");
            return;
        }
        
        if (MPMoviePlayerPlaybackTimedTextNotification == notify.name){
            NSString *timedText = [[notify userInfo] valueForKey:MPMoviePlayerPlaybackTimedTextUserInfoKey];
            
            NSLog(@"%s---%@", __func__,timedText);
            return;
        }
        
    });
    
}

- (NSTimeInterval) getCurrentTime{
    return [[NSDate date] timeIntervalSince1970];
}

- (NSString *) netStatus2Str:(KSYNetworkStatus)networkStatus{
    NSString *netString = nil;
    if(networkStatus == KSYNotReachable)
        netString = @"NO INTERNET";
    else if(networkStatus == KSYReachableViaWiFi)
        netString = @"WIFI";
    else if(networkStatus == KSYReachableViaWWAN)
        netString = @"WWAN";
    else
        netString = @"Unknown";
    return netString;
}



- (NSTimer *)timer{
    if (!_timer) {
        __weak typeof(self) weakSelf = self;
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0/3.0 target:weakSelf selector:@selector(timeChange:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (! newSuperview && self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timeChange:(NSTimer *)sender{
    
    if(self.progressDragging) return;
 
    NSTimeInterval total = self.mediaPlayer.duration;
    NSTimeInterval current = self.mediaPlayer.currentPlaybackTime;
    NSTimeInterval cache = self.mediaPlayer.playableDuration;
    
    int progress = (cache - current) * 100;
    if (progress < 100 && (progress > 0)) {
        NSLog(@"加载进度加载进度加载进度加载进度加载进度加载进度加载进度加载进度：%d%%", progress);
        self.loadingLabel.text = [NSString stringWithFormat:@"(%d%%)",progress?progress:0];
        //[self printLog];
    }

    
    self.progressView.progress = cache / total;
    self.videoSlider.value = current / total;
    
    //NSLog(@"%s----缓存(%f)：%f----进度(%f)：%f", __func__,cache,self.progressView.progress,current,self.videoSlider.value);

    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld",(NSInteger)current/60,(NSInteger)current%60,(NSInteger)total/60,(NSInteger)total%60];
    self.fullProgressView.progress = self.videoSlider.value;
    self.fullBufView.progress = self.progressView.progress;
    
    self.networkSpeedLabel.text = [NSString stringWithFormat:@"%0.1f kb/s",1024.0*((_mediaPlayer.readSize - _lastSize)?(_mediaPlayer.readSize - _lastSize):0) * 3.0];
    _lastSize = _mediaPlayer.readSize;

}


- (void)printLog{
    if (nil == _mediaPlayer)
        return;
    
    if ( 0 == _lastCheckTime) {
        _lastCheckTime = [self getCurrentTime];
        return;
    }
    
    if(_mediaPlayer.playbackState != MPMoviePlaybackStateStopped && _mediaPlayer.isPreparedToPlay){
        double flowSize = [_mediaPlayer readSize];
        KSYQosInfo *info = _mediaPlayer.qosInfo;
        NSDictionary *mediaMeta = [_mediaPlayer getMetadata];
        NSString *serverIp = [_mediaPlayer serverAddress];
        NSString *message = [NSString stringWithFormat:@
                             "SDK版本:v%@\n"
                             "播放器实例:%p\n"
                             "拉流URL:%@\n"
                             "服务器IP:%@\n"
                             "客户端IP:%@\n"
                             "本地DNS IP:%@\n"
                             "分辨率:(宽-高: %.0f-%.0f)\n"
                             "已播时长:%.1fs\n"
                             "缓存时长:%.1fs\n"
                             "视频总长%.1fs\n"
                             "cache次数:%.1fs/%ld\n"
                             "最大缓冲时长:%.1fs\n"
                             "速度: %0.1f kbps\n视频/音频渲染用时:%dms/%dms\n"
                             "HTTP连接用时:%ldms\n"
                             "DNS解析用时:%ldms\n"
                             "首包到达用时（连接建立后）:%ldms\n"
                             "音频缓冲队列长度:%.1fMB\n"
                             "音频缓冲队列时长:%.1fs\n"
                             "已下载音频数据量:%.1fMB\n"
                             "视频缓冲队列长度:%.1fMB\n"
                             "视频缓冲队列时长:%.1fs\n"
                             "已下载视频数据量:%.1fMB\n"
                             "已下载总数据量%.1fMB\n"
                             "解码帧率:%.2f 显示帧率:%.2f\n"
                             "网络连通性:%@\n",
                             
                             [_mediaPlayer getVersion],
                             _mediaPlayer,
                             [[_mediaPlayer contentURL] absoluteString],
                             serverIp,
                             _mediaPlayer.clientIP,
                             _mediaPlayer.localDNSIP,
                             _mediaPlayer.naturalSize.width,_mediaPlayer.naturalSize.height,
                             _mediaPlayer.currentPlaybackTime,
                             _mediaPlayer.playableDuration,
                             _mediaPlayer.duration,
                             _mediaPlayer.bufferEmptyDuration,
                             (long)_mediaPlayer.bufferEmptyCount,
                             _mediaPlayer.bufferTimeMax,
                             8*1024.0*(flowSize - _lastSize)/([self getCurrentTime] - _lastCheckTime),
                             _fvr_costtime, _far_costtime,
                             (long)[(NSNumber *)[mediaMeta objectForKey:kKSYPLYHttpConnectTime] integerValue],
                             (long)[(NSNumber *)[mediaMeta objectForKey:kKSYPLYHttpAnalyzeDns] integerValue],
                             (long)[(NSNumber *)[mediaMeta objectForKey:kKSYPLYHttpFirstDataTime] integerValue],
                             (float)info.audioBufferByteLength / 1e6,
                             (float)info.audioBufferTimeLength / 1e3,
                             (float)info.audioTotalDataSize / 1e6,
                             (float)info.videoBufferByteLength / 1e6,
                             (float)info.videoBufferTimeLength / 1e3,
                             (float)info.videoTotalDataSize / 1e6,
                             (float)info.totalDataSize / 1e6,
                             info.videoDecodeFPS,
                             info.videoRefreshFPS,
                             [self netStatus2Str:_mediaPlayer.networkStatus]];
        _lastCheckTime = [self getCurrentTime];
        _lastSize = flowSize;
        
        NSLog(@"%s---%@", __func__,message);
    }

}


#pragma mark  - 获取到视频的相关信息
- (void)OnVideoPrepared:(NSNotification *)noti{
    NSTimeInterval total = self.mediaPlayer.duration;
    BOOL islive = !(total > 0);
    self.videoButtomView.hidden = islive;
    if(islive){
        self.fullBufView = nil;
        self.fullProgressView = nil;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"00:00/%02ld:%02ld",(NSInteger)total/60,(NSInteger)total%60];
}

#pragma mark  - 视频正常播放完成
- (void)OnVideoFinish:(NSNotification *)noti{
    NSLog(@"%s--视频正常播放完成", __func__);
}

#pragma mark  - 播放器播放失败
- (void)OnVideoError:(NSNotification *)noti{
    NSLog(@"%s--播放器播放失败--%@", __func__,noti.userInfo);
    NSString *errorMsg = [self error:[NSString stringWithFormat:@"%@",[noti.userInfo valueForKey:@"error"]]];
    
    if (self.allowSafariPlay) {
        [self.errorBtn setTitle:[NSString stringWithFormat:@"%@\n(重新播放或浏览器观看)",errorMsg] forState:UIControlStateNormal];
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
    NSLog(@"%s--播放器Seek完成后", __func__);
}

#pragma mark  - 播放器开始缓冲视频时
- (void)OnStartCache:(NSNotification *)noti{
    [self.loadingView startAnimating];
    self.loadingLabel.text = @"缓存中...";
    self.loadingLabel.hidden = self.loadingView.isHidden;
    self.errorBtn.hidden = !self.loadingView.isHidden;
    
}

#pragma mark  - 播放器结束缓冲视频
- (void)OnEndCache:(NSNotification *)noti{
    [self.loadingView stopAnimating];
    self.loadingLabel.hidden = self.loadingView.isHidden;
    self.errorBtn.hidden = YES;
    [self timer];
}

#pragma mark  - 播放器主动调用Stop功能
- (void)onVideoStop:(NSNotification *)noti{
    NSLog(@"%s--播放器主动调用Stop功能", __func__);
}

#pragma mark  - 播放器状态首帧显示
- (void)onVideoFirstFrame:(NSNotification *)noti{
    NSLog(@"%s--播放器状态首帧显示", __func__);
        [self timer];
        self.errorBtn.hidden = YES;
        [self.loadingView stopAnimating];
        self.loadingLabel.hidden = self.loadingView.isHidden;

}

#pragma mark  - 播放器开启循环播放
- (void)onCircleStart:(NSNotification *)noti{
    NSLog(@"%s--播放器开启循环播放", __func__);
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
    }
    return _progressView;
}

- (SPVideoSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[SPVideoSlider alloc] init];
        [_videoSlider setMinimumTrackImage:[UIImage imageFromBundleWithName:@"fullplayer_progressbar_n_171x3_"] forState:UIControlStateNormal];
        [_videoSlider setThumbImage:[UIImage imageFromBundleWithName:@"fullplayer_slider_iphone_12x15_"] forState:UIControlStateNormal];
        
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
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

- (UIButton *)rePlayButton{
    if(!_rePlayButton){
        _rePlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rePlayButton setImage:[UIImage imageFromBundleWithName:@"fullplayer_icon_replay"] forState:UIControlStateNormal];
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
        _safariButton.tag = 1;
        _safariButton.showsTouchWhenHighlighted = YES;
        [_safariButton addTarget:self action:@selector(rePlay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _safariButton;
}


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


- (NSString *)error:(NSString *)code{
    
    NSDictionary * errorDic = @{
                                @"4500":@"请求错误",
                                @"4501":@"数据错误",
                                @"4502":@"请求saas服务器错误",
                                @"4503":@"请求mts服务器错误",
                                @"4504":@"服务器返回参数无效",
                                @"4521":@"非法的播放器状态",
                                @"4022":@"没有设置显示窗口，请先设置播放视图",
                                @"4023":@"内存不足",
                                @"4024":@"系统权限被拒绝",
                                @"4101":@"视频下载时连接不到服务器",
                                @"4102":@"视频下载时网络超时",
                                @"4103":@"请求saas服务器错误",
                                @"4104":@"请求mts服务器错误",
                                @"4105":@"服务器返回参数无效",
                                @"4106":@"视频下载流无效或地址过期",
                                @"4107":@"未找到加密文件，请从控制台下载加密文件并集成",
                                @"4108":@"获取秘钥失败，请检查秘钥文件",
                                @"4109":@"下载地址无效",
                                @"4110":@"磁盘空间不够",
                                @"4111":@"视频文件保存路径不存在，请重新设置",
                                @"4112":@"当前视频不可下载",
                                @"4113":@"下载模式改变无法继续下载",
                                @"4114":@"当前视频已经添加到下载项，请避免重复添加",
                                @"4115":@"未找到合适的下载项，请先添加",
                                @"4001":@"参数非法",
                                @"4002":@"鉴权过期",
                                @"4003":@"视频源无效",
                                @"4004":@"视频源不存在",
                                @"4005":@"读取视频源失败",
                                @"4008":@"加载超时",
                                @"4009":@"请求数据错误",
                                
                                @"4011":@"视频格式不支持",
                                @"4012":@"解析失败",
                                @"4013":@"解码失败",
                                @"4019":@"编码格式不支持",
                                @"4400":@"未知错误",
                                
                                };
    NSString *msg = errorDic[code];
    
    return msg?msg : @"未知错误";
}


//FIXME:  -  事件监听
- (void)videoDurationChange:(SPVideoSlider *)sender{
    self.progressDragging = NO;
    [self.mediaPlayer seekTo:sender.value * self.mediaPlayer.duration accurate:YES];
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

    [self.mediaPlayer seekTo:s.value * self.mediaPlayer.duration accurate:YES];
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
    if ([@[@"WHWebViewController",@"AVPlayerViewController", @"AVFullScreenViewController", @"AVFullScreenPlaybackControlsViewController"
           ] containsObject:className])
    {
        return YES;
    }
    
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    NSString *className = NSStringFromClass([self class]);
    if ([@[@"WHWebViewController",@"AVPlayerViewController", @"AVFullScreenViewController", @"AVFullScreenPlaybackControlsViewController"
           ] containsObject:className])
    {
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


@implementation UIImage (Bundle)
+ (UIImage *)imageFromBundleWithName:(NSString *)imageName{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Player" ofType:@".bundle"];
    NSString *fullImageName = [path stringByAppendingPathComponent:imageName];
    return [UIImage imageNamed:fullImageName];
}
@end






