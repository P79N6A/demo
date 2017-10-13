//
//  FSPlayer.h
//  FreeStreamerDemo
//
//  Created by FEIWU888 on 2017/10/12.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSPlayItemList <NSObject>
@property (nonatomic, readonly, copy) NSString *url;
@end

@interface FSPlayer : NSObject
@property (copy) void (^updateProgressBlock)(CGFloat currentPosition, CGFloat totalPosition);
@property (copy) void (^updateBufferedProgressBlock)(CGFloat currentPosition);
@property (assign, nonatomic) float rate;
@property (assign, nonatomic,readonly) BOOL isPlay;
@property (strong, nonatomic,readonly) NSArray <id<FSPlayItemList>>*lists;
@property (strong, nonatomic,readonly) NSArray <id<FSPlayItemList>>*cacheLists;


+ (instancetype)defaultPlayer;
- (void)playFromURL:(NSString*)url;
- (void)playItemAtIndex:(NSUInteger)itemIndex itemList:(NSArray <id<FSPlayItemList>>*)lists;

- (void)play;
- (void)pause;
- (void)next;
- (void)previous;

@end
