//
//  AdViewAdapterMopan.m
//  AdViewAll
//
//  Created by 周桐 on 15/11/23.
//  Copyright © 2015年 unakayou. All rights reserved.
//

#import "AdViewAdapterMopan.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdapterSmtaran.h"
#import "AdviewObjCollector.h"
#import "MopBannerController.h"
#import "AdViewViewImpl.h"

@implementation AdViewAdapterMopan

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeMopan;
}

+ (void)load {
    
    [[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
    
}

- (void)getAd {
//    Class mopanAdBannerClass = NSClassFromString (@"MopBannerController");
//    if (nil == mopanAdBannerClass) {
//        [adViewView adapter:self didFailAd:nil];
//        AWLogInfo(@"no mopanAdBanner lib, can not create.");
//        return;
//    }
    [self updateSizeParameter];
    
    [MopBannerController initWithProductId: self.networkConfig.pubId ProductSecret:self.networkConfig.pubId2];
    [MopBannerController setDelegateWithOjc:self];

    _mopanView = [MopBannerController beginLoadBanner:MopBannerSizeOne];
    self.mopanView.frame = CGRectMake(0, 0, self.rSizeAd.size.width, self.rSizeAd.size.height);
    self.adNetworkView = self.mopanView;
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--mopanAdBanner stopBeingDelegate");
    [MopBannerController removeBannerView];
    self.adNetworkView = nil;
    
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    //    int flagArr[] = {Ad_320X50,Ad_728X90,
    //        Ad_320X50,Ad_300X250,
    //        Ad_468X60,Ad_728X90};
    CGSize sizeArr[] = {CGSizeMake(320, 50), CGSizeMake(728, 90),
        CGSizeMake(320, 50), CGSizeMake(320, 50),
        CGSizeMake(320, 50), CGSizeMake(728, 90)};

    [self setSizeParameter:nil size:sizeArr];
}

- (BOOL)shouldSendExMetric
{
    return YES;
}

- (void)dealloc {
   
}

#pragma mark delegate methods.

//广告请求成功时调用
- (void)mopBannerImageLoadSuccess{
    [adViewView adapter:self didReceiveAdView:self.mopanView];
}
//广告请求失败时调用
- (void)mopBannerImageLoadFailure{
    [adViewView adapter:self didFailAd:nil];
}
//用户点击广告的时候调用
- (void)mopBannerViewbeClicked{
    
}
@end
