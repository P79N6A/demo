//
//  AdViewAdapterTanx.m
//  AdViewDevelop
//
//  Created by maming on 14-11-17.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdViewAdapterTanx.h"
#import "adViewAdNetworkRegistry.h"
#import "AdViewViewImpl.h"
#import "adViewAdNetworkConfig.h"
#import "adViewLog.h"

@implementation AdViewAdapterTanx

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeTanx;
}

+ (void)load {
    if (NSClassFromString(@"MMUBannerView") != nil) {
        [[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
    }
}

- (void)getAd {
    Class MMClass = NSClassFromString(@"MMUBannerView");
    if (nil ==  MMClass) {
        [self.adViewView adapter:self didFailAd:nil];
        return;
    }
    
    [self updateSizeParameter];
    
    NSString *appId = [self.networkConfig pubId];
    
    MMUBannerView *banner = [[MMClass alloc] initWithFrame:self.rSizeAd slotId:appId currentViewController:[self showViewController]];
    if (nil == banner) {
        [self.adViewView adapter:self didFailAd:nil];
        return;
    }
    
    self.adNetworkView = banner;
    banner.delegate = self;
    [banner requestPromoterDataInBackground];
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

-(void)stopBeingDelegate {
    AWLogInfo(@"--Tanx stopBeingDelegate--");
    MMUBannerView *view = (MMUBannerView*)self.adNetworkView;
    view.delegate = nil;
    self.adNetworkView = nil;
    self.actAdView = nil;
}

#pragma mark MMUBanner delegate
- (void)bannerWillAppear:(MMUBannerView *)banner {
    
}

- (void)bannerDidAppear:(MMUBannerView *)banner {
    AWLogInfo(@"Tanx didAppear");
    [adViewView adapter:self didReceiveAdView:banner];
    [adViewView adapter:self shouldReport:self.adNetworkView DisplayOrClick:YES];
}

- (void)bannerWillDisappear:(MMUBannerView *)banner {

}

- (void)bannerDidDisappear:(MMUBannerView *)banner {

}

- (void)bannerDidClicked:(MMUBannerView *)banner {
    AWLogInfo(@"Tanx clicked");
    [adViewView adapter:self shouldReport:banner DisplayOrClick:NO];
}

- (BOOL)shouldSendExMetric
{
    return NO;
}

- (void)bannerView:(MMUBannerView *)banner didLoadPromoterFailedWithError:(NSError *)error {
    AWLogInfo(@"Tanx load failed");
    [adViewView adapter:self didFailAd:error];
}

@end
