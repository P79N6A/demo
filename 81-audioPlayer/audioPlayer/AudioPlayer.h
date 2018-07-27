//
//  AudioPlayer.h
//  audioPlayer
//
//  Created by Jayson on 2018/7/26.
//  Copyright © 2018年 Jayson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PlayerLoading)(void);
typedef void(^PlayerCompletion)(void);
typedef void(^PlayerProgress)(NSTimeInterval current,NSTimeInterval total );

@interface AudioPlayer : NSObject
+ (instancetype)player;

- (void)playWithURL:(NSString *)url
       onStartCache:(PlayerLoading)loading
         onEndCache:(PlayerCompletion)completion
         onProgress:(PlayerProgress)progress;

@end
