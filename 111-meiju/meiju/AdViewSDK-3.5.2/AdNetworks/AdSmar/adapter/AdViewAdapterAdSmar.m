//
//  AdViewAdapterAdSmar.m
//  AdViewDevelop
//
//  Created by zhoutong on 16/8/11.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdViewAdapterAdSmar.h"
#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"



@implementation AdViewAdapterAdSmar

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeAdSmar;
}

+ (void)load {
    if (NSClassFromString(@"BannerAd") != nil) {
        [[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
    }
}

- (void)getAd {
    Class BannerAdClass = NSClassFromString (@"BannerAd");
    
    if (nil == BannerAdClass) {
        AWLogInfo(@"no adsmar lib, can not create.");
        [adViewView adapter:self didFailAd:nil];
        return;
    }
    
     [self updateSizeParameter];
    
    _adView = [[BannerAd alloc]initWithOrigin:CGPointZero];
    _adView.bannerAdDelegate = self;
    _adView.currentViewController = [self.adViewDelegate viewControllerForPresentingModalView];
    
    if (nil == [_adView getAdview]) {
        [adViewView adapter:self didFailAd:nil];
        return;
    }
    self.adNetworkView = [_adView getAdview];
    NSString *appId = self.networkConfig.pubId;
    NSString *adUnitId = self.networkConfig.pubId2;
    
    [_adView loadAdWithAdUnitId:adUnitId AppId:appId IsAutoRequest:NO]; // 开始加载广告@"818260D7ACAE742A194F0BBE9EDBCF93"@"5714887afc897826"
    
    //    [self setupDefaultDummyHackTimer];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--adsmar stopBeingDelegate--");
    self.adView.bannerAdDelegate = nil;
    self.adView.currentViewController = nil;
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
        CGSizeMake(320, 50),CGSizeMake(300, 250),
        CGSizeMake(460, 100),CGSizeMake(728, 90)};
    
    [self setSizeParameter:nil size:sizeArr];
}

#pragma mark  delegate

- (void) onAdSuccess{
    AWLogInfo(@"AdSmar receiveAd");
    [self.adViewView adapter:self didReceiveAdView:self.adNetworkView];
}

- (void) onAdFailed:(AdError *)errorCode {
    AWLogInfo(@"AdSmar fail, code:%d",errorCode.errorDescription);
    [self.adViewView adapter:self didFailAd:[NSError errorWithDomain:@"err code" code:[errorCode errorCode] userInfo:nil]];
}

- (void) onAdClose {
    AWLogInfo(@"AdSmar did dismissScreen");
}

- (void) onAdClick {
    AWLogInfo(@"AdSmar click action");
    //    [adViewView adapter:self shouldReport:self.adNetworkView DisplayOrClick:NO];
}

@end
