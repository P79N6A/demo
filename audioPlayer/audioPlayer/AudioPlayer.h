//
//  AudioPlayer.h
//  audioPlayer
//
//  Created by Jayson on 2018/7/26.
//  Copyright © 2018年 Jayson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioPlayer : NSObject
+ (instancetype)player;
- (void)playWithURL:(NSString *)url;
@end
