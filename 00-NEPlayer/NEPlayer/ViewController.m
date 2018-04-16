//
//  ViewController.m
//  NEPlayer
//
//  Created by czljcb on 2017/10/27.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "ViewController.h"
#import "NELivePlayer.h"
#import "NELivePlayerController.h"

#import "NELivePlayerViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *bufferingIndicate;

@property(nonatomic, strong) id<NELivePlayer> liveplayer;
@property (nonatomic, strong) UIView *playerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    NSURL *url = [NSURL URLWithString:@"http://rthkaudio2-lh.akamaihd.net/i/radio2_1@355865/master.m3u8"];

    //    return;
    // Do any additional setup after loading the view, typically from a nib.
    self.liveplayer = [[NELivePlayerController alloc]
                       initWithContentURL:[NSURL URLWithString:@"http://api_p.tll888.com/v/jade.php"]];
    
    //    CGFloat screenWidth  = CGRectGetWidth([UIScreen mainScreen].bounds);
    //    self.playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 200)];
    if (self.liveplayer == nil) {
        NSLog(@"player initilize failed, please tay again!");
    }
    //    self.liveplayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //    self.liveplayer.view.frame = self.playerView.bounds;
    //
    //    self.view.autoresizesSubviews = YES;
    //
    //    [self.view addSubview:self.liveplayer.view];
    
    //
    //
    //设置播放缓冲策略，直播采用低延时模式或流畅模式，点播采用抗抖动模式，具体可参见API文档
    [self.liveplayer setBufferStrategy:NELPFluent];
    //设置画面显示模式，默认按原始大小进行播放，具体可参见API文档
    //[self.liveplayer setScalingMode:NELPMovieScalingModeAspectFit];
    //设置视频文件初始化完成后是否自动播放，默认自动播放
    [self.liveplayer setShouldAutoplay:YES];
    //设置是否开启硬件解码，IOS 8.0以上支持硬件解码，默认为软件解码
    [self.liveplayer setHardwareDecoder:YES];
    //设置播放器切入后台后时暂停还是继续播放，默认暂停
    [self.liveplayer setPauseInBackground:YES];
    [self.liveplayer prepareToPlay];
    //[self.liveplayer play];
    
    // 播放器媒体流初始化完成后触发，收到该通知表示可以开始播放
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerDidPreparedToPlay:)
                                                 name:NELivePlayerDidPreparedToPlayNotification
                                               object:_liveplayer];
    
    // 播放器加载状态发生变化时触发，如开始缓冲，缓冲结束
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NeLivePlayerloadStateChanged:)
                                                 name:NELivePlayerLoadStateChangedNotification
                                               object:_liveplayer];
    
    // 正常播放结束或播放过程中发生错误导致播放结束时触发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerPlayBackFinished:)
                                                 name:NELivePlayerPlaybackFinishedNotification
                                               object:_liveplayer];
    
    // 第一帧视频图像显示时触发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstVideoDisplayed:)
                                                 name:NELivePlayerFirstVideoDisplayedNotification
                                               object:_liveplayer];
    
    // 第一帧音频播放时触发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstAudioDisplayed:)
                                                 name:NELivePlayerFirstAudioDisplayedNotification
                                               object:_liveplayer];
    
    
    // 资源释放成功后触发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerReleaseSuccess:)
                                                 name:NELivePlayerReleaseSueecssNotification
                                               object:_liveplayer];
    
    // 视频码流解析失败时触发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerVideoParseError:)
                                                 name:NELivePlayerVideoParseErrorNotification
                                               object:_liveplayer];
    //播放器资源释放完成时的消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerReleaseSuccess:)
                                                 name:NELivePlayerReleaseSueecssNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerSeekComplete:)
                                                 name:NELivePlayerMoviePlayerSeekCompletedNotification
                                               object:_liveplayer];
    ///播放器播放状态发生改变时的消息通知

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerPlaybackStateChanged:)
                                                 name:NELivePlayerPlaybackStateChangedNotification
                                               object:_liveplayer];

}




#pragma mark  -  播放器媒体流初始化完成后触发，收到该通知表示可以开始播放
- (void)NELivePlayerDidPreparedToPlay:(NSNotification*)notification
{
    //add some methods
    NSLog(@"开始播放");
    [self.liveplayer play]; //开始播放
    
}
///播放器播放状态发生改变时的消息通知

- (void)NELivePlayerPlaybackStateChanged:(NSNotification*)notification
{
    NSLog(@"NELivePlayerPlaybackStateChanged");
}
#pragma mark  -  播放器加载状态发生变化时触发，如开始缓冲，缓冲结束
- (void)NeLivePlayerloadStateChanged:(NSNotification*)notification
{
    NELPMovieLoadState nelpLoadState = _liveplayer.loadState;
    
    if (nelpLoadState == NELPMovieLoadStatePlaythroughOK)
    {
        NSLog(@"finish buffering");
        //            self.bufferingIndicate.hidden = YES;
        //            self.bufferingReminder.hidden = YES;
                    [self.bufferingIndicate stopAnimating];
    }
    else if (nelpLoadState == NELPMovieLoadStateStalled)
    {
        NSLog(@"begin buffering");
        //            self.bufferingIndicate.hidden = NO;
        //            self.bufferingReminder.hidden = NO;
                    [self.bufferingIndicate startAnimating];
    }
}
#pragma mark  -  正常播放结束或播放过程中发生错误导致播放结束时触发的通知

- (void)NELivePlayerPlayBackFinished:(NSNotification*)notification
{
    UIAlertController *alertController = NULL;
    UIAlertAction *action = NULL;
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
        case NELPMovieFinishReasonPlaybackEnded:
        {
            alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"直播结束" preferredStyle:UIAlertControllerStyleAlert];
            action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                if (self.presentingViewController) {
                    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }}];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            
            break;
        }
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
#pragma mark  -  第一帧视频图像显示时触发的通知

- (void)NELivePlayerFirstVideoDisplayed:(NSNotification*)notification
{
    NSLog(@"first video frame rendered!");
}
#pragma mark  -  第一帧音频播放时触发的通知
- (void)NELivePlayerFirstAudioDisplayed:(NSNotification*)notification
{
    NSLog(@"first audio frame rendered!");
}
#pragma mark  -  视频码流解析失败时触发的通知
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
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerReleaseSueecssNotification object:_liveplayer];
}



@end
