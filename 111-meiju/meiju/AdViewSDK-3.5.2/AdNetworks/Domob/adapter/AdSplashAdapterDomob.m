//
//  AdSplashAdapterBaidu.m
//  AdViewDevelop
//
//  Created by maming on 14-11-14.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdSplashAdapterDomob.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "adViewAdNetworkRegistry.h"
#import "AdSpreadScreenManagerImpl.h"
#import "adViewLog.h"
#import "adViewAdNetworkAdapter+Helpers.h"

@implementation AdSplashAdapterDomob 

+ (AdSpreadScreenAdNetworkType)networkType {
    return AdSpreadScreenAdNetworkTypeDomob;
}

+ (void)load {
    if (NSClassFromString(@"DMSplashAdController") != nil) {
        [[AdViewAdNetworkRegistry sharedSpreadScreenRegistry] registerClass:self];
    }
}

- (BOOL)loadAdSpreadScreen:(UIViewController *)controller {
    Class DomobSplashAdClass = NSClassFromString(@"DMSplashAdController");
    
    if (DomobSplashAdClass == nil) return NO;
    if (controller == nil) return NO;
    
    BOOL isPad  = [AdViewAdNetworkAdapter helperIsIpad];
    self.splashAd = [[DMRTSplashAdController alloc] initWithPublisherId:self.networkConfig.pubId
                                                         placementId:self.networkConfig.pubId2
                                                                   size:isPad?DOMOB_AD_SIZE_768x576:DOMOB_AD_SIZE_320x400
                                                              offset:0
                                                              window:[UIApplication sharedApplication].keyWindow
                                                          background:[UIColor whiteColor]
                                                           animation:YES];
                                                //56OJyM1ouMGoULfJaL     16TLwebvAchkAY6iOVhpfHPs
    
    self.splashAd.delegate = self;
    [self.splashAd present];

    [self.adSpreadScreenManager adapter:self requestString:@"req"];
    
    return YES;
}

#pragma mark -  splash delegate
- (void)dmSplashAdSuccessToLoadAd:(DMSplashAdController *)dmSplashAd{
    [self.adSpreadScreenManager adapter:self requestString:@"suc"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidLoadAd error:nil];
}
// Sent when an ad request fail to loaded an ad
- (void)dmSplashAdFailToLoadAd:(DMSplashAdController *)dmSplashAd withError:(NSError *)err{
    [self.adSpreadScreenManager adapter:self requestString:@"fail"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_FailLoadAd error:err];
}

// Sent just before presenting an splash ad view
- (void)dmSplashAdWillPresentScreen:(DMSplashAdController *)dmSplashAd{
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_WillPresentAd error:nil];
}
// Sent just after dismissing an splash ad view
- (void)dmSplashAdDidDismissScreen:(DMSplashAdController *)dmSplashAd{
     [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidDismissAd error:nil];
}
- (void)stopBeingDelegate {
    AWLogInfo(@"gdt splash stop being delegate");
    self.splashAd.delegate = nil;
    self.splashAd = nil;
}

@end
