//
//  AdViewAdapterJDAview.m
//  AdViewAll
//
//  Created by 周桐 on 15/11/20.
//  Copyright © 2015年 unakayou. All rights reserved.
//

#import "AdViewAdapterJDAdview.h"
#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"


@implementation AdViewAdapterJDAdview

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeJDAdview;
}

+ (void)load {
    if (NSClassFromString(@"JDAdManager") != nil) {
        [[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
    }
}

- (void)getAd {
    Class JDAdviewBannerClass = NSClassFromString (@"JDAdManager");
    
    if (nil == JDAdviewBannerClass) {
        AWLogInfo(@"no JDAdview lib, can not create.");
        [adViewView adapter:self didFailAd:nil];
        return;
    }
    
    [self updateSizeParameter];
    
    JDAdAppInfo *appInfo = [[JDAdAppInfo alloc] init];
    appInfo.keywords = @"金融，财会";
    
    JDAdUser *userinfo = [[JDAdUser alloc] initJDAdUserWithGender:JDAdGenderFemale yob:@"1983" keywords:@"白领" segments:@"1,3,5"];
    
    [JDAdManager shareManager].isHttp = YES;
    [JDAdManager shareManager].istest = NO;
    [JDAdManager shareManager].app = appInfo;
    [JDAdManager shareManager].user = userinfo;
    [JDAdManager shareManager].adDelegate = self;
    [JDAdManager shareManager].adViewDelegate = self;
    
    _banner = [[JDAdManager shareManager] createBannerAds:JDAdSize_Banner_320_48 withParent:nil withViewContorller:[self.adViewDelegate viewControllerForPresentingModalView] withTagid:self.networkConfig.pubId canClose:NO andFrame:CGRectMake(self.rSizeAd.origin.x, self.rSizeAd.origin.y, self.sSizeAd.width, self.sSizeAd.height)];
    if (_banner == nil) {
        [adViewView adapter:self didFailAd:nil];
        return;
    }
    
    self.adNetworkView = _banner;
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--JDAdview stopBeingDelegate--");
    [JDAdManager shareManager].adDelegate = nil;
    [JDAdManager shareManager].adViewDelegate = nil;
    [[JDAdManager shareManager] removeBannerAd:_banner];
    self.adNetworkView = nil;
}

- (void)dealloc {
    
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    //    int flagArr[] = {GDTMOB_AD_SUGGEST_SIZE_320x50,GDTMOB_AD_SUGGEST_SIZE_728x90,
    //        GDTMOB_AD_SUGGEST_SIZE_320x50,GDTMOB_AD_SUGGEST_SIZE_320x50,
    //        GDTMOB_AD_SUGGEST_SIZE_468x60,GDTMOB_AD_SUGGEST_SIZE_728x90};
    CGSize sizeArr[] = {CGSizeMake(320, 50),CGSizeMake(728, 90),
        CGSizeMake(320, 50),CGSizeMake(320, 50),
        CGSizeMake(320, 50),CGSizeMake(728, 90)};
    
    [self setSizeParameter:nil size:sizeArr];
}

#pragma mark - delegate
- (void)ad:(JDAd*)ad networkErrorState:(JDAdURLResponseStatus)state{
    if (JDAdURLResponseStatusSuccess != state) {
        AWLogInfo(@"JDBannerAdView fail");
        [self.adViewView adapter:self didFailAd:nil];
    }
}
- (void)ad:(JDAd*)ad loadWithError:(JDAdError)error{
    [self.adViewView adapter:self didFailAd:nil];
}
//banner代理
- (void)bannerDidLoad:(JDBannerAdView*)banner{
    
//    [adViewView adapter:self didReceiveAdView:self.adNetworkView];
//    AWLogInfo(@"JDBannerAdView did receiveAd");
}

- (void)bannerDidLoadSuccess:(JDBannerAdView*)banner{
    [adViewView adapter:self didReceiveAdView:self.adNetworkView];
    AWLogInfo(@"JDBannerAdView did receiveAd");
}


//- (void)bannerView:(JDBannerAdView *)banner didLoadWithError:(NSError *)error{
//    AWLogInfo(@"JDBannerAdView fail, code:%@",error);
//    [self.adViewView adapter:self didFailAd:error];
//}

@end
