//
//  AdInstlAdapterYJF.m
//  AdInstlSDK_iOS
//
//  Created by Ma ming on 13-3-13.
//
//

#import "AdInstlAdapterYJF.h"
#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"

@interface AdInstlAdapterYJF ()
@end

@implementation AdInstlAdapterYJF

+ (AdInstlAdNetworkType)networkType{
    return AdInstlAdNetworkTypeYiJiFen;
}

+ (void)load {
	if(NSClassFromString(@"EADInterstitialAd") != nil) {
		[[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
	}
}

- (BOOL)loadAdInstl:(UIViewController*)controller
{
    Class HMAdInterstitialClass = NSClassFromString(@"EADInterstitialAd");
    if (nil == HMAdInterstitialClass) return NO;
    
    controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    NSString *appID = self.networkConfig.pubId;
    NSString *userID = self.networkConfig.pubId2;
    NSString *appKey = self.networkConfig.pubId3;
    
    //开发者
    
    [EADConfig startWithAppId:appID appKey:appKey devId:userID];
    [EADConfig configCoopInfo:@"coopinfo"];
    
    self.interstitialAd = [[EADInterstitialAd alloc] init];
    self.interstitialAd.delegate = self;
    [self.interstitialAd startLoading];
	return YES;
}

- (BOOL)showAdInstl:(UIViewController *)controller{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
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
    self.parent = controller;
    
    if (self.interstitialAd.isLoaded) {
        [self.interstitialAd presentFromViewController:self.parent];
    }
    
    return YES;
}

- (void)dealloc {
    AWLogInfo(@"AdInstlAdapterYJF dealloc");
}

#pragma mark delegate


- (void)interstitialAdDidLoad:(EADInterstitialAd *)interstitialAd
{
    [self.adInstlManager adapter:self requestString:@"suc"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}

- (void)interstitialAd:(EADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    [self.adInstlManager adapter:self requestString:@"fail"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:error];
    AWLogInfo(@"YJFdidFailWithError is %@",error);
}
- (void)interstitialAdDidDisappear:(EADInterstitialAd *)interstitialAd
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

- (void)stopBeingDelegate {
    self.interstitialAd = nil;
    self.interstitialAd.delegate = nil;
    self.parent = nil;
}
@end
