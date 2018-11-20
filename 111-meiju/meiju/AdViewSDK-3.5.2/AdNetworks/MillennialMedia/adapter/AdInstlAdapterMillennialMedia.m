//
//  AdInstlAdapterGDTMob.m
//  AdInstlSDK_iOS
//
//  Created by ZhongyangYu on 14-9-28.
//
//

#import "AdInstlAdapterMillennialMedia.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewExtraManager.h"
#import "AdInstlManagerImpl.h"

@implementation AdInstlAdapterMillennialMedia

+ (AdInstlAdNetworkType)networkType
{
    return AdInstlAdNetworkTypeMillennialMedia;
}

+ (void)load
{
    if(NSClassFromString(@"MMInterstitialAd") != nil)
    {
        [[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
    }
}

- (BOOL)loadAdInstl:(UIViewController *)controller
{
    Class instlClass = NSClassFromString(@"MMInterstitialAd");
    if (nil == instlClass) return NO;

    self.parent = controller;
    
    [self.adInstlManager adapter:self requestString:@"req"];

    NSString * appKey = self.networkConfig.pubId;//@"203890";
    [MMSDK setLogLevel:MMLogLevelDebug];
    [[MMSDK sharedInstance] initializeWithSettings:nil withUserSettings:nil];
    
    self.interstitialAd = [[MMInterstitialAd alloc] initWithPlacementId:appKey];
    self.interstitialAd.delegate = self;
    self.interstitialAd.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.interstitialAd load:nil];

    return YES;
}

- (BOOL)showAdInstl:(UIViewController *)controller
{
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
    if (self.interstitialAd.ready)
    {
        [self.interstitialAd showFromViewController:self.parent];
        return YES;
    }
    return NO;
}

#pragma mark -  delegate
- (void)interstitialAdLoadDidSucceed:(MMInterstitialAd *)ad {
    [self.adInstlManager adapter:self requestString:@"suc"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}

- (void)interstitialAd:(MMInterstitialAd *)ad loadDidFailWithError:(NSError *)error {
    AWLogInfo(@" fail %@",[error description]);
    [self.adInstlManager adapter:self requestString:@"fail"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:error];
}

- (void)interstitialAdWillDisplay:(MMInterstitialAd *)ad {
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
}

- (void)interstitialAdDidDisplay:(MMInterstitialAd *)ad {
    [self.adInstlManager adapter:self requestString:@"show"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidShowAd error:nil];
}

- (void)interstitialAdWillDismiss:(MMInterstitialAd *)ad {
    NSLog(@"Interstitial will dismiss.");
}

- (void)interstitialAdDidDismiss:(MMInterstitialAd *)ad {
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

- (void)interstitialAdTapped:(MMInterstitialAd *)ad {
    [self.adInstlManager adapter:self requestString:@"click"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
}

- (void)interstitialAdWillLeaveApplication:(MMInterstitialAd *)ad {
    
}

- (void)stopBeingDelegate
{
    self.interstitialAd.delegate = nil;
    self.interstitialAd = nil;
}

@end
