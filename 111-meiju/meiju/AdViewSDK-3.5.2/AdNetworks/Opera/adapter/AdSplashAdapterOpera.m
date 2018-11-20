//
//  AdSplashAdapterBaidu.m
//  AdViewDevelop
//
//  Created by maming on 14-11-14.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdSplashAdapterOpera.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "adViewAdNetworkRegistry.h"
#import "AdSpreadScreenManagerImpl.h"
#import "adViewLog.h"
#import "OperaAdManager.h"

@implementation AdSplashAdapterOpera

+ (AdSpreadScreenAdNetworkType)networkType {
    return AdSpreadScreenAdNetworkTypeOpera;
}

+ (void)load {
    if (NSClassFromString(@"SplashAdView") != nil) {
        [[AdViewAdNetworkRegistry sharedSpreadScreenRegistry] registerClass:self];
    }
}

- (BOOL)loadAdSpreadScreen:(UIViewController *)controller {
    Class SplashAdClass = NSClassFromString(@"SplashAdView");
    
    if (SplashAdClass == nil) return NO;
    if (controller == nil) return NO;
    [[OperaAdManager getInstance] setAdvertiseInfo:@"adview"];
    
    NSString * appKey = self.networkConfig.pubId;//@"1702075038";//
    _splash = [[SplashAdView alloc]initWithADID:appKey];
    _splash.delegate = self;
//    _splash.adImpressTime = 3;
    [_splash loadAdAndShowInWindow:[[UIApplication sharedApplication] keyWindow] withBottomView:nil];
    [self.adSpreadScreenManager adapter:self requestString:@"req"];
    
    return YES;
}

#pragma mark - OperaSplashAdDelegate
/**
 * @brief adSplash 请求数据成功
 * @param adSplash
 */
-(void)operaSplashAdRequestSuccessed:(SplashAdView *)adSplash{
    [self.adSpreadScreenManager adapter:self requestString:@"suc"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidLoadAd error:nil];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_WillPresentAd error:nil];
}
/**
 * @brief adSplash 请求数据失败
 * @param adSplash
 */
-(void)operaSplashAdRequestFailure:(SplashAdView *)adSplash error:(NSString *)error{
    [self.adSpreadScreenManager adapter:self requestString:@"fail"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_FailLoadAd error:[NSError errorWithDomain:error code:0 userInfo:nil]];
}
/**
 *  @brief adSplash被点击
 *  @param adSplash
 */
- (void)operaSplashAdClick:(SplashAdView*)adSplash{
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidClickAd error:nil];
}
/**
 *  @brief adSplash请求成功并展示广告
 *  @param adSplash
 */
- (void)operaSplashAdSuccessToShowAd:(SplashAdView*)adSplash{
    [self.adSpreadScreenManager adapter:self requestString:@"show"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidShowAd error:nil];
}
/**
 *  @brief adSplash 展示广告失败
 *  @param adSplash
 */
- (void)operaSplashAdFailureToShowAd:(SplashAdView*)adSplash{
    [self.adSpreadScreenManager adapter:self requestString:@"fail"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_FailLoadAd error:nil];
}

/**
 *  @brief AdSplash被关闭
 *  @param adSplash
 */
- (void)operaSplashAdClose:(SplashAdView*)adSplash{
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidDismissAd error:nil];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"OperaSplashAd stop being delegate");
    self.splash.delegate = nil;
    self.splash = nil;
}

@end
