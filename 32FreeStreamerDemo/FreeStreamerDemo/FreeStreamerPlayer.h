
//

#import <Foundation/Foundation.h>
#import "FSAudioStream.h"



@interface FreeStreamerPlayer : FSAudioStream

/**
 *  是否为播放状态
 */
@property (assign, nonatomic) BOOL isPlay;
/**
 *  是否循环播放
 */
@property (assign, nonatomic) BOOL isLoop;
/**
 *  播放文件地址(队列)数组
 */
@property (strong, nonatomic) NSMutableArray <NSURL *>* audioArray;
/**
 *  播放速率
 */
@property (assign, nonatomic) float rate;


/**
 *  更新播放进度
 *
 *  currentPosition 当前位置
 *  endPosition     结束位置（总时长）
 */
@property (copy) void (^updateProgressBlock)(FSStreamPosition currentPosition, FSStreamPosition endPosition);

/**
 *  获得播放器单例
 *
 *  @return 获得播放器单例
 */
+ (instancetype)defaultPlayer;

/**
 *  播放文件队列中的指定文件
 *
 *  @param itemIndex 指定的文件的索引
 */
- (void)playItemAtIndex:(NSUInteger)itemIndex;



@end
