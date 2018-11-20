//
//  AdSplashAdapterBaidu.m
//  AdViewDevelop
//
//  Created by maming on 14-11-14.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdSplashAdapterBaidu.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "adViewAdNetworkRegistry.h"
#import "AdSpreadScreenManagerImpl.h"
#import "adViewLog.h"

@implementation AdSplashAdapterBaidu

+ (AdSpreadScreenAdNetworkType)networkType {
    return AdSpreadScreenAdNetworkTypeBaidu;
}

+ (void)load {
    if (NSClassFromString(@"BaiduMobAdSplash") != nil) {
        [[AdViewAdNetworkRegistry sharedSpreadScreenRegistry] registerClass:self];
    }
}

- (BOOL)loadAdSpreadScreen:(UIViewController *)controller {
    Class BaiduMobSplashClass = NSClassFromString(@"BaiduMobAdSplash");
    
    if (BaiduMobSplashClass == nil) return NO;
    if (controller == nil) return NO;
    
    self.splash = [[BaiduMobSplashClass alloc] init];
    self.splash.delegate = self;
    self.splash.AdUnitTag = self.networkConfig.pubId2;
    self.splash.canSplashClick = YES;
    
    [self.splash loadAndDisplayUsingKeyWindow:[self.adSpreadScreenManager.delegate adSpreadScreenWindow]];
    [self.adSpreadScreenManager adapter:self requestString:@"req"];
    
    return YES;
}

#pragma mark - Baidu splash delegate

- (NSString *)publisherId
{
    NSString *appId = self.networkConfig.pubId;
    return  appId;//@"ba120092";
}


-(BOOL) enableLocation
{
    //启用location会有一次alert提示
    return [self isOpenGps];
}

// 渠道id
- (NSString*)channelId {
    return @"e498eab7";
}

/**
 *  广告展示成功
 */
- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash
{
    [self.adSpreadScreenManager adapter:self requestString:@"suc"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidLoadAd error:nil];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_WillPresentAd error:nil];
}

/**
 *  广告展示失败
 */
- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason) reason
{
    NSError *errorMessage = nil;
    if (reason == BaiduMobFailReason_NOAD)
        errorMessage = [NSError errorWithDomain:@"没有推广返回" code:0 userInfo:nil];
    else
        errorMessage = [NSError errorWithDomain:@"网络或其他原因" code:0 userInfo:nil];

    [self.adSpreadScreenManager adapter:self requestString:@"fail"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_FailLoadAd error:errorMessage];
}

/**
 *  广告展示结束
 */
- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash
{
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidDismissModal error:nil];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"baidu splash stop being delegate");
    self.splash.delegate = nil;
    self.splash = nil;
}

@end
