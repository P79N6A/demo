//
//  AdInstlAdapterAdMob.m
//  AdInstlSDK_iOS
//
//  Created by adview on 13-10-16.
//
//

#import "AdInstlAdapterAdMob.h"
#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"
#import <GoogleMobileAds/GADRequest.h>

@implementation AdInstlAdapterAdMob
@synthesize AdmobInstl;
@synthesize parent;

+ (AdInstlAdNetworkType)networkType {
    return AdInstlAdNetworkTypeAdMob;
}

+ (void)load {
    if(NSClassFromString(@"GADInterstitial") != nil) {
		[[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
	}
}
- (BOOL)loadAdInstl:(UIViewController *)controller {
    Class GoolgAdmobInstlClass = NSClassFromString(@"GADInterstitial");
    Class GoolgAdmobRequestClass = NSClassFromString(@"GADRequest");
    
    if (GoolgAdmobInstlClass == nil) return NO;
    if (GoolgAdmobRequestClass == nil) return NO;
    if (controller == nil) return NO;
    self.parent = controller;
    
    NSString * appId = self.networkConfig.pubId;

    AdmobInstl = [[GoolgAdmobInstlClass alloc] init];
    [AdmobInstl performSelector:@selector(setAdUnitID:) withObject:appId];
    
    AdmobInstl.delegate = self;
    [self.adInstlManager adapter:self requestString:@"req"];
    
    GADRequest *request = [GoolgAdmobRequestClass request];

    request.testDevices = nil;
    [AdmobInstl loadRequest:request];
    return YES;
    
}

//- (NSArray *)testDevices
//{
//    if ([adInstlDelegate respondsToSelector:@selector(adInstlTestMode)]
//        && [adInstlDelegate adInstlTestMode]) {
//        return [NSArray arrayWithObjects:
//                GAD_SIMULATOR_ID,                             // Simulator
//                nil];
//    }
//    return nil;
//}

- (BOOL)showAdInstl:(UIViewController *)controller {
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
    
    [AdmobInstl presentFromRootViewController:self.parent];
    
    return YES;
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
    [self.adInstlManager adapter:self requestString:@"suc"];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:error];
    [self.adInstlManager adapter:self requestString:@"fail"];
    AWLogInfo(@"error is %@",error);
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
    [self.adInstlManager adapter:self requestString:@"suc"];
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad{ }

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
     [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad{ }

- (void)stopBeingDelegate {
    AWLogInfo(@"admob is delloced");
    
    AdmobInstl.delegate = nil;
    AdmobInstl = nil;
    
    self.parent = nil;
}

@end
