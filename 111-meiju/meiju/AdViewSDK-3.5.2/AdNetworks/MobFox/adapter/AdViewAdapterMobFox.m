//
//  AdViewAdapterAdSmar.m
//  AdViewDevelop
//
//  Created by zhoutong on 16/8/11.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdViewAdapterMobFox.h"
#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"



@implementation AdViewAdapterMobFox

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeMobFox;
}

+ (void)load {
    if (NSClassFromString(@"MobFoxAd") != nil) {
        [[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
    }
}

- (void)getAd {
    
    Class BannerAdClass = NSClassFromString (@"MobFoxAd");
    if (nil == BannerAdClass) {
        AWLogInfo(@"no MobFoxAd lib, can not create.");
        [adViewView adapter:self didFailAd:nil];
        return;
    }
    
    [self updateSizeParameter];
    
    NSString *appID = self.networkConfig.pubId;//@"fe96717d9875b9da4339ea5367eff1ec";

    self.mobfoxAd = [[MobFoxAd alloc] init:appID withFrame:self.rSizeAd];
    self.mobfoxAd.delegate = self;
//    self.mobfoxAd.auto_pilot = false;
    self.mobfoxAd.refresh = [NSNumber numberWithInt:0];
    [self.mobfoxAd loadAd];
    
    self.adNetworkView = self.mobfoxAd;
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--MobFoxAd stopBeingDelegate--");
    self.mobfoxAd.delegate = nil;
    self.adNetworkView = nil;
}

- (void)dealloc {
    
}
- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    //    int flagArr[] = {GDTMOB_AD_SUGGEST_SIZE_320x50,GDTMOB_AD_SUGGEST_SIZE_728x90,
    //        GDTMOB_AD_SUGGEST_SIZE_320x50,GDTMOB_AD_SUGGEST_SIZE_320x50,
    //        GDTMOB_AD_SUGGEST_SIZE_468x60,GDTMOB_AD_SUGGEST_SIZE_728x90};
    CGSize sizeArr[] = {CGSizeMake(320, 50),CGSizeMake(728, 90),
        CGSizeMake(320, 50),CGSizeMake(320, 50),
        CGSizeMake(320, 50),CGSizeMake(728, 90)};
    
    [self setSizeParameter:nil size:sizeArr];
}

#pragma mark  delegate
- (void)MobFoxAdDidLoad:(MobFoxAd *)banner{
    AWLogInfo(@"MobFoxAd receiveAd");
    [self.adViewView adapter:self didReceiveAdView:self.adNetworkView];
}

- (void)MobFoxAdDidFailToReceiveAdWithError:(NSError *)error{
    AWLogInfo(@"MobFoxAd fail, code:%d",error);
    [self.adViewView adapter:self didFailAd:error];
}

- (void)MobFoxAdClosed{
    AWLogInfo(@"MobFoxAd did dismissScreen");
}

- (void)MobFoxAdClicked{
    AWLogInfo(@"MobFoxAd click action");
}

- (void)MobFoxAdFinished{}

- (void)MobFoxDelegateCustomEvents:(NSArray*)events withAdDict:(NSDictionary *)adDict{}

@end
