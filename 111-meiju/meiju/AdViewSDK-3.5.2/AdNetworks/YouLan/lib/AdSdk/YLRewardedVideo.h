//
//  RewardedVideo.h
//  AdSdk
//
//  Created by youlan-sligner on 2017/9/15.
//  Copyright © 2017年 youlanad-sligner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YLRewardedVideoDelegate.h"

@interface YLRewardedVideo : UIView
+ (YLRewardedVideo *)initAdWithAdSpaceId:(NSString *)theAdSpaceId adSize:(CGSize)adSize minDuration:(int)minDuration maxDuration:(int)maxDuration delegate:(id<YLRewardedVideoDelegate>)theDelegate;
- (void)startRequest;
- (void)showRewardedVideo;
@end
