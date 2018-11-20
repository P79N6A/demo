//
//  AdVideoAdapterChance.m
//  AdViewDevelop
//
//  Created by maming on 16/9/20.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdVideoAdapterYouLan.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdNetworkConfig.h"
#import "adViewLog.h"
#import "AdVideoManagerImpl.h"
#import "AdVideoManagerDelegate.h"
#import "YLSdkManager.h"


@implementation AdVideoAdapterYouLan
+ (AdVideoAdNetworkType)networkType {
    return AdVideoAdNetworkTypeYouLan;
}

+ (void)load {
    if (NSClassFromString(@"YLRewardedVideo") != nil) {
        [[AdViewAdNetworkRegistry sharedVideoRegistry] registerClass:self];
    }
}

- (BOOL)loadAdVideo:(UIViewController *)controller {
    Class youLanVideoClass = NSClassFromString(@"YLRewardedVideo");
    if (nil == youLanVideoClass) {
        return NO;
    }
    self.parentVC = controller;

    CGSize videoViewSize = CGSizeMake(960, 640);
    // sdk设置
    // 此clientId由幽蓝分配
    [YLSdkManager setClientId:networkConfig.pubId];
    
    NSString *appKey = networkConfig.pubId2;//@"2049";
    
    self.video = [YLRewardedVideo initAdWithAdSpaceId:appKey adSize:videoViewSize minDuration:15 maxDuration:60 delegate:self];
    
    [self.video startRequest];

    return YES;
}

- (BOOL)showAdVideo:(UIViewController *)controller {
    // 展示广告
    [self.video showRewardedVideo];
    [adVideoManager adapter:self didGetEvent:VideoEventType_StartPlay error:nil];
    return NO;
}

- (void)stopBeingDelegate {
    AWLogInfo(@"YouLan video stopBeingDelegate!");
    self.video = nil;
    self.parentVC = nil;
}

#pragma mark - YouLan delegate
- (void)onAdSucessed:(UIView *)adView{
    [adVideoManager adapter:self didGetEvent:VideoEventType_DidLoadAd error:nil];
}

- (void)onAdFailed:(UIView *)adView{
    [adVideoManager adapter:self didGetEvent:VideoEventType_FailLoadAd error:nil];
}

- (void)browserClosed{
    [adVideoManager adapter:self didGetEvent:VideoEventType_Close_PlayEnd error:nil];
}


@end
