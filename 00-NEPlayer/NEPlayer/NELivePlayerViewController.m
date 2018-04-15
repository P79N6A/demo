//
//  NELivePlayerViewController.m
//  NELivePlayerDemo
//
//  Created by BiWei on 15-10-10.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import "NELivePlayerViewController.h"
#import "NELivePlayerControl.h"

@interface NELivePlayerViewController ()
{
    BOOL _isMediaSliderBeingDragged;
}
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) UIControl *controlOverlay;
@property (nonatomic, strong) UIView *topControlView;
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UIButton *playQuitBtn;
@property (nonatomic, strong) UILabel *fileName;

@property (nonatomic, strong) UILabel *currentTime;
@property (nonatomic, strong) UILabel *totalDuration;
@property (nonatomic, strong) UISlider *videoProgress;

@property (nonatomic, strong) UIActivityIndicatorView *bufferingIndicate;
@property (nonatomic, strong) UILabel *bufferingReminder;

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UIButton *audioBtn;
@property (nonatomic, strong) UIButton *muteBtn;
@property (nonatomic, strong) UIButton *scaleModeBtn;
@property (nonatomic, strong) UIButton *snapshotBtn;

@end

@implementation NELivePlayerViewController

@synthesize playerView;
@synthesize controlOverlay;
@synthesize topControlView;
@synthesize bottomControlView;
@synthesize playQuitBtn;
@synthesize fileName;

@synthesize currentTime;
@synthesize totalDuration;
@synthesize videoProgress;

@synthesize bufferingIndicate;
@synthesize bufferingReminder;

@synthesize playBtn;
@synthesize pauseBtn;
@synthesize audioBtn;
@synthesize muteBtn;
@synthesize scaleModeBtn;
@synthesize snapshotBtn;
@synthesize mediaControl;

@synthesize timer;

NSTimeInterval mDuration;
NSTimeInterval mCurrPos;
CGFloat screenWidth;
CGFloat screenHeight;
bool isHardware = YES;
bool ismute     = NO;

int mCurrentPostion;

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm completion:(void (^)())completion {
    [viewController presentViewController:[[NELivePlayerViewController alloc] initWithURL:url andDecodeParm:decodeParm] animated:YES completion:completion];
}

- (instancetype)initWithURL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm {
    self = [self initWithNibName:@"NELivePlayerViewController" bundle:nil];
    if (self) {
        self.url = url;
        self.decodeType = [decodeParm objectAtIndex:0];
        self.mediaType = [decodeParm objectAtIndex:1];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)dealloc{
    
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    //当前屏幕宽高
    screenWidth  = CGRectGetWidth([UIScreen mainScreen].bounds);
    screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    self.playerView        = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20)];
    
    self.mediaControl = [[NELivePlayerControl alloc] initWithFrame:CGRectMake(0, 0, screenHeight, screenWidth)];
    [self.mediaControl addTarget:self action:@selector(onClickMediaControl:) forControlEvents:UIControlEventTouchDown];
    
    //控制
    self.controlOverlay = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, screenHeight, screenWidth)];
    [self.controlOverlay addTarget:self action:@selector(onClickOverlay:) forControlEvents:UIControlEventTouchDown];
    
    //顶部控制栏
    self.topControlView    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenHeight, 40)];
    self.topControlView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_background_black.png"]];
    self.topControlView.alpha = 0.8;
    //退出按钮
    self.playQuitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playQuitBtn setImage:[UIImage imageNamed:@"btn_player_quit"] forState:UIControlStateNormal];
    self.playQuitBtn.frame = CGRectMake(10, 0, 40, 40);
    [self.playQuitBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.topControlView addSubview:self.playQuitBtn];
    //文件名
    self.fileName = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, screenHeight - 140, 40)];
    self.fileName.text = [self.url lastPathComponent];
    self.fileName.textAlignment = NSTextAlignmentCenter; //文字居中
    //self.fileName.textColor = [UIColor whiteColor];
    self.fileName.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
    //self.fileName.adjustsFontSizeToFitWidth = YES;
    self.fileName.font = [UIFont fontWithName:self.fileName.font.fontName size:13.0];
    [self.topControlView addSubview:self.fileName];
    
    //缓冲提示
    self.bufferingIndicate = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.bufferingIndicate setCenter:CGPointMake(screenHeight/2, screenWidth/2)];
    [self.bufferingIndicate setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.bufferingIndicate.hidden = YES;
    
    self.bufferingReminder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [self.bufferingReminder setCenter:CGPointMake(screenHeight/2, screenWidth/2 - 50)];
    self.bufferingReminder.text = @"缓冲中";
    self.bufferingReminder.textAlignment = NSTextAlignmentCenter; //文字居中
    self.bufferingReminder.textColor = [UIColor whiteColor];
    self.bufferingReminder.hidden = YES;
    
    
    //底部控制栏
    self.bottomControlView = [[UIView alloc] initWithFrame:CGRectMake(0, screenWidth - 50, screenHeight, 50)];
    self.bottomControlView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_background_black.png"]];
    self.bottomControlView.alpha = 0.8;
    
    //播放按钮
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"btn_player_pause"] forState:UIControlStateNormal];
    self.playBtn.frame = CGRectMake(10, 5, 40, 40);
    [self.playBtn addTarget:self action:@selector(onClickPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomControlView addSubview:self.playBtn];
    
    //暂停按钮
    self.pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pauseBtn setImage:[UIImage imageNamed:@"btn_player_play"] forState:UIControlStateNormal];
    self.pauseBtn.frame = CGRectMake(10, 5, 40, 40);
    [self.pauseBtn addTarget:self action:@selector(onClickPause:) forControlEvents:UIControlEventTouchUpInside];
    self.pauseBtn.hidden = YES;
    [self.bottomControlView addSubview:self.pauseBtn];
    
    
    //当前播放的时间点
    self.currentTime = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 50, 20)];
    self.currentTime.text = @"00:00:00"; //for test
    self.currentTime.textAlignment = NSTextAlignmentCenter;
    //self.currentTime.textColor = [UIColor whiteColor];
    self.currentTime.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
    //self.fileName.adjustsFontSizeToFitWidth = YES;
    self.currentTime.font = [UIFont fontWithName:self.currentTime.font.fontName size:10.0];
    [self.bottomControlView addSubview:self.currentTime];
    
    //播放进度条
    self.videoProgress = [[UISlider alloc] initWithFrame:CGRectMake(100, 10, screenHeight-320, 30)];
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"btn_player_slider_thumb"] forState:UIControlStateNormal];
    [[UISlider appearance]  setMaximumTrackImage:[UIImage imageNamed:@"btn_player_slider_all"] forState:UIControlStateNormal];
    [[UISlider appearance]  setMinimumTrackImage:[UIImage imageNamed:@"btn_player_slider_played"] forState:UIControlStateNormal];
    
    [self.videoProgress addTarget:self action:@selector(onClickSeek:) forControlEvents:UIControlEventValueChanged];
    [self.videoProgress addTarget:self action:@selector(onClickSeekTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoProgress addTarget:self action:@selector(onClickSeekTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.bottomControlView addSubview:self.videoProgress];
    
    
    //文件总时长
    self.totalDuration = [[UILabel alloc] initWithFrame:CGRectMake(screenHeight-215, 15, 50, 20)];
    self.totalDuration.text = @"--:--:--";
    self.totalDuration.textAlignment = NSTextAlignmentCenter;
    //self.totalDuration.textColor = [UIColor whiteColor];
    self.totalDuration.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
    self.totalDuration.font = [UIFont fontWithName:self.totalDuration.font.fontName size:10.0];
    [self.bottomControlView addSubview:self.totalDuration];
    
    
    //声音打开按钮
    self.audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.audioBtn setImage:[UIImage imageNamed:@"btn_player_mute02"] forState:UIControlStateNormal];
    self.audioBtn.frame = CGRectMake(screenHeight-150, 5, 40, 40);
    [self.audioBtn addTarget:self action:@selector(onClickMute:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomControlView addSubview:self.audioBtn];
    
    //静音按钮
    self.muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.muteBtn setImage:[UIImage imageNamed:@"btn_player_mute01"] forState:UIControlStateNormal];
    self.muteBtn.frame = CGRectMake(screenHeight-150, 5, 40, 40);
    [self.muteBtn addTarget:self action:@selector(onClickMute:) forControlEvents:UIControlEventTouchUpInside];
    self.muteBtn.hidden = YES;
    [self.bottomControlView addSubview:self.muteBtn];
    
    //截图
    self.snapshotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.snapshotBtn setImage:[UIImage imageNamed:@"btn_player_snap"] forState:UIControlStateNormal];
    self.snapshotBtn.frame = CGRectMake(screenHeight-100, 5, 40, 40);
    if ([self.mediaType isEqualToString:@"localAudio"]) {
        self.snapshotBtn.hidden = YES;
    }
    [self.snapshotBtn addTarget:self action:@selector(onClickSnapshot:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomControlView addSubview:self.snapshotBtn];
    
    
    //显示模式
    self.scaleModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
    self.scaleModeBtn.frame = CGRectMake(screenHeight-50, 5, 40, 40);
    if ([self.mediaType isEqualToString:@"localAudio"]) {
        self.scaleModeBtn.hidden = YES;
    }
    
    [self.scaleModeBtn addTarget:self action:@selector(onClickScaleMode:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomControlView addSubview:self.scaleModeBtn];
    
    if ([self.decodeType isEqualToString:@"hardware"]) {
        isHardware = YES;
    }
    else if ([self.decodeType isEqualToString:@"software"]) {
        isHardware = NO;
    }
    
    [self.controlOverlay addSubview:self.topControlView];
    [self.controlOverlay addSubview:self.bottomControlView];
    
    [NELivePlayerController setLogLevel:NELP_LOG_VERBOSE];
    
    self.liveplayer = [[NELivePlayerController alloc] initWithContentURL:self.url];
    if (self.liveplayer == nil) {
        NSLog(@"player initilize failed, please tay again!");
    }
    self.liveplayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.liveplayer.view.frame = self.playerView.bounds;
    
    self.view.autoresizesSubviews = YES;
    
    [self.mediaControl addSubview:self.controlOverlay];
    [self.view addSubview:self.liveplayer.view];
    [self.view addSubview:self.mediaControl];
    [self.view addSubview:self.bufferingIndicate];
    [self.view addSubview:self.bufferingReminder];
    self.mediaControl.delegatePlayer = self.liveplayer;
}

- (BOOL)prefersStatusBarHidden
{
    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 已经不起作用了
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    if ([self.mediaType isEqualToString:@"livestream"] ) {
        [self.liveplayer setBufferStrategy:NELPLowDelay]; // 直播低延时模式
    }
    else {
        [self.liveplayer setBufferStrategy:NELPAntiJitter]; // 点播抗抖动
    }
    [self.liveplayer setScalingMode:NELPMovieScalingModeNone]; // 设置画面显示模式，默认原始大小
    [self.liveplayer setShouldAutoplay:YES]; // 设置prepareToPlay完成后是否自动播放
    [self.liveplayer setHardwareDecoder:isHardware]; // 设置解码模式，是否开启硬件解码
    [self.liveplayer setPauseInBackground:NO]; // 设置切入后台时的状态，暂停还是继续播放
    [self.liveplayer setPlaybackTimeout:15 *1000]; // 设置拉流超时时间
    
#ifdef KEY_IS_KNOWN // 视频云加密的视频，自己已知密钥
    NSString *key = @"HelloWorld";
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    Byte *flv_key = (Byte *)[keyData bytes];
    
    unsigned long len = [keyData length];
    flv_key[len] = '\0';
    __weak typeof(self) weakSelf = self;
    [self.liveplayer setDecryptionKey:flv_key andKeyLength:(int)len :^(NELPKeyCheckResult ret) {
        if (ret == 0 || ret == 1) {
            [weakSelf.liveplayer prepareToPlay];
        }
    }];
    
#else
    
#ifdef DECRYPT //用视频云整套加解密系统
    if ([self.mediaType isEqualToString:@"videoOnDemand"]) {
        NSString *transferToken = NULL;
        NSString *accid = NULL;
        NSString *appKey = NULL;
        NSString *token = NULL;
        [self.liveplayer initDecryption:transferToken :accid :appKey :token :^(NELPKeyCheckResult ret) {
            NSLog(@"ret = %d", ret);
            switch (ret) {
                case NELP_NO_ENCRYPTION:
                case NELP_ENCRYPTION_CHECK_OK:
                    [self.liveplayer prepareToPlay];
                    break;
                case NELP_ENCRYPTION_UNSUPPORT_PROTOCAL:
                    [self decryptWarning:@"NELP_ENCRYPTION_UNSUPPORT_PROTOCAL"];
                    break;
                case NELP_ENCRYPTION_KEY_CHECK_ERROR:
                    [self decryptWarning:@"NELP_ENCRYPTION_KEY_CHECK_ERROR"];
                    break;
                case NELP_ENCRYPTION_INPUT_INVALIED:
                    [self decryptWarning:@"NELP_ENCRYPTION_INPUT_INVALIED"];
                    break;
                case NELP_ENCRYPTION_UNKNOWN_ERROR:
                    [self decryptWarning:@"NELP_ENCRYPTION_UNKNOWN_ERROR"];
                    break;
                case NELP_ENCRYPTION_GET_KEY_TIMEOUT:
                    [self decryptWarning:@"NELP_ENCRYPTION_GET_KEY_TIMEOUT"];
                    break;
                default:
                    break;
            }
        }];
    }
#else
    [self.liveplayer prepareToPlay];
#endif
#endif
}

- (void)decryptWarning:(NSString *)msg {
    UIAlertController *alertController = NULL;
    UIAlertAction *action = NULL;
    
    alertController = [UIAlertController alertControllerWithTitle:@"注意" message:msg preferredStyle:UIAlertControllerStyleAlert];
    action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (self.presentingViewController) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    NSLog(@"viewDidLoad");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerDidPreparedToPlay:)
                                                 name:NELivePlayerDidPreparedToPlayNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerPlaybackStateChanged:)
                                                 name:NELivePlayerPlaybackStateChangedNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NeLivePlayerloadStateChanged:)
                                                 name:NELivePlayerLoadStateChangedNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerPlayBackFinished:)
                                                 name:NELivePlayerPlaybackFinishedNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstVideoDisplayed:)
                                                 name:NELivePlayerFirstVideoDisplayedNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstAudioDisplayed:)
                                                 name:NELivePlayerFirstAudioDisplayedNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerReleaseSuccess:)
                                                 name:NELivePlayerReleaseSueecssNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerVideoParseError:)
                                                 name:NELivePlayerVideoParseErrorNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerSeekComplete:)
                                                 name:NELivePlayerMoviePlayerSeekCompletedNotification
                                               object:_liveplayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

#pragma mark - IBAction

//退出播放
- (void)onClickBack:(id)sender
{
    NSLog(@"click back!");
    [self.liveplayer shutdown]; // 退出播放并释放相关资源
    [self.liveplayer.view removeFromSuperview];
    self.liveplayer = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerDidPreparedToPlayNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerLoadStateChangedNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerPlaybackFinishedNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerFirstVideoDisplayedNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerFirstAudioDisplayedNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerVideoParseErrorNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerPlaybackStateChangedNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerMoviePlayerSeekCompletedNotification object:_liveplayer];
    
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

//seek操作
- (void)onClickSeek:(id)sender
{
    NSLog(@"click seek");
    if ([self.mediaType isEqualToString:@"livestream"]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意" message:@"直播流不支持seek操作." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    NSTimeInterval currentPlayTime = self.videoProgress.value;
    mCurrentPostion = (int)currentPlayTime;
    self.currentTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)(mCurrentPostion / 3600), (int)(mCurrentPostion > 3600 ? (mCurrentPostion - (mCurrentPostion / 3600)*3600) / 60 : mCurrentPostion/60), (int)(mCurrentPostion % 60)];
}

- (void)onClickSeekTouchUpInside:(id)sender
{
    NSLog(@"onClickSeekTouchUpInside");
    self.liveplayer.currentPlaybackTime = mCurrentPostion;
    _isMediaSliderBeingDragged = NO;
}

- (void)onClickSeekTouchUpOutside:(id)sender
{
    NSLog(@"onClickSeekTouchUpOutside");
    _isMediaSliderBeingDragged = NO;
}

//开始播放
- (void)onClickPlay:(id)sender
{
    NSLog(@"click play");
    [self.liveplayer play];
}

//暂停播放
- (void)onClickPause:(id)sender
{
    NSLog(@"click pause");
    [self.liveplayer pause];
}

//静音
- (void)onClickMute:(id)sender
{
    NSLog(@"click mute");
    if (ismute) {
        [self.liveplayer setMute:!ismute];
        self.muteBtn.hidden = YES;
        self.audioBtn.hidden = NO;
        ismute = NO;
    }
    else {
        [self.liveplayer setMute:!ismute];
        self.muteBtn.hidden = NO;
        self.audioBtn.hidden = YES;
        ismute = YES;
    }
}

//显示模式
- (void)onClickScaleMode:(id)sender
{
    //    NSLog(@"click scale mode %ld", scaleModeBtn.titleLabel.tag);
    switch (self.scaleModeBtn.titleLabel.tag) {
        case 0:
            [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
            [self.liveplayer setScalingMode:NELPMovieScalingModeNone];
            
            self.scaleModeBtn.titleLabel.tag = 1;
            break;
        case 1:
            [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
            [self.liveplayer setScalingMode:NELPMovieScalingModeAspectFill];
            self.scaleModeBtn.titleLabel.tag = 0;
            break;
        default:
            [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
            [self.liveplayer setScalingMode:NELPMovieScalingModeAspectFill];
            self.scaleModeBtn.titleLabel.tag = 0;
            break;
    }
}

//截图
- (void)onClickSnapshot:(id)sender
{
    NSLog(@"click snap");
    
    UIImage *snapImage = [self.liveplayer getSnapshot];
    
    UIImageWriteToSavedPhotosAlbum(snapImage, nil, nil, nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"截图已保存到相册" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

//触摸overlay
- (void)onClickOverlay:(id)sender
{
    NSLog(@"click overlay");
    self.controlOverlay.hidden = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
}

- (void)onClickMediaControl:(id)sender
{
    NSLog(@"click mediacontrol");
    self.controlOverlay.hidden = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
    [self performSelector:@selector(controlOverlayHide) withObject:nil afterDelay:8];
}

- (void)controlOverlayHide
{
    self.controlOverlay.hidden = YES;
}

dispatch_source_t CreateDispatchSyncUITimer(double interval, dispatch_queue_t queue, dispatch_block_t block)
{
    //创建Timer
    dispatch_source_t timer  = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);//queue是一个专门执行timer回调的GCD队列
    if (timer) {
        //使用dispatch_source_set_timer函数设置timer参数
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval*NSEC_PER_SEC), interval*NSEC_PER_SEC, (1ull * NSEC_PER_SEC)/10);
        //设置回调
        dispatch_source_set_event_handler(timer, block);
        //dispatch_source默认是Suspended状态，通过dispatch_resume函数开始它
        dispatch_resume(timer);
    }
    
    return timer;
}

- (void)syncUIStatus
{
    self.playBtn.hidden = YES;
    self.pauseBtn.hidden = NO;
    
    __block bool getDurFlag = false;
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t syncUIQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = CreateDispatchSyncUITimer(1.0, syncUIQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.mediaType isEqualToString:@"videoOnDemand"] || !getDurFlag) {
                mDuration = [weakSelf.liveplayer duration];
                if (mDuration > 0) {
                    getDurFlag = true;
                }
            }
            NSInteger duration = round(mDuration);
            
            if (_isMediaSliderBeingDragged) {
                mCurrPos = self.videoProgress.value;
            }
            else {
                mCurrPos  = [weakSelf.liveplayer currentPlaybackTime];
            }
            NSInteger currPos  = round(mCurrPos);
            
            self.currentTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)(currPos / 3600), (int)(currPos > 3600 ? (currPos - (currPos / 3600)*3600) / 60 : currPos/60), (int)(currPos % 60)];
            
            if (duration > 0) {
                self.totalDuration.text = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)(duration / 3600), (int)(duration > 3600 ? (duration - 3600 * (duration / 3600)) / 60 : duration/60), (int)(duration > 3600 ? ((duration - 3600 * (duration / 3600)) % 60) :(duration % 60))];
                self.videoProgress.value = mCurrPos;
                self.videoProgress.maximumValue = mDuration;
            } else {
                [self.videoProgress setValue:0.0f];
            }
            
            if ([self.liveplayer playbackState] == NELPMoviePlaybackStatePlaying) {
                self.playBtn.hidden = YES;
                self.pauseBtn.hidden = NO;
            }
            else {
                self.playBtn.hidden = NO;
                self.pauseBtn.hidden = YES;
            }
        });
    });
}

- (void)NELivePlayerDidPreparedToPlay:(NSNotification*)notification
{
    //add some methods
    NSLog(@"NELivePlayerDidPreparedToPlay");
    [self syncUIStatus];
    [self.liveplayer play]; //开始播放
}

- (void)NELivePlayerPlaybackStateChanged:(NSNotification*)notification
{
    //    NSLog(@"NELivePlayerPlaybackStateChanged");
}

- (void)NeLivePlayerloadStateChanged:(NSNotification*)notification
{
    NELPMovieLoadState nelpLoadState = _liveplayer.loadState;
    
    if (nelpLoadState == NELPMovieLoadStatePlaythroughOK)
    {
        NSLog(@"finish buffering");
        self.bufferingIndicate.hidden = YES;
        self.bufferingReminder.hidden = YES;
        [self.bufferingIndicate stopAnimating];
    }
    else if (nelpLoadState == NELPMovieLoadStateStalled)
    {
        NSLog(@"begin buffering");
        self.bufferingIndicate.hidden = NO;
        self.bufferingReminder.hidden = NO;
        [self.bufferingIndicate startAnimating];
    }
}

- (void)NELivePlayerPlayBackFinished:(NSNotification*)notification
{
    UIAlertController *alertController = NULL;
    UIAlertAction *action = NULL;
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
        case NELPMovieFinishReasonPlaybackEnded:
            if ([self.mediaType isEqualToString:@"livestream"]) {
                alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"直播结束" preferredStyle:UIAlertControllerStyleAlert];
                action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    if (self.presentingViewController) {
                        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    }}];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            break;
            
        case NELPMovieFinishReasonPlaybackError:
        {
            alertController = [UIAlertController alertControllerWithTitle:@"注意" message:@"播放失败" preferredStyle:UIAlertControllerStyleAlert];
            action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                if (self.presentingViewController) {
                    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        }
            
        case NELPMovieFinishReasonUserExited:
            break;
            
        default:
            break;
    }
}

- (void)NELivePlayerFirstVideoDisplayed:(NSNotification*)notification
{
    NSLog(@"first video frame rendered!");
}

- (void)NELivePlayerFirstAudioDisplayed:(NSNotification*)notification
{
    NSLog(@"first audio frame rendered!");
}

- (void)NELivePlayerVideoParseError:(NSNotification*)notification
{
    NSLog(@"video parse error!");
}

- (void)NELivePlayerSeekComplete:(NSNotification*)notification
{
    NSLog(@"seek complete!");
}

- (void)NELivePlayerReleaseSuccess:(NSNotification*)notification
{
    NSLog(@"resource release success!!!");
    // 释放timer
    if (timer != nil) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerReleaseSueecssNotification object:_liveplayer];
}


@end
