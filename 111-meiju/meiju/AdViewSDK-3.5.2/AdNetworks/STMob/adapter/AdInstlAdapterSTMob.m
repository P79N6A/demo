//
//  AdInstlAdapterGDTMob.m
//  AdInstlSDK_iOS
//
//  Created by ZhongyangYu on 14-9-28.
//
//

#import "AdInstlAdapterSTMob.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewExtraManager.h"
#import "AdInstlManagerImpl.h"

@implementation AdInstlAdapterSTMob

+ (AdInstlAdNetworkType)networkType
{
    return AdInstlAdNetworkTypeSTMob;
}

+ (void)load
{
    if(NSClassFromString(@"STMInterstitialAdController") != nil)
    {
        [[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
    }
}

- (BOOL)loadAdInstl:(UIViewController *)controller
{
    Class instlClass = NSClassFromString(@"STMInterstitialAdController");
    if (nil == instlClass) return NO;

    [self.adInstlManager adapter:self requestString:@"req"];

    self.parent = controller;
    NSString *key = self.networkConfig.pubId;//@"2_36_36";//
    NSArray *keys = [key componentsSeparatedByString:@"_"];
    if (!keys || [keys count] != 3) {
        return NO;
    }
    NSString * key1 = [keys objectAtIndex:0];
    NSString * key2 = [keys objectAtIndex:1];
    NSString * key3 = [keys objectAtIndex:2];

    NSString * appKey = self.networkConfig.pubId2;//@"Ac7Kd3lJ^KQX9Hjkn_Z(UO9jqViFh*q1";//
    
    self.interstitialAdController = [STMInterstitialAdController interstitialAdControllerWithPublisherID:key1 appID:key2 placementID:key3 appKey:appKey];
    self.interstitialAdController.delegate = self;

    //预加载广告
    [self.interstitialAdController loadAd];
    
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
    if (self.interstitialAdController.isLoaded)
    {
        [self.interstitialAdController presentFromViewController:self.parent];
        return YES;
    }
    return NO;
}

#pragma mark -  delegate
/**
 *  The interstitial ad loaded.
 *
 *  @param interstitial The `STMInterstitialAdController` instance.
 */
- (void)interstitialDidLoad:(STMInterstitialAdController *)interstitial{
    [self.adInstlManager adapter:self requestString:@"suc"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}

/**
 *  The interstitial ad load failed.
 *
 *  @param interstitial The `STMInterstitialAdController` instance.
 */
- (void)interstitial:(STMInterstitialAdController *)interstitial didLoadFailWithError:(NSError *)error{
    AWLogInfo(@"STMob fail %@",[error description]);
    [self.adInstlManager adapter:self requestString:@"fail"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:error];

}

/**
 *  The interstitial ad presented.
 *
 *  @param interstitial The `STMInterstitialAdController` instance.
 */
- (void)interstitialDidPresent:(STMInterstitialAdController *)interstitial{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
}

/**
 *  The interstitial ad tapped.
 *
 *  @param interstitial The `STMInterstitialAdController` instance.
 */
- (void)interstitialDidTap:(STMInterstitialAdController *)interstitial{
    [self.adInstlManager adapter:self requestString:@"click"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
}

/**
 *  The interstitial ad closed.
 *
 *  @param interstitial The `STMInterstitialAdController` instance.
 */
- (void)interstitialDidDismiss:(STMInterstitialAdController *)interstitial{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

- (void)stopBeingDelegate
{
    self.interstitialAdController.delegate = nil;
    self.interstitialAdController = nil;
}

@end
