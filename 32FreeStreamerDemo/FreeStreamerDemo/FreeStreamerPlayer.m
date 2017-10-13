//
//  FreeStreamerPlayer.m
//  DownloadList
//
//  Created by puslar on 16/9/18.
//  Copyright © 2016年 puslar. All rights reserved.
//

#import "FreeStreamerPlayer.h"

@interface FreeStreamerPlayer ()

@property (assign, nonatomic) NSUInteger currentItemIndex;
@property (strong, nonatomic) NSTimer * progressTimer;

@end

@implementation FreeStreamerPlayer

/**
 *  获得播放器单例
 *
 *  @return 播放器单例
 */
+ (instancetype)defaultPlayer
{
    static FreeStreamerPlayer * player = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //创建FSAudioStream对象
        FSStreamConfiguration *config = [[FSStreamConfiguration alloc] init];
        config.httpConnectionBufferSize *= 2;
        config.enableTimeAndPitchConversion = YES;
        player = [[super alloc] initWithConfiguration:config];
        player.onFailure=^(FSAudioStreamError error,NSString *description){
            NSLog(@"发生错误：%@",description);
        };
        player.onCompletion=^(){
            NSLog(@"播放完成!");
            [player stop];
        };
        player.onStateChange=^(FSAudioStreamState state){
            if (state == kFsAudioStreamPlaying) {
                [player setPlayRate:player.rate];
            }
            if (state == kFsAudioStreamStopped) {
                if (player.isLoop) {
                    [player playItemAtIndex:player.currentItemIndex];
                }
                if (player.currentItemIndex+1 < player.audioArray.count) {
                    [player playItemAtIndex:player.currentItemIndex+1];
                }
                if (player.isLoop && player.currentItemIndex+1 >= player.audioArray.count) {
                    [player playItemAtIndex:0];
                }
            }
        };
        [player setVolume:0.5];
        player.progressTimer = nil;
        player.isLoop = NO;
        player.rate = 1;
    });
    
    return player;
}

/**
 *  播放
 */
- (void)play
{
    [super play];
    if (!_progressTimer) {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
    _isPlay = YES;
}

/**
 *  播放指定地址的文件
 *
 *  @param url 文件地址
 */
- (void)playFromURL:(NSURL *)url
{
    [super playFromURL:url];
    if (![self.audioArray containsObject:url]) {
        [self.audioArray addObject:url];
    }
    _currentItemIndex = [self.audioArray indexOfObject:url];
    if (!_progressTimer) {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
    _isPlay = YES;
}

/**
 *  从指定位置开始播放文件
 *
 *  @param offset 起始偏移量
 */
- (void)playFromOffset:(FSSeekByteOffset)offset
{
    [super playFromOffset:offset];
    if (!_progressTimer) {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
    _isPlay = YES;
}

/**
 *  播放文件队列中的指定文件
 *
 *  @param itemIndex 指定的文件的索引
 */
- (void)playItemAtIndex:(NSUInteger)itemIndex
{
    if (itemIndex < self.audioArray.count) {
        _currentItemIndex = itemIndex;
        [self playFromURL:[self.audioArray objectAtIndex:itemIndex]];
    } else {
        NSLog(@"超出列表长度");
    }
}

/**
 *  暂停
 */
- (void)pause
{
    if (_isPlay) {
        [super pause];
        if (!_progressTimer) {
            _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        }
    }
}

/**
 *  停止
 */
- (void)stop
{
    [super stop];
    [_progressTimer invalidate];
    _progressTimer = nil;
    _isPlay = NO;
}

/**
 *  设置播放速率
 *
 *  @param rate 播放速率（0.5~2）
 */
- (void)setRate:(float)rate
{
    _rate = rate;
    [self setPlayRate:rate];
}

/**
 *  更新播放进度
 */
- (void)updateProgress
{
    !(_updateProgressBlock)? : _updateProgressBlock(self.currentTimePlayed,self.duration);
}

/**
 *  播放的文件队列
 *
 *  @return 播放的文件队列
 */
- (NSMutableArray *)audioArray
{
    if (!_audioArray) {
        _audioArray = [[NSMutableArray alloc] init];
    }
    return _audioArray;
}

@end
