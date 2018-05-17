//
//  PlayView.m
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "PlayerView.h"
#import "SPVideoSlider.h"

#import <AliyunPlayerSDK/AlivcMediaPlayer.h>

#define  ScreenWith [UIScreen mainScreen].bounds.size.width
#define  ScreenHeight [UIScreen mainScreen].bounds.size.height
#define  iPhoneX (ScreenHeight == 375.f && ScreenWith == 812.f ? YES : NO)



@interface PlayerView()

@property (nonatomic, strong) AliVcMediaPlayer *mediaPlayer;
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

/** errorMsg */
@property (nonatomic, strong) NSDictionary *error;

/** 错误按钮 */
@property (weak, nonatomic) IBOutlet UIButton *errorBtn;

/** 记录小屏时的parentView */
@property (nonatomic, weak) UIView *playViewParentView;

/** 记录小屏时的frame */
@property (nonatomic, assign) CGRect playViewSmallFrame;

/** 屏幕状态 */
@property (nonatomic, assign) PlayViewState state;

@end

@implementation PlayerView


//FIXME:  -  生命周期
+ (instancetype)playerView{
    return [[NSBundle mainBundle] loadNibNamed:@"PlayerView" owner:nil options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    [self.buttomView addSubview:self.videoButtomView];
    [self.videoButtomView addSubview:self.playOrPauseButton];
    [self.videoButtomView addSubview:self.timeLabel];
    [self.videoButtomView addSubview:self.progressView];
    [self.videoButtomView addSubview:self.videoSlider];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)layout{
    self.loadingView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    self.errorBtn.center = self.loadingView.center;
    
    CGFloat spacing = iPhoneX? 24 : 0;
    self.topView.frame = CGRectMake(spacing, 0, self.bounds.size.width - 2 * spacing, 64);
    
    
    self.buttomView.frame = CGRectMake(spacing, self.bounds.size.height - 44, self.bounds.size.width - 2 * spacing, 44);
    
    self.contentView.frame = self.bounds;
    self.fullButton.frame = CGRectMake(self.buttomView.bounds.size.width - 44, 0, 44, 44);
    self.topBgView.frame = self.topView.bounds;
    self.buttomBgView.frame = self.buttomView.bounds;
    
    self.backButton.frame = CGRectMake(0, 20, 44, 44);
    self.titleLabel.frame = CGRectMake(44, 20, self.topView.bounds.size.width - 44, 44);
    
    
    self.videoButtomView.frame = CGRectMake(0, 0, self.buttomView.bounds.size.width - 44, self.buttomView.bounds.size.height);
    
    self.playOrPauseButton.frame = CGRectMake(0, 0, 44, 44);
    self.timeLabel.frame = CGRectMake(44, 0, 65, 44);
    
    self.progressView.frame = CGRectMake(44 + 65+10, 0, self.videoButtomView.bounds.size.width - 44 - 65-10, 44);
    self.progressView.center = CGPointMake(self.progressView.center.x, self.videoButtomView.center.y);
    self.videoSlider.frame = CGRectMake(self.progressView.frame.origin.x - 2, self.progressView.frame.origin.y, self.progressView.frame.size.width+2, 44);
    self.videoSlider.center = CGPointMake(self.videoSlider.center.x, self.progressView.center.y);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layout];
    [self timer];
    NSLog(@"%s---小学英语单词记忆法", __func__);
}

#pragma mark  开始播放
- (void)playWithModel:(id<TTZPlayerModel>)model{
    
    [self stop];
    self.model = model;
    //prepareToPlay:此方法传入的参数是NSURL类型.
    [self.mediaPlayer prepareToPlay:model.url];
    //开始播放
    [self play];
    
    self.titleLabel.text = model.name;
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
- (void)setPrefersStatusBarHidden:(BOOL)prefersStatusBarHidden{
    _prefersStatusBarHidden = prefersStatusBarHidden;
    if(prefersStatusBarHidden) [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelStatusBar + 1];
    else [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelStatusBar - 1];
}

- (IBAction)rePlay:(UIButton *)sender {
    sender.hidden = YES;
    [self playWithModel:self.model];
}


//FIXME:  -  屏幕旋转回调
- (void)changeRotate:(NSNotification*)noti {
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (self.state == PlayViewStateSmall) {
//        self.buttomView.hidden = NO;
//        self.topView.hidden = NO;
//        self.fullButton.selected = YES;
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
//        self.buttomView.hidden = YES;
//        self.topView.hidden = YES;
//        self.fullButton.selected = NO;
        
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

//FIXME:  -  视频触摸的回调
- (void)handleTapGesture{
    
    if (self.state == PlayViewStateSmall) {
        self.buttomView.hidden = !self.buttomView.isHidden;
        return;
    }
    self.topView.hidden = !self.buttomView.isHidden;
    self.buttomView.hidden = !self.buttomView.isHidden;
    self.prefersStatusBarHidden = self.buttomView.isHidden;
    
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

//FIXME:  -  向左
- (void)enterFullscreenLeft {
    
    self.buttomView.hidden = NO;
    self.topView.hidden = NO;
    self.fullButton.selected = YES;
    
    if (self.state == PlayViewStateFullScreenLeft) {
        return;
    }
    
    self.state = PlayViewStateAnimating;
    
    /*
     * 记录进入全屏前的parentView和frame
     */
    self.playViewParentView = self.superview;
    if(CGRectEqualToRect(CGRectZero, self.playViewSmallFrame)) self.playViewSmallFrame = self.frame;

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
    
    
    self.buttomView.hidden = NO;
    self.topView.hidden = NO;
    self.fullButton.selected = YES;
    
    if (self.state == PlayViewStateFullScreenRight) {
        return;
    }

    
    self.state = PlayViewStateAnimating;
    
    /*
     * 记录进入全屏前的parentView和frame
     */
    self.playViewParentView = self.superview;
    if(CGRectEqualToRect(CGRectZero, self.playViewSmallFrame)) self.playViewSmallFrame = self.frame;

    
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
    
    self.buttomView.hidden = YES;
    self.topView.hidden = YES;
    self.fullButton.selected = NO;

    if (self.state == PlayViewStateSmall) {
        return;
    }
    
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
- (AliVcMediaPlayer *)mediaPlayer{
    if (!_mediaPlayer) {
        //创建播放器
        _mediaPlayer = [[AliVcMediaPlayer alloc] init];
        //创建播放器视图，其中contentView为UIView实例，自己根据业务需求创建一个视图即可
        /*self.mediaPlayer:NSObject类型，需要UIView来展示播放界面。
         self.contentView：承载mediaPlayer图像的UIView类。
         self.contentView = [[UIView alloc] init];
         [self.view addSubview:self.contentView];
         */
        //self.contentView = [[UIView alloc] init];
        
        //[_mediaPlayer create:self.contentView];
        [_mediaPlayer create:self.contentView];
        
        //设置播放类型，0为点播、1为直播，默认使用自动
        _mediaPlayer.mediaType = MediaType_AUTO;
        //设置超时时间，单位为毫秒
        _mediaPlayer.timeout = 10000;
        //缓冲区超过设置值时开始丢帧，单位为毫秒。直播时设置，点播设置无效。范围：500～100000
        _mediaPlayer.dropBufferDuration = 8000;
        
        [self addNotification];
    }
    return _mediaPlayer;
}

- (void)addNotification{
    //一、播放器初始化视频文件完成通知，调用prepareToPlay函数，会发送该通知，代表视频文件已经准备完成，此时可以在这个通知中获取到视频的相关信息，如视频分辨率，视频时长等
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnVideoPrepared:)
                                                 name:AliVcMediaPlayerLoadDidPreparedNotification object:self.mediaPlayer];
    //二、播放完成通知。视频正常播放完成时触发。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnVideoFinish:)
                                                 name:AliVcMediaPlayerPlaybackDidFinishNotification object:self.mediaPlayer];
    //三、播放器播放失败发送该通知，并在该通知中可以获取到错误码。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnVideoError:)
                                                 name:AliVcMediaPlayerPlaybackErrorNotification object:self.mediaPlayer];
    //四、播放器Seek完成后发送该通知。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnSeekDone:)
                                                 name:AliVcMediaPlayerSeekingDidFinishNotification object:self.mediaPlayer];
    //五、播放器开始缓冲视频时发送该通知，当播放网络文件时，网络状态不佳或者调用seekTo时，此通知告诉用户网络下载数据已经开始缓冲。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnStartCache:)
                                                 name:AliVcMediaPlayerStartCachingNotification object:self.mediaPlayer];
    //六、播放器结束缓冲视频时发送该通知，当数据已经缓冲完，告诉用户已经缓冲结束，来更新相关UI显示。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnEndCache:)
                                                 name:AliVcMediaPlayerEndCachingNotification object:self.mediaPlayer];
    //七、播放器主动调用Stop功能时触发。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onVideoStop:)
                                                 name:AliVcMediaPlayerPlaybackStopNotification object:self.mediaPlayer];
    //八、播放器状态首帧显示后发送的通知。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onVideoFirstFrame:)
                                                 name:AliVcMediaPlayerFirstFrameNotification object:self.mediaPlayer];
    //九、播放器开启循环播放功能，开始循环播放时发送的通知。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onCircleStart:)
                                                 name:AliVcMediaPlayerCircleStartNotification object:self.mediaPlayer];
    
}

- (NSTimer *)timer{
    if (!_timer) {
        __weak typeof(self) weakSelf = self;
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:weakSelf selector:@selector(timeChange:) userInfo:nil repeats:YES];
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
    
    NSTimeInterval total = self.mediaPlayer.duration;
    NSTimeInterval current = self.mediaPlayer.currentPosition;
    
    self.progressView.progress = self.mediaPlayer.bufferingPostion / total;
    NSLog(@"%s----%f", __func__,self.progressView.progress);
    self.videoSlider.value = current / total;
    total = total/1000;
    current = current/1000;
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld",(NSInteger)current/60,(NSInteger)current%60,(NSInteger)total/60,(NSInteger)total%60];
}


#pragma mark  - 获取到视频的相关信息
- (void)OnVideoPrepared:(NSNotification *)noti{
    NSLog(@"%s--获取到视频的相关信息--时长：%f秒", __func__,self.mediaPlayer.duration/1000);
    //!(_playerLoading)? : _playerLoading();
    
    NSTimeInterval total = self.mediaPlayer.duration/1000;
    BOOL islive = !(total > 0);
    self.videoButtomView.hidden = islive;
    self.timeLabel.text = [NSString stringWithFormat:@"00:00/%02ld:%02ld",(NSInteger)total/60,(NSInteger)total%60];
}

#pragma mark  - 视频正常播放完成
- (void)OnVideoFinish:(NSNotification *)noti{
    NSLog(@"%s--视频正常播放完成", __func__);
}

#pragma mark  - 播放器播放失败
- (void)OnVideoError:(NSNotification *)noti{
    NSLog(@"%s--播放器播放失败--%@", __func__,noti.userInfo);
    NSString *errorMsg = [noti.userInfo valueForKey:@"errorMsg"];
    [self.errorBtn setTitle:errorMsg forState:UIControlStateNormal];
    self.errorBtn.hidden = NO;
    
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark  - 播放器Seek完成后
- (void)OnSeekDone:(NSNotification *)noti{
    NSLog(@"%s--播放器Seek完成后", __func__);
}

#pragma mark  - 播放器开始缓冲视频时
- (void)OnStartCache:(NSNotification *)noti{
    NSLog(@"%s--播放器开始缓冲视频时", __func__);
    //!(_playerLoading)? : _playerLoading();
    [self.loadingView startAnimating];
}

#pragma mark  - 播放器结束缓冲视频
- (void)OnEndCache:(NSNotification *)noti{
    NSLog(@"%s--播放器结束缓冲视频", __func__);
    //!(_playerCompletion)? : _playerCompletion();
    [self.loadingView stopAnimating];
    if(self.mediaPlayer.duration) [self timer];
}

#pragma mark  - 播放器主动调用Stop功能
- (void)onVideoStop:(NSNotification *)noti{
    NSLog(@"%s--播放器主动调用Stop功能", __func__);
}

#pragma mark  - 播放器状态首帧显示
- (void)onVideoFirstFrame:(NSNotification *)noti{
    NSLog(@"%s--播放器状态首帧显示", __func__);
    //!(_playerCompletion)? : _playerCompletion();
    if(self.mediaPlayer.duration) [self timer];
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
        //_progressView.progress = 0.76;
    }
    return _progressView;
}

- (SPVideoSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[SPVideoSlider alloc] init];
        [_videoSlider setMinimumTrackImage:[UIImage imageNamed:@"pic_progressbar_n_171x3_"] forState:UIControlStateNormal];
        [_videoSlider setThumbImage:[UIImage imageNamed:@"player_full_slider_iphone_12x15_"] forState:UIControlStateNormal];
        
        //[_videoSlider setMaximumTrackImage:SPPlayerImage(@"freeprop_progressbar_iphone_40x2_"] forState:UIControlStateNormal];
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        //_videoSlider.value = 0.6;
        //_videoSlider.backgroundColor = [UIColor orangeColor];
        [_videoSlider addTarget:self action:@selector(videoDurationChange:) forControlEvents:UIControlEventValueChanged];
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
        [_playOrPauseButton setImage:[UIImage imageNamed:@"fullplayer_icon_pause"] forState:UIControlStateSelected];
        [_playOrPauseButton setImage:[UIImage imageNamed:@"fullplayer_icon_play"] forState:UIControlStateNormal];
        _playOrPauseButton.selected = YES;
        [_playOrPauseButton addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _playOrPauseButton;
}


- (NSDictionary *)error{
    if (!_error) {
//        ALIVC_SUCCESS                                   = 0,        //无错误
//        ALIVC_ERR_INVALID_PARAM                         = 4001 ,    //，请检查输入参数
//        ALIVC_ERR_AUTH_EXPIRED                          = 4002,     //鉴权过期，请重新获取新的鉴权信息
//        ALIVC_ERR_INVALID_INPUTFILE                     = 4003,     //无效的输入文件，请检查视频源和路径
//        ALIVC_ERR_NO_INPUTFILE                          = 4004,     //没有设置视频源或视频地址不存在
//        ALIVC_ERR_READ_DATA_FAILED                      = 4005,     //读取视频源失败
//        ALIVC_ERR_LOADING_TIMEOUT                       = 4008,     //视频加载超时，请检查网络状况
//        ALIVC_ERR_REQUEST_DATA_ERROR                    = 4009,     //请求数据错误
//        ALIVC_ERR_VIDEO_FORMAT_UNSUPORTED               = 4011,     //视频格式不支持
//        ALIVC_ERR_PLAYAUTH_PARSE_FAILED                 = 4012,     //playAuth解析失败
//        ALIVC_ERR_DECODE_FAILED                         = 4013,     //视频解码失败
//        ALIVC_ERR_NO_SUPPORT_CODEC                      = 4019,     //视频编码格式不支持
//        ALIVC_ERR_UNKNOWN                               = 4400,     //未知错误
//        ALIVC_ERR_REQUEST_ERROR                         = 4500,     //服务端请求错误
//        ALIVC_ERR_DATA_ERROR                            = 4501,     //服务器返回数据错误
//        ALIVC_ERR_QEQUEST_SAAS_SERVER_ERROR             = 4502,     //请求saas服务器错误
//        ALIVC_ERR_QEQUEST_MTS_SERVER_ERROR              = 4503,     //请求mts服务器错误
//        ALIVC_ERR_SERVER_INVALID_PARAM                 = 4504,      //服务器返回参数无效，请检查XX参数
//        ALIVC_ERR_ILLEGALSTATUS                         = 4521,     //非法的播放器状态，当前状态是xx
//        ALIVC_ERR_NO_VIEW                               = 4022,     //没有设置显示窗口，请先设置播放视图
//        ALIVC_ERR_NO_MEMORY                             = 4023,     //内存不足
//
//        //    ALIVC_ERR_FUNCTION_DENIED                       = 4024,     //系统权限被拒绝或没有经过授权
//        ALIVC_ERR_DOWNLOAD_NO_NETWORK                   = 4101,     //视频下载时连接不到服务器
//        ALIVC_ERR_DOWNLOAD_NETWORK_TIMEOUT              = 4102,     //视频下载时网络超时
//        ALIVC_ERR_DOWNLOAD_QEQUEST_SAAS_SERVER_ERROR    = 4103,     //请求saas服务器错误
//        ALIVC_ERR_DOWNLOAD_QEQUEST_MTS_SERVER_ERROR     = 4104,     //请求mts服务器错误
//        ALIVC_ERR_DOWNLOAD_SERVER_INVALID_PARAM         = 4105,     //服务器返回参数无效，请检查XX参数
//        ALIVC_ERR_DOWNLOAD_INVALID_INPUTFILE            = 4106,     //视频下载流无效或地址过期
//        ALIVC_ERR_DOWNLOAD_NO_ENCRYPT_FILE              = 4107,     //未找到加密文件，请从控制台下载加密文件并集成
//        ALIVC_ERR_DONWNLOAD_GET_KEY                     = 4108,     //获取秘钥失败，请检查秘钥文件
//        ALIVC_ERR_DOWNLOAD_INVALID_URL                  = 4109,     //下载地址无效
//        ALIVC_ERR_DONWLOAD_NO_SPACE                     = 4110,     //磁盘空间不够
//        ALIVC_ERR_DOWNLOAD_INVALID_SAVE_PATH            = 4111,     //视频文件保存路径不存在，请重新设置
//        ALIVC_ERR_DOWNLOAD_NO_PERMISSION                = 4112,     //当前视频不可下载
//        ALIVC_ERR_DOWNLOAD_MODE_CHANGED                 = 4113,     //下载模式改变无法继续下载
//        ALIVC_ERR_DOWNLOAD_ALREADY_ADDED                = 4114,     //当前视频已经添加到下载项，请避免重复添加
//        ALIVC_ERR_DOWNLOAD_NO_MATCH                     = 4115,     //未找到合适的下载项，请先添加
//
        _error = @{
                   @"4001":@"参数非法",
                   @"4002":@"鉴权过期",
                   @"4003":@"视频源无效",
                   @"4004":@"视频源不存在",
                   @"4005":@"读取视频源失败",
                   @"4008":@"加载超时",
                   @"4009":@"请求数据错误",

                   @"4011":@"视频格式不支持",
                   @"4009":@"请求数据错误",
                   @"4009":@"请求数据错误",
                   @"4009":@"请求数据错误",
                   @"4009":@"请求数据错误",

                   };
    }
    return _error;
}


//FIXME:  -  事件监听
- (void)videoDurationChange:(SPVideoSlider *)sender{
    NSLog(@"%s", __func__);
    [self.mediaPlayer seekTo:sender.value * self.mediaPlayer.duration];
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
@implementation UIViewController (Player)
//FIXME:  -  旋转 状态栏
- (BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationFade;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return NO;
}
@end





