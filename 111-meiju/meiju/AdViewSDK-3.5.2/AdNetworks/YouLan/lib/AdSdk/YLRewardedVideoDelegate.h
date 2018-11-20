//
//  RewardedVideoDelegate.h
//  AdSdk
//
//  Created by youlan-sligner on 2017/9/15.
//  Copyright © 2017年 youlanad-sligner. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLRewardedVideo;

@protocol YLRewardedVideoDelegate <NSObject>
- (void)onAdSucessed:(UIView *)adView;
- (void)onAdFailed:(UIView *)adView;
- (void)browserClosed;
@end
