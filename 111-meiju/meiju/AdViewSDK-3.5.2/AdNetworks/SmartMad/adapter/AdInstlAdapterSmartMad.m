/*
 adview.
 */

#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlAdapterSmartMad.h"
#import "AdInstlManagerImpl.h"

@interface AdInstlAdapterSmartMad ()
@end

@implementation AdInstlAdapterSmartMad

@synthesize rootController = _rootController;


+ (AdInstlAdNetworkType)networkType {
	return AdInstlAdNetworkTypeSmartMad;
}

+ (void)load {
	if(NSClassFromString(@"SMAdInterstitial") != nil) {
		[[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
	}
}

- (BOOL)loadAdInstl:(UIViewController*)controller
{
    Class SMAdManagerClass = NSClassFromString(@"SMAdManager");
	Class SMAdInterstitialClass = NSClassFromString(@"SMAdInterstitial");
	if(nil == SMAdInterstitialClass) return NO;
    
    NSString *appID = self.networkConfig.pubId;
    
    [SMAdManagerClass setChannelId:@"adview"];
    [SMAdManagerClass setApplicationId:appID];
    [SMAdManagerClass setDebugMode:[self isTestMode]];
    
    SMAdInterstitial *smadInstl = [[SMAdInterstitialClass alloc] initWithAdSpaceId:self.networkConfig.pubId2];
    
    smadInstl.adSize = AD_INTERSTITIAL_MEASURE_AUTO;
    
    if (nil == smadInstl) return NO;
    
    smadInstl.delegate = self;
    
    self.adInstlController = (UIViewController*)smadInstl;
    [self.adInstlManager adapter:self requestString:@"req"];
    [smadInstl requestAd];
    
   	return YES;
}

- (BOOL)showAdInstl:(UIViewController*)controller
{
    BOOL ret = NO;
    if (nil == self.adInstlController) {
        AWLogInfo(@"No smartmad instl exist!");
        return NO;
    }
    SMAdInterstitial *smadInstl = (SMAdInterstitial*)self.adInstlController;
   
    if (AdInstlLoadType_DidLoadAd != self.loadType) {
        AWLogInfo(@"Smartmad instl not ready!");
        return NO;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    BOOL isDismissing = ([controller isBeingDismissed] || [controller isMovingFromParentViewController]);
    if (nil == controller || ![controller isViewLoaded] || isDismissing) {
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
    
    @try {
        [smadInstl presentFromRootViewController:controller];
        ret = YES;
    }
    @catch (NSException *exception) {
        AWLogInfo(@"showAdInstl exception:%@", [exception name]);
    }
    @finally {
    }
    
    return ret;
}

#pragma mark delegate
- (BOOL)judgeInstlController:(SMAdInterstitial*)instl
{
    if ((SMAdInterstitial*)self.adInstlController != instl) {//stale instl.
        AWLogInfo(@"stale instl controller!");
        return NO;
    }
    return YES;
}

- (void)adInterstitialDidReceiveAd:(SMAdInterstitial*)ad
{
    if (![self judgeInstlController:ad]) return;
    [self.adInstlManager adapter:self requestString:@"suc"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}

- (void)adInterstitial:(SMAdInterstitial*)adview didFailToReceiveAdWithError:(SMAdEventCode*)errorCode
{
    if (![self judgeInstlController:adview]) return;
    AWLogInfo(@"SMAdInterstitialDidFail");
    [self.adInstlManager adapter:self requestString:@"fail"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:errorCode];
}

- (void)adInterstitialWillPresentScreen:(SMAdInterstitial*)ad
{
    if (![self judgeInstlController:ad]) return;
    [self.adInstlManager adapter:self requestString:@"show"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
}

- (void)adInterstitialDidDismissScreen:(SMAdInterstitial*)ad
{
    if (![self judgeInstlController:ad]) return;
    
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--SmartMad --stopBeingDelegate");
    
    SMAdInterstitial *smadInstl = (SMAdInterstitial*)self.adInstlController;
    smadInstl.delegate = nil;
    self.adInstlController = nil;
    self.rootController = nil;
}

@end
