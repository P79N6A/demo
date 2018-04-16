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

#define ScreenWith [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
// iPhone X
#define  iPhoneX (ScreenHeight == 375.f && ScreenWith == 812.f ? YES : NO)



@interface PlayerView()

@property (nonatomic, strong) AliVcMediaPlayer *mediaPlayer;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topBgView;

@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (weak, nonatomic) IBOutlet UIImageView *buttomBgView;

@property (weak, nonatomic) IBOutlet UIButton *fullButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) UIButton *playOrPauseButton;  // 播放\暂停按钮
@property (nonatomic, strong) UIView *videoButtomView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) SPVideoSlider *videoSlider;
/** 67:56/98:08 */
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, weak) NSTimer *timer;
@end

@implementation PlayerView


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
    

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self timer];
    NSLog(@"%s---小学英语单词记忆法", __func__);
    self.loadingView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
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

#pragma mark  开始播放
- (void)playWithModel:(id<TTZPlayerModel>)model{
    
    [self stop];
    self.model = model;
    //prepareToPlay:此方法传入的参数是NSURL类型.
    [self.mediaPlayer prepareToPlay:[NSURL URLWithString:model.url]];
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


- (void)handleTapGesture{
    
    if (self.state == PlayViewStateSmall) {
        self.buttomView.hidden = !self.buttomView.isHidden;
        return;
    }
    self.topView.hidden = !self.buttomView.isHidden;
    self.buttomView.hidden = !self.buttomView.isHidden;
    self.prefersStatusBarHidden = self.buttomView.isHidden;
    //!(_statusBarAppearanceUpdate)? : _statusBarAppearanceUpdate();
    
    if(self.prefersStatusBarHidden) [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelStatusBar + 1];
    else [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelStatusBar - 1];

}

- (IBAction)backAction {
    [self handleTapGesture:self.fullButton];
}

- (IBAction)handleTapGesture:(UIButton *)sender {

        if (self.state == PlayViewStateSmall) {
            [self enterFullscreen];
            self.buttomView.hidden = NO;
            self.topView.hidden = NO;
            sender.selected = YES;
        }
        else if (self.state == PlayViewStateFullScreen) {
            [self exitFullscreen];
            self.buttomView.hidden = YES;
            self.topView.hidden = YES;
            sender.selected = NO;
        }
}

- (void)enterFullscreen {
    
    if (self.state != PlayViewStateSmall) {
        return;
    }
    
    self.state = PlayViewStateAnimating;
    
    /*
     * 记录进入全屏前的parentView和frame
     */
    self.playViewParentView = self.superview;
    self.playViewSmallFrame = self.frame;
    
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
        self.state = PlayViewStateFullScreen;
    }];
    
    [self refreshStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)exitFullscreen {
    
    if (self.state != PlayViewStateFullScreen) {
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
    NSLog(@"%s--播放器播放失败", __func__);
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





