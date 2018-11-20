//
//  AdVideoAdapterChance.m
//  AdViewDevelop
//
//  Created by maming on 16/9/20.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdVideoAdapterAdColony.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdNetworkConfig.h"
#import "adViewLog.h"
#import "AdVideoManagerImpl.h"
#import "AdVideoManagerDelegate.h"

@implementation AdVideoAdapterAdColony
+ (AdVideoAdNetworkType)networkType {
    return AdVideoAdNetworkTypeAdColony;
}

+ (void)load {
    if (NSClassFromString(@"AdColony") != nil) {
        [[AdViewAdNetworkRegistry sharedVideoRegistry] registerClass:self];
    }
}

- (BOOL)loadAdVideo:(UIViewController *)controller {
    Class unityVideoClass = NSClassFromString(@"AdColony");
    if (nil == unityVideoClass) {
        return NO;
    }
    self.parentVC = controller;
    
    NSString *appKey = networkConfig.pubId;//@"appbdee68ae27024084bb334a";
    NSString *placementID = networkConfig.pubId2;//@"vzf8fb4670a60e4a139d01b5";
    
    __weak typeof(self) weakSelf = self;
    [AdColony configureWithAppID:appKey zoneIDs:@[placementID] options:nil completion:^(NSArray<AdColonyZone *> * zones) {
        
        [AdColony requestInterstitialInZone:placementID options:nil success:^(AdColonyInterstitial * _Nonnull ad) {
            
            _adColonyVideo = ad;
            AWLogInfo(@"AdColony video VideoEventType_DidLoadAd!");
            [adVideoManager adapter:weakSelf didGetEvent:VideoEventType_DidLoadAd error:nil];
            
            ad.close = ^{
                _adColonyVideo = nil;
                AWLogInfo(@"AdColony video VideoEventType_Close_PlayEnd!");
                [adVideoManager adapter:weakSelf didGetEvent:VideoEventType_Close_PlayEnd error:nil];
            };
            //过期
            ad.expire = ^{
                _adColonyVideo = nil;
                AWLogInfo(@"AdColony video expire!");
                [adVideoManager adapter:weakSelf didGetEvent:VideoEventType_FailLoadAd error:nil];
            };
        } failure:^(AdColonyAdRequestError * _Nonnull error) {
            AWLogInfo(@"AdColony video VideoEventType_FailLoadAd!");
            [adVideoManager adapter:weakSelf didGetEvent:VideoEventType_FailLoadAd error:error];
        }];
        
        
    }];

    return YES;
}

- (BOOL)showAdVideo:(UIViewController *)controller {
    if (!_adColonyVideo.expired) {
        AWLogInfo(@"AdColony video show!");
        return [_adColonyVideo showWithPresentingViewController:self.parentVC];
    }
    return NO;
}

- (void)stopBeingDelegate {
    
    AWLogInfo(@"AdColony video stopBeingDelegate!");
    self.adColonyVideo = nil;
    self.parentVC = nil;
}

@end
