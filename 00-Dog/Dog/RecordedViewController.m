//
//  RecordedViewController.m
//  Dog
//
//  Created by czljcb on 2018/4/6.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "RecordedViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface RecordedViewController ()<AVAudioRecorderDelegate>
{
    
    NSTimer *_timer; //定时器
    NSInteger countDown;  //倒计时
    
    
}

#define kRecordAudioFile @"myRecord.caf"



@property (nonatomic,strong)AVAudioRecorder * audioRecorder;//音频录音机

@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIImageView *recordLoadingImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation RecordedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bar.barStyle = UIBarStyleBlack;
    [self.bgView addSubview:bar];

}



-(void)refreshLabelText{
    
    countDown --;
    
}

/**
 *  添加定时器
 */
- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(refreshLabelText) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
    
}

- (IBAction)recordAction:(UIButton *)sender {
    NSLog(@"开始录音");
    self.tipLabel.text = @"开始录音中...";
    countDown = 1.0;
    [self addTimer];
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];
    }
    
    self.recordLoadingImageView.animationImages = @[
                                                    [UIImage imageNamed:@"dogChat_mic_1"],
                                                    [UIImage imageNamed:@"dogChat_mic_2"],
                                                    [UIImage imageNamed:@"dogChat_mic_3"],
                                                    [UIImage imageNamed:@"dogChat_mic_4"],
                                                    ];
    self.recordLoadingImageView.animationDuration = 1.0;//设置动画时间
    self.recordLoadingImageView.animationRepeatCount = 0;//设置动画次数 0 表示无限
    [self.recordLoadingImageView startAnimating];
}
- (IBAction)stopRecord:(id)sender {
    NSLog(@"播放录音");
    [self.audioRecorder stop];
    [self removeTimer];
    [self.recordLoadingImageView stopAnimating];

    if (countDown>0) {
        NSLog(@"录音过短");
        self.tipLabel.text = @"按下录音,松开翻译";
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"录音时间过短" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    self.isPlaying = YES;
    self.tipLabel.text = @"翻译中...";

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tipLabel.text = @"播放中...";

        NSString *voice = [NSString stringWithFormat:@"cat_voice%d",arc4random()%160];
        NSString *str = [[NSBundle mainBundle] pathForResource:voice ofType:@".caf"];
        NSURL *url = [NSURL fileURLWithPath:str];
        
        [self play:url];
        
        
    });
    
}


/////


#pragma mark - 私有方法

-(NSURL *)getSavePath{

    NSString * urlStr = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES ) lastObject];
    
    urlStr = [urlStr stringByAppendingPathComponent:kRecordAudioFile];
    
    NSLog(@"file:path:%@",urlStr);
    
    NSURL * url = [NSURL fileURLWithPath:urlStr];
    
    return url;
    
}


-(NSDictionary *)getAudioSettion

{
    
    NSMutableDictionary * dicM = [NSMutableDictionary dictionary];
    
    //设置录音格式
    
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    
    //设置录音采样率，8000是电话采样率，对于一般的录音已经够了
    
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    
    //设置通道，这里采用单声道
    
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    
    //每个采样点位数，分为8，16，24，32
    
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    
    //是否使用浮点数采样
    
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    
    //。。。。是他设置
    
    return dicM;
    
}

-(AVAudioRecorder * )audioRecorder{
    
    if (!_audioRecorder) {
        
        //创建录音文件保存路径
        
        NSURL * url =[self getSavePath];
        
        //创建录音格式设置
        
        NSDictionary * setting = [self getAudioSettion];
        
        //创建录音机
        
        NSError * error = nil;
        
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        
        _audioRecorder.delegate = self;
        
        _audioRecorder.meteringEnabled = YES;//如果要控制声波则必须设置为YES
        
        if(error)
            
        {
            
            NSLog(@"创建录音机对象发生错误，错误信息是：%@",error.localizedDescription);
            
            return nil;
            
        }
        
        
        
    }
    
    return _audioRecorder;
    
    
    
}



///
- (void)play:(NSURL *)url{
    [self.player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:url]];
    [[NSNotificationCenter defaultCenter] addObserver:self           selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification   object:self.player.currentItem];
    [self.player play];
}
- (void)stop {
    [self.player pause];
}

- (void)playbackFinished:(NSNotification *)noti
{
    NSLog(@"%@", [NSThread currentThread]);
    NSLog(@"MP3文件读完了");
}


- (AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer playerWithURL:[NSURL URLWithString:@""]];
    }
    return _player;
}


@end
