//
//  ViewController.m
//  JSPlayer
//
//  Created by Jay on 3/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import <KSYMediaPlayer/KSYMediaPlayer.h>
#import "JSPlayer/PlayerView.h"

@interface ViewController ()
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) KSYMoviePlayerController *player;
@property (nonatomic, strong) NSMutableArray *registeredNotifications;
@property (nonatomic, assign) long long int prepared_time;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, strong) NSArray *status;
@property (nonatomic, strong) NSArray *loadStatus;
@property (nonatomic, weak) PlayerView *playerView;
@end

@implementation ViewController
- (IBAction)video:(id)sender {
    VideoModel *model = [VideoModel new];
    model.title = @"hello tv";
    model.url = @"https://cdn.youku-letv.com/20181022/m4MlVDnt/index.m3u8";
    [_playerView playWithModel:model];
    
    //    self.spStatusBarStyle = UIStatusBarStyleDefault;
    //    self.spStatusBarHidden = YES;
    
}

- (IBAction)living:(id)sender {
    VideoModel *model = [VideoModel new];
    model.title = @"hello tv";
    model.url = @"http://m.567it.com/j5.m3u8";
    
    [_playerView playWithModel:model];
    //self.spStatusBarStyle = UIStatusBarStyleLightContent;
    //    self.spStatusBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    VideoModel *model = [VideoModel new];
    model.title = @"hello tv";
    //    model.live_stream = [NSURL fileURLWithPath:@"/Users/jay/Downloads/20180503102411_460.mp4"];
    model.url = @"https://cdn.youku-letv.com/20181022/m4MlVDnt/index.m3u8";
    //    model.live_stream = @"http://e1.vdowowza.vip.hk1.tvb.com/tvblive/smil:mobilehd_financeintl.smil/playlist.m3u8";
    //    model.live_stream = @"http://onair.onair.network:8068/listen.pls";
    
    PlayerView *player = [PlayerView playerView];
    player.frame = CGRectMake( 0, 100, 300,  300 * 9.0 / 16.0);
    player.allowSafariPlay = YES;
    [player playWithModel:model];
    [self.view addSubview:player];
    _playerView = player;
    
    
    return;
    _loadStatus = @[@"加载情况未知",@"加载完成，可以播放",@"加载完成，如果shouldAutoplay为YES，将自动开始播放",@"如果视频正在加载中"];
    _status = @[@"播放停止",@"正在播放",@"播放暂停",@"播放被打断",@"向前seeking中",@"向后seeking中"];

    _registeredNotifications = [NSMutableArray array];
    _videoView = [[UIView alloc] init];
    _videoView.frame = CGRectMake( 0, 0,  [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.width * 16.0 / 9.0);
    [self.view addSubview:_videoView];
    
    _videoView.backgroundColor = [UIColor lightGrayColor];
    _player = [[KSYMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:@"https://doubanzyv1.tyswmp.com/2018/07/30/yLdWQynQOGPZjkK2/playlist.m3u8"]];
    _player.controlStyle = MPMovieControlStyleNone;
    [_player.view setFrame: _videoView.bounds];  // player's frame must match parent's
    [_videoView addSubview: _player.view];
    _videoView.autoresizesSubviews = NO;
    _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _player.shouldAutoplay = YES;
    _player.scalingMode = MPMovieScalingModeAspectFit;
    
    [self setupObservers:_player];
    _prepared_time = (long long int)([self getCurrentTime] * 1000);

    [_player prepareToPlay];
    

}
- (IBAction)click:(UIButton *)sender {
    
    
    NSArray *lists = @[@"rtmp://live.hkstv.hk.lxdns.com/live/hks",@"https://cdn.youku-letv.com/20181022/m4MlVDnt/index.m3u8",@"http://m.567it.com/jade.m3u8"];
    
    VideoModel *model = [VideoModel new];
    model.title = @"hello tv";
    model.url = lists[sender.tag];
    
    [self.playerView playWithModel:model];

    
}


- (void)registerObserver:(NSString *)notification player:(KSYMoviePlayerController*)player {
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(notification)
                                              object:player];
    [_registeredNotifications addObject:notification];
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

- (void)releaseObservers:(KSYMoviePlayerController*)player
{
    for (NSString *name in _registeredNotifications) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:name
                                                      object:player];
    }
}



-(void)handlePlayerNotify:(NSNotification*)notify
{
    if (!_player) {
        return;
    }
    if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification ==  notify.name) {
        NSLog(@"总时长：%f-----player prepared",_player.duration);
        if(_player.shouldAutoplay == NO) [_player play];
        NSLog(@"视频源: %@ -- 服务器ip:%@", [[_player contentURL] absoluteString], [_player serverAddress]);
        NSLog(@"媒体mediaMeta：%@",[_player getMetadata]);

        _reloading = NO;
    }
    if (MPMoviePlayerPlaybackStateDidChangeNotification ==  notify.name) {
        NSLog(@"------------------------");
        NSLog(@"播放状态: %@", _status[(long)_player.playbackState]);
        NSLog(@"------------------------");
    }
    if (MPMoviePlayerLoadStateDidChangeNotification ==  notify.name) {
        NSLog(@"加载状态: %@", _loadStatus[(long)_player.loadState]);
        if (MPMovieLoadStateStalled & _player.loadState) {
            NSLog(@"开始缓存。。。");
        }
        
        if (_player.bufferEmptyCount &&
            (MPMovieLoadStatePlayable & _player.loadState ||
             MPMovieLoadStatePlaythroughOK & _player.loadState)){
                NSLog(@"缓存结束。。。");
                NSString *message = [[NSString alloc]initWithFormat:@"loading occurs, %d - %0.3fs",
                                     (int)_player.bufferEmptyCount,
                                     _player.bufferEmptyDuration];
                NSLog(@"%@",message);

            }
    }
    if (MPMoviePlayerPlaybackDidFinishNotification ==  notify.name) {
        NSLog(@"player finish state: %@", _status[(long)_player.playbackState]);
        NSLog(@"player download flow size: %f MB", _player.readSize);
        NSLog(@"buffer monitor  result: \n   empty count: %d, lasting: %f seconds",
              (int)_player.bufferEmptyCount,
              _player.bufferEmptyDuration);
        //结束播放的原因
        int reason = [[[notify userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
        if (reason ==  MPMovieFinishReasonPlaybackEnded) {
            NSLog(@"player finish");

        }else if (reason == MPMovieFinishReasonPlaybackError){
            NSLog(@"%@",[NSString stringWithFormat:@"player Error : %@", [[notify userInfo] valueForKey:@"error"]]);

        }else if (reason == MPMovieFinishReasonUserExited){
            NSLog(@"player userExited");

            
        }
    }
    if (MPMovieNaturalSizeAvailableNotification ==  notify.name) {
        NSLog(@"video size %.0f-%.0f, rotate:%ld\n", _player.naturalSize.width, _player.naturalSize.height, (long)_player.naturalRotate);
        if(((_player.naturalRotate / 90) % 2  == 0 && _player.naturalSize.width > _player.naturalSize.height) ||
           ((_player.naturalRotate / 90) % 2 != 0 && _player.naturalSize.width < _player.naturalSize.height))
        {
            //如果想要在宽大于高的时候横屏播放，你可以在这里旋转
        }
    }
    if (MPMoviePlayerFirstVideoFrameRenderedNotification == notify.name)
    {
        long long int   fvr_costtime = (int)((long long int)([self getCurrentTime] * 1000) - _prepared_time);
        NSLog(@"first video frame show, cost time : %dms!\n", fvr_costtime);
    }
    
    if (MPMoviePlayerFirstAudioFrameRenderedNotification == notify.name)
    {
        long long int far_costtime = (int)((long long int)([self getCurrentTime] * 1000) - _prepared_time);
        NSLog(@"first audio frame render, cost time : %dms!\n", far_costtime);
    }
    
    if (MPMoviePlayerSuggestReloadNotification == notify.name)
    {
        NSLog(@"suggest using reload function!\n");
        if(!_reloading)
        {
            _reloading = YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(){
                if (_player) {
                    NSLog(@"reload stream");
                    [_player reload:[NSURL URLWithString:@"http://vip888.kuyun99.com/20180802/wcFfyu0v/index.m3u8?sign=9a2f77b13159249164e257ed7356dab84549a9f7b9a70e5509bc3e0359cdcfd7a258b5708ab7d87677196d08cb14c397bce8db18e488383ddf21376648d73e35"] flush:YES mode:MPMovieReloadMode_Accurate];
                }
            });
        }
    }
    
    if(MPMoviePlayerPlaybackStatusNotification == notify.name)
    {
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
    }
    if(MPMoviePlayerNetworkStatusChangeNotification == notify.name)
    {
        int currStatus = [[[notify userInfo] valueForKey:MPMoviePlayerCurrNetworkStatusUserInfoKey] intValue];
        int lastStatus = [[[notify userInfo] valueForKey:MPMoviePlayerLastNetworkStatusUserInfoKey] intValue];
        NSLog(@"network reachable change from %@ to %@\n", [self netStatus2Str:lastStatus], [self netStatus2Str:currStatus]);
    }
    if(MPMoviePlayerSeekCompleteNotification == notify.name)
    {
        NSLog(@"Seek complete");
    }
    
    if (MPMoviePlayerPlaybackTimedTextNotification == notify.name)
    {
        NSString *timedText = [[notify userInfo] valueForKey:MPMoviePlayerPlaybackTimedTextUserInfoKey];
        
        NSLog(@"%s---%@", __func__,timedText);
    }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
