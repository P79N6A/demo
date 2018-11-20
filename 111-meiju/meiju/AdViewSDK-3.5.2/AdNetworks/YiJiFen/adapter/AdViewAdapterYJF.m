//
//  AdViewAdapterYJF.m
//  AdViewAll
//
//  Created by 张宇宁 on 15-3-16.
//  Copyright (c) 2015年 unakayou. All rights reserved.
//

#import "AdViewAdapterYJF.h"
#import "adViewAdNetworkRegistry.h"
#import "AdViewViewImpl.h"
#import "adViewAdNetworkConfig.h"
#import "adViewLog.h"

@implementation AdViewAdapterYJF
+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeYJF;
}

+ (void)load {
    if (NSClassFromString(@"EADBannerView") != nil) {
        [[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
    }
}

- (void)getAd
{
    Class HMAdBannerClass = NSClassFromString(@"EADBannerView");
    if (nil == HMAdBannerClass)return;
    
    NSString *appID = self.networkConfig.pubId;
    NSString *userID = self.networkConfig.pubId2;
    NSString *appKey = self.networkConfig.pubId3;
    
    [EADConfig startWithAppId:appID appKey:appKey devId:userID];
    [EADConfig configCoopInfo:@"coopinfo"];
    //此参数是服务器端回调必须使用的参数。值为用户id（用户指的是开发者app的用户），默认是coopinfo
    
    [self updateSizeParameter];
    self.bannerAd = [[EADBannerView alloc]initWithFrame:self.rSizeAd];
    
    if (nil == self.bannerAd) {
        [self.adViewView adapter:self didFailAd:nil];
        return;
    }
    
    self.bannerAd.delegate = self;
    
    self.bannerAd.rootViewController = [self showViewController];
    
    self.adNetworkView = self.bannerAd;
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    CGSize sizeArr[] = {CGSizeMake(320,50),CGSizeMake(720,110),
        CGSizeMake(320,50),CGSizeMake(320,50),
        CGSizeMake(320,50),CGSizeMake(720,110)};
    
    [self setSizeParameter:nil size:sizeArr];
}

- (UIViewController*)showViewController {
    if (self.adViewDelegate && [self.adViewDelegate respondsToSelector:@selector(viewControllerForPresentingModalView)]) {
        return [self.adViewDelegate viewControllerForPresentingModalView];
    }
    return nil;
}
#pragma mark HMBanner delegete

- (void)bannerViewDidLoadAd:(EADBannerView *)banner
{
    [adViewView adapter:self didReceiveAdView:banner];
}

- (void)bannerViewWillLoadAd:(EADBannerView *)banner
{
    [adViewView adapter:self shouldReport:self.adNetworkView DisplayOrClick:YES];
}

- (void)bannerView:(EADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    AWLogInfo(@"AdView fail from YJF is error:%@", error);
    [adViewView adapter:self didFailAd:error];
}

- (BOOL)shouldSendExMetric {
    return NO;
}

- (void)stopBeingDelegate
{
    AWLogInfo(@"YJF stopBeingDelegate");
    if (self.bannerAd) {
        self.bannerAd = nil;
    }
    if (self.bannerAd.delegate) {
        self.bannerAd.delegate=nil;
    }
    if (self.adNetworkView) {
        self.adNetworkView=nil;
    }
}


@end
