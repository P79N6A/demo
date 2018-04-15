//
//  ViewController.m
//  playerView
//
//  Created by czljcb on 2018/4/5.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "ViewController.h"
#import <AliyunPlayerSDK/AlivcMediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()
@property (nonatomic, weak) UIButton *fullBtn;
@property (nonatomic, strong) AliVcMediaPlayer *mediaPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    return;
    UIView *playView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 200)];
    playView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:playView];
    
    
    
    //创建播放器
    self.mediaPlayer = [[AliVcMediaPlayer alloc] init];
    //创建播放器视图，其中contentView为UIView实例，自己根据业务需求创建一个视图即可
    /*self.mediaPlayer:NSObject类型，需要UIView来展示播放界面。
     self.contentView：承载mediaPlayer图像的UIView类。
     self.contentView = [[UIView alloc] init];
     [self.view addSubview:self.contentView];
     */
    
    [self.mediaPlayer  create:playView];
    //设置播放类型，0为点播、1为直播，默认使用自动
    self.mediaPlayer .mediaType = MediaType_AUTO;
    //设置超时时间，单位为毫秒
    self.mediaPlayer .timeout = 25000;
    //缓冲区超过设置值时开始丢帧，单位为毫秒。直播时设置，点播设置无效。范围：500～100000
    self.mediaPlayer .dropBufferDuration = 8000;
    
    [self addNotification];

    [self.mediaPlayer  prepareToPlay:[NSURL URLWithString:@"http://s-423975.gotocdn.com:6330/v/iptv.php?id=jswshd-1"]];
    
    //开始播放
   AliVcMovieErrorCode code = [self.mediaPlayer  play];

    
    UIButton *fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fullBtn.frame = CGRectMake(100, 100, 35, 35);
    [playView addSubview:fullBtn];
    [playView bringSubviewToFront:fullBtn];
    [fullBtn setTitle:@"full" forState:UIControlStateNormal];
    [fullBtn setBackgroundColor:[UIColor blackColor]];
    self.fullBtn = fullBtn;
    
    [fullBtn addTarget:self action:@selector(fullAction:) forControlEvents:UIControlEventTouchUpInside];
    
    

    
}

static SystemSoundID soundID = 0;

- (IBAction)play:(id)sender {
    
    //    NSString *str = [[NSBundle mainBundle] pathForResource:@"vcyber_waiting" ofType:@"wav"];
//    NSString *str = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"caf"];
    //    NSString *str = [[NSBundle mainBundle] pathForResource:@"48s" ofType:@"mp3"];
//    NSURL *url = [NSURL fileURLWithPath:str];
    
    NSString *str = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:str];
    NSData *encodeData = [NSData dataWithContentsOfURL:url];
    
//    NSString *base64String = [encodeData base64EncodedStringWithOptions:NSUTF8StringEncoding];
    
    NSString *base64String = @"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";//[self encode:encodeData];
    NSLog(@"%s--%@", __func__,base64String);
    
//    NSData *data = [base64String dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [self dencode:base64String];
    
   BOOL flag = [data writeToFile:@"/Users/czljcb/Desktop/timg.caf" atomically:YES];

    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
    //
    //    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallBack, NULL);
    //
    //    //AudioServicesPlaySystemSound(soundID);
    //
    //    AudioServicesPlayAlertSound(soundID);
    
    
    //    AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
    //        NSLog(@"播放完成");
    //        AudioServicesDisposeSystemSoundID(soundID);
    //    });
    
    AudioServicesPlayAlertSoundWithCompletion(soundID, ^{
        NSLog(@"播放完成");
    });
    
}

void soundCompleteCallBack(SystemSoundID soundID, void * clientDate) {
    NSLog(@"播放完成");
    AudioServicesDisposeSystemSoundID(soundID);
}

- (IBAction)stop:(id)sender {
    AudioServicesDisposeSystemSoundID(soundID);
}


//64编码
- (NSString *)encode:(NSData *)data
{
    //先将string转换成data
    //NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    return baseString;
}

//64解码
- (NSData *)dencode:(NSString *)base64String
{
    //NSData *base64data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
//    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return data;
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

#pragma mark  - 获取到视频的相关信息
- (void)OnVideoPrepared:(NSNotification *)noti{
    NSLog(@"%s--获取到视频的相关信息", __func__);
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
    
}

#pragma mark  - 播放器结束缓冲视频
- (void)OnEndCache:(NSNotification *)noti{
    NSLog(@"%s--播放器结束缓冲视频", __func__);
    
}

#pragma mark  - 播放器主动调用Stop功能
- (void)onVideoStop:(NSNotification *)noti{
    NSLog(@"%s--播放器主动调用Stop功能", __func__);
}

#pragma mark  - 播放器状态首帧显示
- (void)onVideoFirstFrame:(NSNotification *)noti{
    NSLog(@"%s--播放器状态首帧显示", __func__);
}

#pragma mark  - 播放器开启循环播放
- (void)onCircleStart:(NSNotification *)noti{
    NSLog(@"%s--播放器开启循环播放", __func__);
}


- (void)fullAction:(UIButton *)sender{
    
    if (sender.isSelected) {
        [self setNeedsStatusBarAppearanceUpdate];
        sender.selected = NO;

        [self.navigationController setNavigationBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            sender.superview.transform = CGAffineTransformIdentity;//CGAffineTransformMakeRotation(-M_PI_2);
            sender.superview.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 200);
        }];
        
        
    }else{
        [self.navigationController setNavigationBarHidden:YES];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            sender.superview.transform = CGAffineTransformMakeRotation(M_PI_2);
            sender.superview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self setNeedsStatusBarAppearanceUpdate];
        });

        sender.selected = YES;

    }

}


- (BOOL)shouldAutorotate{
    return NO;
}

- (BOOL)prefersStatusBarHidden{
    return  self.fullBtn.isSelected;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
