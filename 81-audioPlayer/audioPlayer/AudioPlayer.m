//
//  AudioPlayer.m
//  audioPlayer
//
//  Created by Jayson on 2018/7/26.
//  Copyright © 2018年 Jayson. All rights reserved.
//

#import "AudioPlayer.h"

#import <AVFoundation/AVFoundation.h>

static AudioPlayer *instance = nil;

@interface AudioPlayer ()
@property (nonatomic, strong)  AVPlayer *player;
@property (nonatomic, weak) AVPlayerItem *playerItem ;
/** 加载中 */
@property (nonatomic, copy) PlayerLoading loadingBlock;
/** 加载完毕 */
@property (nonatomic, copy) PlayerCompletion completionBlock;

@property (nonatomic, copy) PlayerProgress progressBlock;

@end


@implementation AudioPlayer

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [super allocWithZone:zone];
        
    });
    
    return instance;
}


+ (instancetype)player{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

- (AVPlayer *)player{
    if (!_player) {
        NSURL *playUrl = [NSURL URLWithString:@"http://baobab.wdjcdn.com/14573563182394.mp4"];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:playUrl];
        //如果要切换视频需要调AVPlayer的replaceCurrentItemWithPlayerItem:方法
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        _player.automaticallyWaitsToMinimizeStalling = NO;
        //放置播放器的视图
    }
    return _player;
}


- (void)playWithURL:(NSString *)url
       onStartCache:(PlayerLoading)loading
         onEndCache:(PlayerCompletion)completion
         onProgress:(PlayerProgress)progress{
    
    _loadingBlock = loading;
    _completionBlock = completion;
    _progressBlock = progress;
    !(_loadingBlock)? : _loadingBlock();


//    AVAsset *avasset = [AVURLAsset assetWithURL:[NSURL URLWithString:url]];
//    AVPlayerItem *playerItem  = [[AVPlayerItem alloc] initWithAsset:avasset];
    AVPlayerItem *playerItem  = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
//    __weak typeof(avasset) weakAsset = avasset;
//    [avasset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // check the keys
//                NSError *error = nil;
//                AVKeyValueStatus keyStatus = [weakAsset statusOfValueForKey:@"tracks" error:&error];
//
//                switch (keyStatus) {
//                    case AVKeyValueStatusFailed:{
//                        NSLog(@"AVKeyValueStatusFailed---%@", error);
//                        // failed
//                        break;
//                    }
//                    case AVKeyValueStatusLoaded:{
//                        NSLog(@"AVKeyValueStatusLoaded");
//                        [self play];
//                        // success
//                        break;
//                    }case AVKeyValueStatusCancelled:{
//                        NSLog(@"AVKeyValueStatusCancelled---%@", error);
//                        // cancelled
//                        break;
//                    }
//                    default:
//                        break;
//                }
//        });
//    }];

    if (self.playerItem) {
        [self removeObserver:self.playerItem forKeyPath:@"status"];
        [self removeObserver:self.playerItem forKeyPath:@"loadedTimeRanges"];
        [self removeObserver:self.playerItem forKeyPath:@"playbackBufferEmpty"];
        [self removeObserver:self.playerItem forKeyPath:@"playbackLikelyToKeepUp"];
    }
    
    self.playerItem = playerItem;
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    
    __weak __typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //当前播放的时间
        NSTimeInterval current = CMTimeGetSeconds(time);
        //视频的总时间
        NSTimeInterval total = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        
        if (current || total) {
            !(weakSelf.progressBlock)? : weakSelf.progressBlock(current,total);
        }
        //设置滑块的当前进度
        NSLog(@"当前进度：%f",current/total);
    }];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        
        if ([keyPath isEqualToString:@"status"]) {
            switch (_playerItem.status) {
                case AVPlayerItemStatusReadyToPlay:{
                    //推荐将视频播放放在这里
                    [self play];
                    NSLog(@"AVPlayerItemStatusReadyToPlay-- 准备播放");
                }
                    break;
                case AVPlayerItemStatusUnknown:
                    NSLog(@"AVPlayerItemStatusUnknown---%@",_playerItem.error);
                    break;
                    
                case AVPlayerItemStatusFailed:
                    NSLog(@"AVPlayerItemStatusFailed---%@",_playerItem.error);
                    break;
                    
                default:
                    break;
            }
            
        }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
            NSArray *array = _playerItem.loadedTimeRanges;
            CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
            double startSeconds = CMTimeGetSeconds(timeRange.start);
            double durationSeconds = CMTimeGetSeconds(timeRange.duration);
            NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
            double totalTime = CMTimeGetSeconds(_playerItem.duration);
            
            
            NSLog(@"当前缓冲时间:%f ------- 总时间：%f",totalBuffer,totalTime);
            
        }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            
            //some code show loading
            BOOL isLoading = _playerItem.playbackBufferEmpty;
            NSLog(@"开始转菊花---%d",isLoading);
            if (isLoading) {
                !(_loadingBlock)? : _loadingBlock();
            }else{
                !(_completionBlock)? : _completionBlock();
            }

        }else if([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            //由于 AVPlayer 缓存不足就会自动暂停,所以缓存充足了需要手动播放,才能继续播放
            [_player play];
            if (_playerItem.playbackLikelyToKeepUp) {
                !(_completionBlock)? : _completionBlock();
            }else{
                !(_loadingBlock)? : _loadingBlock();
            }
            NSLog(@"停止转菊花----缓存足够，开始播放：%d",_playerItem.playbackLikelyToKeepUp);

        }
    }
}
//播放视频:
- (void)play{
    [self.player playImmediatelyAtRate:1.0];
}

//暂停视频:
- (void)pause{
    [self.player pause];
}


@end
