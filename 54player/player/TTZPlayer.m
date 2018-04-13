//
//  TTZPlayer.m
//  player
//
//  Created by Jay on 2018/3/26.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZPlayer.h"
#import <AliyunPlayerSDK/AlivcMediaPlayer.h>

static TTZPlayer *instance = nil;

@interface TTZPlayer()
@property (nonatomic, strong) AliVcMediaPlayer *mediaPlayer;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation TTZPlayer
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

#pragma mark  开始播放
- (void)playWithModel:(id<TTZPlayerModel>)model{
    
    self.model = model;
    //prepareToPlay:此方法传入的参数是NSURL类型.
    [self.mediaPlayer prepareToPlay:[NSURL URLWithString:model.url]];
    //开始播放
    [self play];
}

- (void)play
{
    [self.mediaPlayer play];
}

- (void)stop{
    [self.mediaPlayer stop];
}

- (void)pause
{
    [self.mediaPlayer pause];
}


- (BOOL)isPlaying
{
    return self.mediaPlayer.isPlaying;
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
        self.contentView = [[UIView alloc] init];

        [_mediaPlayer create:self.contentView];
        //设置播放类型，0为点播、1为直播，默认使用自动
        _mediaPlayer.mediaType = MediaType_AUTO;
        //设置超时时间，单位为毫秒
        _mediaPlayer.timeout = 25000;
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
    !(_playerLoading)? : _playerLoading();

}

#pragma mark  - 播放器结束缓冲视频
- (void)OnEndCache:(NSNotification *)noti{
    NSLog(@"%s--播放器结束缓冲视频", __func__);
    !(_playerCompletion)? : _playerCompletion();

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


@end
