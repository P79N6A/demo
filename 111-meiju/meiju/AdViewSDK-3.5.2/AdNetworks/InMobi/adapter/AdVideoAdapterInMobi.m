//
//  AdVideoAdapterInMobi.m
//  AdViewDevelop
//
//  Created by maming on 16/9/19.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdVideoAdapterInMobi.h"
#import "adViewAdNetworkRegistry.h"
#import "adViewAdNetworkConfig.h"
#import "adViewLog.h"
#import "AdVideoManagerImpl.h"
#import "AdVideoManagerDelegate.h"

@implementation AdVideoAdapterInMobi
@synthesize imadVideo;

+ (AdVideoAdNetworkType)networkType {
    return AdVideoAdNetworkTypeInmobi;
}

+ (void)load {
    if (NSClassFromString(@"IMInterstitial") != nil) {
        [[AdViewAdNetworkRegistry sharedVideoRegistry] registerClass:self];
    }
}

- (BOOL)loadAdVideo:(UIViewController *)controller {
    Class IMAdInterstitialClass = NSClassFromString(@"IMInterstitial");
    Class InMobiClass = NSClassFromString(@"IMSdk");
    if(nil == IMAdInterstitialClass) return NO;
    if (nil == InMobiClass) return NO;
    
    NSString *appID = self.networkConfig.pubId;
    NSString *placementID = self.networkConfig.pubId2;
    //4028cbff3a6eaf57013a9b2847a004bd
    //2589a26b446c415c83211d8d89be199e 配合placementID
    if (self.imadVideo == nil)
    {
        [IMSdk initWithAccountID:appID];
        self.imadVideo = [[IMInterstitial alloc] initWithPlacementId:[placementID longLongValue]];//1443029784945
        //        isLoad = YES;
    }
    
    self.imadVideo.delegate = self;
    
    [IMSdk setLogLevel:kIMSDKLogLevelNone];

    [imadVideo load];
    
    return YES;
}

- (BOOL)showAdVideo:(UIViewController *)controller {
    if (self.imadVideo == nil) {
        AWLogInfo(@"No inmobi video exist!");
        return NO;
    }
    
    if (self.imadVideo.isReady == NO) {
        AWLogInfo(@"Inmobi video not ready!");
        return NO;
    }
    
    if (nil == controller) {
        [self.adVideoManager adapter:self didGetEvent:VideoEventType_FailLoadAd error:nil];
        return NO;
    }
    
    [self.imadVideo showFromViewController:controller];
    return YES;
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--Inmobi video-- stopBeingDelegate");
    self.imadVideo = nil;
}

#pragma mark - delegate

/**
 * Notifies the delegate that the interstitial has finished loading
 */
-(void)interstitialDidFinishLoading:(IMInterstitial*)interstitial
{
    [adVideoManager adapter:self didGetEvent:VideoEventType_DidLoadAd error:nil];
    
}

/**
 * Notifies the delegate that the interstitial has failed to load with some error.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToLoadWithError:(IMRequestStatus*)error
{
    //    if (![self judgeInstlController:ad]) return;
    AWLogInfo(@"error is %@",error);
    [adVideoManager adapter:self didGetEvent:VideoEventType_FailLoadAd error:error];
}

/**
 * Notifies the delegate that the interstitial would be presented.
 */
-(void)interstitialWillPresent:(IMInterstitial*)interstitial
{
//    [adVideoManager adapter:self didGetEvent:VideoEventType_WillPresentAd error:nil];
}

/**
 * Notifies the delegate that the interstitial will be dismissed.
 */
-(void)interstitialWillDismiss:(IMInterstitial*)interstitial
{
//    [adVideoManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

/**
 * Notifies the delegate that the user will leave application context.
 */
-(void)userWillLeaveApplicationFromInterstitial:(IMInterstitial*)interstitial
{
    [adVideoManager adapter:self didGetEvent:VideoEventType_DidClickAd error:nil];
}

@end
