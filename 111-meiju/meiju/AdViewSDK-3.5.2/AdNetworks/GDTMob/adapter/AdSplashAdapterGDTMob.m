//
//  AdSplashAdapterBaidu.m
//  AdViewDevelop
//
//  Created by maming on 14-11-14.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdSplashAdapterGDTMob.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "adViewAdNetworkRegistry.h"
#import "AdSpreadScreenManagerImpl.h"
#import "adViewLog.h"

@implementation AdSplashAdapterGDTMob

+ (AdSpreadScreenAdNetworkType)networkType {
    return AdSpreadScreenAdNetworkTypeGDTMob;
}

+ (void)load {
    if (NSClassFromString(@"GDTSplashAd") != nil) {
        [[AdViewAdNetworkRegistry sharedSpreadScreenRegistry] registerClass:self];
    }
}

- (BOOL)loadAdSpreadScreen:(UIViewController *)controller {
    Class GDTSplashAdClass = NSClassFromString(@"GDTSplashAd");
    
    if (GDTSplashAdClass == nil) return NO;
    if (controller == nil) return NO;
    
    self.splash = [[GDTSplashAd alloc] initWithAppkey:self.networkConfig.pubId placementId:self.networkConfig.pubId2];//self.networkConfig.pubId
    self.splash.delegate = self;//设置代理
    //针对不同设备尺寸设置不同的默认图片，拉取广告等待时间会展示该默认图片。
    /**
    if ([[UIScreen mainScreen] bounds].size.height >= 568.0f) {
        self.splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage-568h"]];
    } else {
        self.splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage"]];
    }
    */
    UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
    //设置开屏拉取时长限制，若超时则不再展示广告
    _splash.fetchDelay = 3;
    //拉取并展示
    [_splash loadAdAndShowInWindow:fK];
    
    [self.adSpreadScreenManager adapter:self requestString:@"req"];
    
    return YES;
}

#pragma mark - gdt splash delegate
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    [self.adSpreadScreenManager adapter:self requestString:@"suc"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidLoadAd error:nil];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_WillPresentAd error:nil];
}

-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    [self.adSpreadScreenManager adapter:self requestString:@"fail"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_FailLoadAd error:error];
}

-(void)splashAdClicked:(GDTSplashAd *)splashAd{}

-(void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd{}

-(void)splashAdClosed:(GDTSplashAd *)splashAd{

    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidDismissAd error:nil];
}
/**
 *  点击以后全屏广告页已经被关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd{
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidDismissModal error:nil];
}
- (void)stopBeingDelegate {
    AWLogInfo(@"gdt splash stop being delegate");
    self.splash.delegate = nil;
    self.splash = nil;
}

@end
