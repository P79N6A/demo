	//
//  AdViewAdapterAdPro.m
//  AdViewAll
//
//  Created by 周桐 on 15/9/7.
//  Copyright (c) 2015年 unakayou. All rights reserved.
//

#import "AdViewAdapterAdPro.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewViewImpl.h"

@implementation AdViewAdapterAdPro

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeAdPro;
}

+ (void)load {
    if(NSClassFromString(@"AdProBannerView") != nil) {
        [[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
    }
}

- (void)getAd {
  
    Class adProBannerClass = NSClassFromString(@"AdProBannerView");
    if (adProBannerClass == nil) {
        [adViewView adapter:self didFailAd:nil];
        AWLogInfo(@"no adpro lib, can't create");
        return;
    }

    [self updateSizeParameter];
    
    AWLogInfo(@"AdPro Size :%@", NSStringFromCGRect(self.rSizeAd));
    AdProBannerView *bannerView = [[AdProBannerView alloc] initWithAppID:self.networkConfig.pubId appKey:self.networkConfig.pubId2 slotID:self.networkConfig.pubId3 adSize:CGSizeMake(self.rSizeAd.size.width, self.rSizeAd.size.height) origin:CGPointMake(0, 0)];
    bannerView.delegate = self;
    bannerView.rootViewController = [adViewDelegate viewControllerForPresentingModalView];

    if (nil == bannerView) {
        [adViewView adapter:self didFailAd:nil];
        return;
    }
    
    [bannerView loadAd];
    
    self.adNetworkView = bannerView;
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--AdPro stopBeingDelegate--");
    AdProBannerView *bannerView = (AdProBannerView*)self.adNetworkView;
    bannerView.delegate = nil;
    bannerView = nil;
    
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    CGSize sizeArr[] = {CGSizeMake(320,50),CGSizeMake(728,90),
        CGSizeMake(320,50),CGSizeMake(320,50),
        CGSizeMake(320,50),CGSizeMake(728,90)};
    
    [self setSizeParameter:nil size:sizeArr];
}

- (void)dealloc {
    
}
#pragma mark --delegate
/**
 *  广告数据加载完成
 */
- (void)AdProBannerViewDidReceiveAd:(AdProBannerView *)bannerView{
    [adViewView adapter:self didReceiveAdView:bannerView];
}

/**
 *  广告数据加载失败
 */
- (void)AdProBannerView:(AdProBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error{
    AWLogInfo(@"AdPro Error:%@", [error description]);
    [adViewView adapter:self didFailAd:error];
}

- (void)AdProBannerViewWillPresentScreen:(AdProBannerView *)bannerView{
    
}

/// Tells the delegate that the full screen view has been dismissed. The delegate should restart
/// anything paused while handling AdProBannerViewWillPresentScreen:.
- (void)AdProBannerViewDidDismissScreen:(AdProBannerView *)bannerView{
    
}

/// Tells the delegate that the user click will open another app, backgrounding the current
/// application. The standard UIApplicationDelegate methods, like applicationDidEnterBackground:,
/// are called immediately after this method is called.
- (void)AdProBannerViewWillLeaveApplication:(AdProBannerView *)bannerView{
    
}

@end
