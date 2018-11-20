/*
 adview.
 */
#import "AdInstlAdapterChartboost.h"

#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"

@interface AdInstlAdapterChartboost ()
@end

@implementation AdInstlAdapterChartboost

+ (AdInstlAdNetworkType)networkType {
	return AdInstlAdNetworkTypeChartboost;
}

+ (void)load {
	if(NSClassFromString(@"Chartboost") != nil) {
		[[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
	}
}

//appID:4f21c409cd1cb2fb7000001b
//appSecret:92e2de2fd7070327bdeb54c15a5295309c6fcd2d
- (BOOL)loadAdInstl:(UIViewController*)controller
{
	Class ChartboostClass = NSClassFromString(@"Chartboost");
	if(nil == ChartboostClass) return NO;
    
    NSString *appID = self.networkConfig.pubId;
    NSString *appSecret = self.networkConfig.pubId2;
    
    [ChartboostClass startWithAppId:appID appSignature:appSecret delegate:self];
    
    [self.adInstlManager adapter:self requestString:@"req"];

    [Chartboost showInterstitial:CBLocationHomeScreen];

	return YES;
}

- (BOOL)showAdInstl:(UIViewController*)controller
{
//    Class ChartboostClass = NSClassFromString(@"Chartboost");
//    if(nil == ChartboostClass) return NO;
//    Chartboost *boost = [ChartboostClass sharedChartboost];
//    
//    if (bLoadedCache || [boost hasCachedInterstitial:CBLocationHomeScreen]) {
//        [boost showInterstitial:CBLocationHomeScreen];
//        return YES;
//    }
//    [ChartboostClass showInterstitial:CBLocationHomeScreen];
    
    return NO;
}

#pragma mark delegate

// Called before requesting an interestitial from the back-end
- (BOOL)shouldRequestInterstitial:(NSString *)location
{
    AWLogInfo(@"shouldRequestInterstitial");
    return YES;
}

// Called when an interstitial has been received and cached.
- (void)didCacheInterstitial:(NSString *)location
{
    AWLogInfo(@"didCacheInterstitial");
    
    bLoadedCache = YES;
    if (!didShow) {//如果展示过了不在从新去展示
        [self.adInstlManager adapter:self requestString:@"suc"];
        [adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
    }
}

// Called when an interstitial has failed to come back from the server
- (void)didFailToLoadInterstitial:(CBLocation)location  withError:(CBLoadError)error
{
    AWLogInfo(@"didFailToLoadInterstitial");
    NSError *errorMessage = [NSError errorWithDomain:location code:0 userInfo:nil];
    [self.adInstlManager adapter:self requestString:@"fail"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:errorMessage];
}

- (BOOL)shouldDisplayInterstitial:(NSString *)location
{
    AWLogInfo(@"shouldDisplayInterstitial");
    didShow = YES;
    [self.adInstlManager adapter:self requestString:@"show"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
    return YES;
}

- (void)didDismissInterstitial:(NSString *)location
{
    didShow = YES;
    AWLogInfo(@"didDismissInterstitial");
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

// Same as above, but only called when dismissed for a click
- (void)didClickInterstitial:(NSString *)location
{
    AWLogInfo(@"didClickInterstitial");
    
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
}

- (void)stopBeingDelegate {
//    AWLogInfo(@"Charboost stopBeingDelegate, controller retain:%d", [self.adInstlController retainCount]);
//    Class ChartboostClass = NSClassFromString(@"Chartboost");
//    Chartboost *boost = [ChartboostClass sharedChartboost];
//    if (self == boost.delegate)
//        boost.delegate = nil;
}

@end
