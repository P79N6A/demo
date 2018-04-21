//
//  TTZPlayer.m
//  player
//
//  Created by Jay on 2018/3/26.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZPlayer.h"
#import <AliyunPlayerSDK/AlivcMediaPlayer.h>
#import <MediaPlayer/MediaPlayer.h>
#import <SDImageCache.h>

static TTZPlayer *instance = nil;

@interface TTZPlayer()
@property (nonatomic, strong) AliVcMediaPlayer *mediaPlayer;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation TTZPlayer
+ (instancetype)defaultPlayer{
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
    
    [self stop];
    self.model = model;
    //prepareToPlay:此方法传入的参数是NSURL类型.
    [self.mediaPlayer prepareToPlay:[NSURL URLWithString:model.url]];
    //开始播放
    [self play];
    
    NSMutableDictionary *infos = [[NSMutableDictionary alloc] init];
    //设置歌曲题目
    [infos setObject:model.name forKey:MPMediaItemPropertyTitle];
    //设置歌手名
    [infos setObject:model.main?model.main : @"未知" forKey:MPMediaItemPropertyArtist];
    //设置专辑名
    [infos setObject:model.des?model.des : @"暂无介绍" forKey:MPMediaItemPropertyAlbumTitle];
    //设置显示的图片
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:model.icon];

    UIImage *newImage = cachedImage?cachedImage:[UIImage imageNamed:@"logo"];
    [infos setObject:[[MPMediaItemArtwork alloc] initWithImage:newImage]
             forKey:MPMediaItemPropertyArtwork];
    
    //设置歌曲时长
    //[dict setObject:[NSNumber numberWithDouble:300] forKey:MPMediaItemPropertyPlaybackDuration];
    //设置已经播放时长
    //[dict setObject:[NSNumber numberWithDouble:150] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    //更新字典
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:infos];
}

// 在需要处理远程控制事件的具体控制器或其它类中实现
- (void)remoteControlEventHandler{
    MPRemoteCommandCenter *rcc = [MPRemoteCommandCenter sharedCommandCenter];
    
    //    MPSkipIntervalCommand *skipBackwardIntervalCommand = [rcc skipBackwardCommand];
    //    [skipBackwardIntervalCommand setEnabled:YES];
    //    [skipBackwardIntervalCommand addTarget:self action:@selector(skipBackwardEvent:)];
    //    skipBackwardIntervalCommand.preferredIntervals = @[@(42)];  // 设置快进时间
    //
    //    MPSkipIntervalCommand *skipForwardIntervalCommand = [rcc skipForwardCommand];
    //    skipForwardIntervalCommand.preferredIntervals = @[@(42)];  // 倒退时间 最大 99
    //    [skipForwardIntervalCommand setEnabled:YES];
    //    [skipForwardIntervalCommand addTarget:self action:@selector(skipForwardEvent:)];
    
    
    
    [rcc.pauseCommand setEnabled:YES];
    [rcc.pauseCommand addTarget:self action:@selector(playOrPauseEvent:)];
    //
    [rcc.playCommand setEnabled:YES];
    [rcc.playCommand addTarget:self action:@selector(playOrPauseEvent:)];
    
    
    //    MPRemoteCommand *nextCommand = [rcc nextTrackCommand];
    //    [nextCommand setEnabled:YES];
    //    [nextCommand addTarget:self action:@selector(nextCommandEvent:)];
    //
    //    MPRemoteCommand *previousCommand = [rcc previousTrackCommand];
    //    [previousCommand setEnabled:YES];
    //    [previousCommand addTarget:self action:@selector(previousCommandEvent:)];
    
    
    // 启用耳机的播放/暂停命令 (耳机上的播放按钮触发的命令)
    rcc.togglePlayPauseCommand.enabled = YES;
    // 为耳机的按钮操作添加相关的响应事件
    [rcc.togglePlayPauseCommand addTarget:self action:@selector(playOrPauseEvent:)];

}

- (void)playOrPauseEvent:(MPRemoteCommand *)command
{
    if (self.isPlaying)
    {
        [self pause];
    }else
    {
        [self play];
    }
}

//- (void)nextCommandEvent:(MPRemoteCommand *)command
//{
//    NSLog(@"%@",@"下一曲");
//}
//- (void)previousCommandEvent:(MPRemoteCommand *)command
//{
//    NSLog(@"%@",@"上一曲");
//}

//-(void)skipBackwardEvent: (MPSkipIntervalCommandEvent *)skipEvent
//{
//    NSLog(@"Skip backward by %f", skipEvent.interval);
//}
//-(void)skipForwardEvent: (MPSkipIntervalCommandEvent *)skipEvent
//{
//    NSLog(@"Skip forward by %f", skipEvent.interval);
//}

- (void)play
{
    _isPlaying = YES;
    [self.mediaPlayer play];
}

- (void)stop{
    _isPlaying = NO;
    [self.mediaPlayer stop];
}

- (void)pause
{
    _isPlaying = NO;
    [self.mediaPlayer pause];
}


- (BOOL)isPlaying
{
    return _isPlaying && self.mediaPlayer.isPlaying;
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
        [self remoteControlEventHandler];
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
    !(_playerLoading)? : _playerLoading();
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
    !(_playerCompletion)? : _playerCompletion();
}

#pragma mark  - 播放器开启循环播放
- (void)onCircleStart:(NSNotification *)noti{
    NSLog(@"%s--播放器开启循环播放", __func__);
}


@end
