//
//  FSPlayer.m
//  FreeStreamerDemo
//
//  Created by FEIWU888 on 2017/10/12.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import "FSPlayer.h"
#import <FreeStreamer/FSAudioStream.h>
#import <LKDBHelper/LKDBHelper.h>

static FSAudioStream * _audioStream = nil;
@interface FSPlayer ()

@property (assign, nonatomic) NSInteger currentItemIndex;
@property (strong, nonatomic) NSTimer * progressTimer;

@property (nonatomic, assign) BOOL playDirection;



@end
@implementation FSPlayer
/**
 *  获得播放器单例
 *
 *  @return 播放器单例
 */
+ (instancetype)defaultPlayer
{
    static FSPlayer * player = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        player = [[self alloc] init];
        
        //创建FSAudioStream对象
        FSStreamConfiguration *config = [[FSStreamConfiguration alloc] init];
        config.httpConnectionBufferSize *= 2;
        config.enableTimeAndPitchConversion = YES;
        config.cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        config.cacheEnabled = YES;
        
        _audioStream = [[FSAudioStream alloc] initWithConfiguration:config];
        _audioStream.onFailure=^(FSAudioStreamError error,NSString *description){
            NSLog(@"发生错误：%@",description);
        };
        _audioStream.onCompletion=^(){
            NSLog(@"完成!");
            //[_audioStream stop];
        };
        _audioStream.onMetaDataAvailable = ^(NSDictionary *metadata) {
            
        };
        _audioStream.onStateChange=^(FSAudioStreamState state){
            NSLog(@"FSAudioStreamState:%ld",state);
            if (state==kFsAudioStreamPlaying) {
                NSLog(@"播放中");
            }else if (state==kFsAudioStreamPlaybackCompleted){
                NSLog(@"播放完成");
                player.playDirection = YES;
                [player stop];

            }else if (state==kFsAudioStreamBuffering)
            {
                NSLog(@"缓冲");
            }else if (state==kFsAudioStreamRetrievingURL)
            {
                NSLog(@"检索URL");
            }else if (state==kFsAudioStreamUnknownState)
            {
                NSLog(@"未知状态");
            }else if (state==kFsAudioStreamRetryingFailed)
            {
                NSLog(@"重新尝试失败了");
            }
            else if (state==kFsAudioStreamRetryingSucceeded)
            {
                NSLog(@"重新尝试成功了");
            }
            else if (state==kFsAudioStreamRetryingStarted)
            {
                NSLog(@"开始进行重试");
            }
            else if (state==kFsAudioStreamFailed)
            {
                NSLog(@"失败了");
            }
            else if (state==kFSAudioStreamEndOfFile)
            {
                NSLog(@"流已经收到了所有的数据文件");
                NSObject <FSPlayItemList> *model = player.lists[player.currentItemIndex];
                
                id obj =  [NSObject searchWithWhere:[NSString stringWithFormat:@"url='%@'",model.url]];
                if (![obj count]) {
                    [model saveToDB];
                }
                
            }
            else if (state==kFsAudioStreamSeeking)
            {
                NSLog(@"寻求");
            }
            else if(kFsAudioStreamPaused==state){
                NSLog(@"暂停");
            }else if(kFsAudioStreamStopped==state){
                NSLog(@"停止");
                
                if (player.playDirection == YES) {
                    
                    if (player.currentItemIndex+1 < player.lists.count) {
                        player.currentItemIndex ++;
                        
                    }else{
                        player.currentItemIndex = 0;
                    }
                }else{
                    if (player.currentItemIndex-1 >= 0) {
                        player.currentItemIndex --;
                        
                    }else{
                        player.currentItemIndex = player.lists.count - 1;
                    }
                }


                [player playFromURL:[[player.lists objectAtIndex:player.currentItemIndex] url]];

                
            }
        };
        
        

    });
    
    return player;
}


- (void)playFromURL:(NSString*)url{
    
    [_audioStream playFromURL:[NSURL URLWithString:url]];
    if (!_progressTimer) {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
}

- (void)playItemAtIndex:(NSUInteger)itemIndex itemList:(NSArray<id<FSPlayItemList>> *)lists
{
    _lists = lists;
    if (itemIndex < lists.count) {
        _currentItemIndex = itemIndex;
        [self playFromURL:[[self.lists objectAtIndex:itemIndex] url]];
    } else {
        NSLog(@"超出列表长度");
    }
}
- (void)stop{
    [_audioStream stop];
    [_progressTimer invalidate];
    _progressTimer = nil;
}

- (void)play{
     [_audioStream play];
    if (!_progressTimer) {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
}
- (void)pause{
     [_audioStream pause];
    if (!_progressTimer) {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
}

- (void)next
{
    self.playDirection = YES;
    [self stop];
}
- (void)previous
{
    self.playDirection = NO;
    [self stop];
}
- (void)updateProgress
{
    !(_updateProgressBlock)? : _updateProgressBlock(_audioStream.currentTimePlayed.playbackTimeInSeconds,_audioStream.duration.playbackTimeInSeconds);
    
    !(_updateBufferedProgressBlock)? : _updateBufferedProgressBlock(_audioStream.prebufferedByteCount * 1.0/_audioStream.contentLength);

}
- (void)setRate:(float)rate
{
    _rate = rate;
    [_audioStream setPlayRate:rate];
}

- (BOOL)isPlay
{
    return _audioStream.isPlaying;
}

- (NSArray<id<FSPlayItemList>> *)cacheLists
{
    Class c = NSClassFromString(@"PlayItem");
   return [c searchWithWhere:@"1 > 0"];
}

@end
