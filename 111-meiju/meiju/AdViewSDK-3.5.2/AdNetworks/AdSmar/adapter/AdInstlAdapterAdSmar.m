//
//  AdInstlAdapterAdSmar.m
//  AdViewDevelop
//
//  Created by zhoutong on 16/8/11.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdInstlAdapterAdSmar.h"
#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"

@implementation AdInstlAdapterAdSmar

+ (AdInstlAdNetworkType)networkType {
    return AdInstlAdNetworkTypeAdSmar;
}

+ (void)load {
    if(NSClassFromString(@"InterstitialAd") != nil) {
        [[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
    }
}

- (BOOL)loadAdInstl:(UIViewController*)controller
{
    Class AdInterstitialClass = NSClassFromString(@"InterstitialAd");
    if(nil == AdInterstitialClass) return NO;
    
    InterstitialAd *interstitialAd = [InterstitialAd sharedInstance];
    interstitialAd.interstitialAdDelegate = self;
    interstitialAd.currentViewController = controller;
    
    NSString *appID = self.networkConfig.pubId;//@"5714887afc897826";//
    NSString *placementID = self.networkConfig.pubId2;//@"6CE92A393FC6E3FFD0E27B93E0F05CD6";//
    
    [interstitialAd loadAdWithAdUnitId:placementID AndAppId:appID];

    [self.adInstlManager adapter:self requestString:@"req"];

    return YES;
}

- (BOOL)showAdInstl:(UIViewController*)controller
{

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0)
    if (nil == controller || ![controller isViewLoaded] || [controller isBeingDismissed]) {
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
#else
    if (nil == controller || ![controller isViewLoaded]) {
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
#endif
    
    [[InterstitialAd sharedInstance] showAd];
    
    return YES;
}

#pragma mark InterstitialAd DelegateMethod
- (void)onAdSuccess
{
    [self.adInstlManager adapter:self requestString:@"suc"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}

- (void)onAdFailed:(AdError *)errorCode
{
    AWLogInfo(@"error is %@",errorCode.errorDescription);
    [self.adInstlManager adapter:self requestString:@"fail"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:[NSError errorWithDomain:errorCode.errorDescription code:errorCode.errorCode userInfo:nil]];
}

- (void) onAdClose
{
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

- (void)onAdClick
{
    [self.adInstlManager adapter:self requestString:@"click"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--AdSmar--stopBeingDelegate");
    [InterstitialAd sharedInstance].interstitialAdDelegate = nil;
    [InterstitialAd sharedInstance].currentViewController = nil;
}

@end
