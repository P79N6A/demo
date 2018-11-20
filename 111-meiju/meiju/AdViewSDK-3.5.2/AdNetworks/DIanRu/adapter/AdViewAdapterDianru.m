//
//  AdinstlAdapterMiidi.h
//  AdViewAll
//
//  Created by 张宇宁 on 15-4-21.
//  Copyright (c) 2015年 unakayou. All rights reserved.
//

#import "AdViewAdapterDianru.h"
#import "adViewAdNetworkRegistry.h"
#import "AdViewViewImpl.h"
#import "adViewAdNetworkConfig.h"
#import "adViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"


@implementation AdViewAdapterDianru

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeDianRu;
}

+ (void)load {
    if (NSClassFromString(@"ZSDK") != nil) {
        [[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
    }
}

- (void)getAd {
    Class DianRuClass = NSClassFromString(@"ZSDK");
    if (nil ==  DianRuClass) {
        [self.adViewView adapter:self didFailAd:nil];
        return;
    }
    
    [self updateSizeParameter];
    
    
    BOOL isGps = [self helperUseGpsMode];
    
    AD_INIT(self.networkConfig.pubId, isGps, nil, AD_BANNER)
    self.vc=[[UIViewController alloc]init];
    
    UIView *bannerView = [[UIView alloc] init];
    
     self.vc.view.frame = self.rSizeAd;
    
    bannerView.frame = self.rSizeAd;
    
    [ self.vc.view addSubview:bannerView];
    
    
    
    [[self showViewController].view addSubview: self.vc.view];
    
//    DR_SHOW(DR_BANNER, [self showViewController], self);
    AD_SHOW(AD_BANNER, self.vc, self);
        
    self.adNetworkView = bannerView;
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
    AWLogInfo(@"--DianRu stopBeingDelegate--");
//    MMUBannerView *view = (MMUBannerView*)self.adNetworkView;
//    view.delegate = nil;
//    self.adNetworkView = nil;
//    self.actAdView = nil;
}

#pragma mark MMUBanner delegate

- (void)DidDataReceived:(id)object
                   Code:(int)code{
    if (code==0) {
        AWLogInfo(@"dianru banner received suc");
        [self.adViewView adapter:self didReceiveAdView: self.vc.view];
    }else if (code == -1)
    {
        AWLogInfo(@"dianru banner received fail");
        [self.adViewView adapter:self didFailAd:nil];
    }
}

- (void)DidLoadFail:(id)object
{
    AWLogInfo(@"dianru banner fail");
   [self.adViewView adapter:self didFailAd:nil];
}

- (void)DidViewClose:(id)object{

}

@end
