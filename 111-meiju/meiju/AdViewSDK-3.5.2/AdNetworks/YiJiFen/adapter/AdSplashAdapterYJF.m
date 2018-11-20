//
//  AdSplashAdapterBaidu.m
//  AdViewDevelop
//
//  Created by maming on 14-11-14.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdSplashAdapterYJF.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "adViewAdNetworkRegistry.h"
#import "AdSpreadScreenManagerImpl.h"
#import "adViewLog.h"

@implementation AdSplashAdapterYJF

+ (AdSpreadScreenAdNetworkType)networkType {
    return AdSpreadScreenAdNetworkTypeYiJiFen;
}

+ (void)load {
    if (NSClassFromString(@"EADSplashAd") != nil) {
        [[AdViewAdNetworkRegistry sharedSpreadScreenRegistry] registerClass:self];
    }
}

- (BOOL)loadAdSpreadScreen:(UIViewController *)controller {
    Class SplashAdClass = NSClassFromString(@"EADSplashAd");
    
    if (SplashAdClass == nil) return NO;
    if (controller == nil) return NO;
    
    controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    NSString *appID = self.networkConfig.pubId;//@"200";//
    NSString *userID =  self.networkConfig.pubId2;//@"EMPAN4GE2U3YCD866XI30RDH3S0XBIP8NB";
    NSString *appKey =  self.networkConfig.pubId3;//@"27";

    [EADConfig startWithAppId:appID appKey:appKey devId:userID];
    [EADConfig configCoopInfo:@"coopinfo"];
    
    self.splashAd = [[EADSplashAd alloc] init];
    self.splashAd.delegate = self;
    [self.splashAd startLoading];
    
    self.parent = controller;
    
    [self.adSpreadScreenManager adapter:self requestString:@"req"];
    
    return YES;
}

#pragma mark - yjf splash delegate
/*!
 * @method splashAdDidLoad:
 *
 * @discussion
 * 广告数据获取成功
 *
 */
- (void)splashAdDidLoad:(EADSplashAd *)splashAd{
    [self.adSpreadScreenManager adapter:self requestString:@"suc"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidLoadAd error:nil];
    if (self.splashAd.loaded) {
        [self.splashAd presentFromViewController:self.parent];
    }
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_WillPresentAd error:nil];
}

/*!
 * @method splashAd:didFailWithError:
 *
 * @discussion
 * 广告数据获取失败
 *
 */
- (void)splashAd:(EADSplashAd *)splashAd didFailWithError:(NSError *)error{
    [self.adSpreadScreenManager adapter:self requestString:@"fail"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_FailLoadAd error:error];
}

/*!
 * @method splashAdDidDisappear:
 *
 * @discussion
 * 开屏广告关闭
 *
 */
- (void)splashAdDidDisappear:(EADSplashAd *)splashAd{
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidDismissAd error:nil];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"yjf splash stop being delegate");
    self.splashAd.delegate = nil;
    self.splashAd = nil;
}

@end
