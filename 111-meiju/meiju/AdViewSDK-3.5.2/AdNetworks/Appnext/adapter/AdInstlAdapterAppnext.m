//
//  AdInstlAdapterGDTMob.m
//  AdInstlSDK_iOS
//
//  Created by ZhongyangYu on 14-9-28.
//
//

#import "AdInstlAdapterAppnext.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewExtraManager.h"
#import "AdInstlManagerImpl.h"

@implementation AdInstlAdapterAppnext


+ (AdInstlAdNetworkType)networkType
{
    return AdInstlAdNetworkTypeAppnext;
}

+ (void)load
{
    if(NSClassFromString(@"AppnextInterstitialAd") != nil)
    {
        [[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
    }
}

- (BOOL)loadAdInstl:(UIViewController *)controller
{
    Class instlClass = NSClassFromString(@"AppnextInterstitialAd");
    if (nil == instlClass) return NO;

    [self.adInstlManager adapter:self requestString:@"req"];

    NSString *appID = self.networkConfig.pubId;
    
    AppnextInterstitialAdConfiguration *interstitialConfig = [[AppnextInterstitialAdConfiguration alloc] init];
    interstitialConfig.autoPlay = YES;
    interstitialConfig.creativeType = ANCreativeTypeManaged;
    self.interstitial = [[AppnextInterstitialAd alloc] initWithConfig:interstitialConfig placementID:appID];//@"891a67bd-73e8-4adb-8209-df041110e1f1"
    self.interstitial.delegate = self;
    
    [self.interstitial loadAd];
    
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
    
        [self.interstitial showAd];
    return YES;
}

#pragma mark - AppnextInterstitialAd delegate
- (void) adLoaded:(AppnextAd *)ad{
    [self.adInstlManager adapter:self requestString:@"suc"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}
- (void) adError:(AppnextAd *)ad error:(NSString *)error{
    AWLogInfo(@"Appnext fail %@",[error description]);
    [self.adInstlManager adapter:self requestString:@"fail"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:[NSError errorWithDomain:error code:1 userInfo:nil]];
}
- (void) adOpened:(AppnextAd *)ad{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
}
- (void) adClosed:(AppnextAd *)ad{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}
- (void) adClicked:(AppnextAd *)ad{
    [self.adInstlManager adapter:self requestString:@"click"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
}
- (void) adUserWillLeaveApplication:(AppnextAd *)ad{
}

- (void)stopBeingDelegate
{
    self.interstitial.delegate = nil;
    self.interstitial = nil;
}

@end
