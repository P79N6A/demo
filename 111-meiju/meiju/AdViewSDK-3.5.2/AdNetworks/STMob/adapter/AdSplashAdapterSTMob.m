//
//  AdSplashAdapterBaidu.m
//  AdViewDevelop
//
//  Created by maming on 14-11-14.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdSplashAdapterSTMob.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "adViewAdNetworkRegistry.h"
#import "AdSpreadScreenManagerImpl.h"
#import "adViewLog.h"

@implementation AdSplashAdapterSTMob

+ (AdSpreadScreenAdNetworkType)networkType {
    return AdSpreadScreenAdNetworkTypeSTMob;
}

+ (void)load {
    if (NSClassFromString(@"STMSplashAd") != nil) {
        [[AdViewAdNetworkRegistry sharedSpreadScreenRegistry] registerClass:self];
    }
}

- (BOOL)loadAdSpreadScreen:(UIViewController *)controller {
    Class SplashAdClass = NSClassFromString(@"STMSplashAd");
    
    if (SplashAdClass == nil) return NO;

    NSString *key = self.networkConfig.pubId;//@"2_36_34";//
    NSArray *keys = [key componentsSeparatedByString:@"_"];
    if (!keys || [keys count] != 3) {
        return NO;
    }
    NSString * key1 = [keys objectAtIndex:0];
    NSString * key2 = [keys objectAtIndex:1];
    NSString * key3 = [keys objectAtIndex:2];
    
    NSString * appKey = self.networkConfig.pubId2;//@"Ac7Kd3lJ^KQX9Hjkn_Z(UO9jqViFh*q1";//
    
    self.splashAd = [STMSplashAd splashAdWithPublisherID:key1
                                                   appID:key2
                                             placementID:key3
                                                  appKey:appKey];
    self.splashAd.delegate = self;
    
    UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
    
    UIColor *backgroundColor = [UIColor whiteColor];
    if ([self.adSpreadScreenManager.delegate adSpreadScreenBackgroundColor]) {
        backgroundColor = [self.adSpreadScreenManager.delegate adSpreadScreenBackgroundColor];
    }
    [self.splashAd presentInWindow:fK backgroundColor:backgroundColor];
    
    [self.adSpreadScreenManager adapter:self requestString:@"req"];
    
    return YES;
}

#pragma mark -  splash delegate
/**
 *  The splash ad presented.
 *
 *  @param splash The `STMSplashAd` instance.
 */
- (void)splashDidPresent:(STMSplashAd *)splash{
    [self.adSpreadScreenManager adapter:self requestString:@"suc"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidLoadAd error:nil];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_WillPresentAd error:nil];
}

/**
 *  The splash ad fail to present.
 *
 *  @param splash The `STMSplashAd` instance.
 */
- (void)splash:(STMSplashAd *)splash failPresentWithError:(NSError *)error{
    [self.adSpreadScreenManager adapter:self requestString:@"fail"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_FailLoadAd error:error];
}

/**
 *  The splash ad tapped.
 *
 *  @param splash The `STMSplashAd` instance.
 */
- (void)splashDidTap:(STMSplashAd *)splash{
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidClickAd error:nil];
}

/**
 *  The splash ad closed.
 *
 *  @param splash The `STMSplashAd` instance.
 */
- (void)splashDidDismiss:(STMSplashAd *)splash{
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidDismissAd error:nil];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"舜飞 splash stop being delegate");
    self.splashAd.delegate = nil;
    self.splashAd = nil;
}

@end
