/*
 adview.
 */

#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlAdapterInMobi.h"
#import "AdInstlManagerImpl.h"
#import "AdViewCommonDef.h"
#import "AdViewExtraManager.h"

//static BOOL isLoad;
static IMInterstitial *imadInstl;
@interface AdInstlAdapterInMobi ()
@end

@implementation AdInstlAdapterInMobi

+ (AdInstlAdNetworkType)networkType {
	return AdInstlAdNetworkTypeInMobi;
}

+ (void)load {
	if(NSClassFromString(@"IMInterstitial") != nil) {
		[[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
	}
}

- (BOOL)loadAdInstl:(UIViewController*)controller
{
	Class IMAdInterstitialClass = NSClassFromString(@"IMInterstitial");
    Class InMobiClass = NSClassFromString(@"IMSdk");
	if(nil == IMAdInterstitialClass) return NO;
    if (nil == InMobiClass) return NO;
    
    NSLog(@" Chance version :%@",[InMobiClass getVersion]);
    
    NSString *appID = self.networkConfig.pubId;
    NSString *placementID = self.networkConfig.pubId2;
    //4028cbff3a6eaf57013a9b2847a004bd
    //2589a26b446c415c83211d8d89be199e 配合placementID
    if (imadInstl == nil)
    {
        [InMobiClass initWithAccountID:appID];
        imadInstl = [[IMInterstitial alloc] initWithPlacementId:[placementID longLongValue]];//1443029784945
//        isLoad = YES;
    }
    
    imadInstl.delegate = self;
  
    [InMobiClass setLogLevel:kIMSDKLogLevelNone];
    //添加gps
    BOOL gpsON = NO;
    if ([self.adInstlDelegate respondsToSelector:@selector(adInstlOpenGps)]) {
        gpsON = [self.adInstlDelegate adInstlOpenGps];
        
    }
    if (gpsON) {
        CLLocation *loc =[[AdViewExtraManager sharedManager] getLocation];
        [InMobiClass setLocation:loc];
    }
    
    //添加必传字段
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"c_adview" forKey:@"tp"];
    [dict setObject:ADVIEW_VERSION_STR forKey:@"tp-ver"];
    if (imadInstl) {
        [imadInstl setExtras:[NSDictionary dictionaryWithDictionary:dict]];
    }
    
    self.adInstlController = (UIViewController*)imadInstl;

    [self.adInstlManager adapter:self requestString:@"req"];
    
    [imadInstl load];
    	
	return YES;
}

- (BOOL)showAdInstl:(UIViewController*)controller
{
    if (nil == self.adInstlController) {
        AWLogInfo(@"No inmobi instl exist!");
        return NO;
    }
    IMInterstitial *imadInstl = (IMInterstitial*)self.adInstlController;

    if (imadInstl.isReady == NO) {
        AWLogInfo(@"Inmobi instl not ready!");
        return NO;
    }
    
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
    
     [imadInstl showFromViewController:controller];
    
    return YES;
}

#pragma mark delegate

//- (BOOL)judgeInstlController:(IMInterstitial*)instl
//{
//    if ((IMInterstitial*)self.adInstlController != instl) {//stale instl.
//        AWLogInfo(@"stale instl controller!");
//        return NO;
//    }
//    return YES;
//}

/**
 * Notifies the delegate that the interstitial has finished loading
 */
-(void)interstitialDidFinishLoading:(IMInterstitial*)interstitial
{
//    if (![self judgeInstlController:ad]) return;
   
    [self.adInstlManager adapter:self requestString:@"suc"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
    
}

/**
 * Notifies the delegate that the interstitial has failed to load with some error.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToLoadWithError:(IMRequestStatus*)error
{
//    if (![self judgeInstlController:ad]) return;
    AWLogInfo(@"error is %@",error);
    [self.adInstlManager adapter:self requestString:@"fail"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:error];
}

/**
 * Notifies the delegate that the interstitial would be presented.
 */
-(void)interstitialWillPresent:(IMInterstitial*)interstitial
{
//    if (![self judgeInstlController:ad]) return;
    [self.adInstlManager adapter:self requestString:@"show"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
}

/**
 * Notifies the delegate that the interstitial will be dismissed.
 */
-(void)interstitialWillDismiss:(IMInterstitial*)interstitial
{
//    if (![self judgeInstlController:ad]) return;
    
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

/**
 * Notifies the delegate that the user will leave application context.
 */
-(void)userWillLeaveApplicationFromInterstitial:(IMInterstitial*)interstitial
{
    [self.adInstlManager adapter:self requestString:@"click"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--Inmobi--stopBeingDelegate");    
    self.adInstlController = nil;
}

@end
