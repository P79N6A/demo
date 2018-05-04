//
//  VideoImage.h
//  Video_edit
//
//  Created by xiaoke_mh on 16/4/7.
//  Copyright © 2016年 m-h. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface VideoImage : NSObject
/**
 *  @author mmmmh, 16-04-07 15:04:41
 *
 *  获取视频每一帧的图片，返回一个数组，根据视频时长，每0.5秒返回一张图片
 *
 *  @param videoURL 视频地址
 *  @param time     这个time 没有用到
 *
 *  @return 图片数组
 */
+ (NSArray *) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

@end
