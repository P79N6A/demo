//
//  AdViewAdapterGDTMob.m
//  AdViewSDK
//
//  Created by 马明 on 14-1-28.
//
//

#import "AdViewAdapterSTMob.h"
#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"

@implementation AdViewAdapterSTMob

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeSTMob;
}

+ (void)load {
    if (NSClassFromString(@"STMBannerView") != nil) {
        [[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
    }
}

- (void)getAd {
    Class BannerClass = NSClassFromString (@"STMBannerView");
	
	if (nil == BannerClass) {
		AWLogInfo(@"no lib, can not create.");
		[adViewView adapter:self didFailAd:nil];
		return;
	}
    
	[self updateSizeParameter];
    
    NSString *key = self.networkConfig.pubId;//@"2_36_35";//
    NSArray *keys = [key componentsSeparatedByString:@"_"];
    if (!keys || [keys count] != 3) {
        return;
    }
    NSString * key1 = [keys objectAtIndex:0];
    NSString * key2 = [keys objectAtIndex:1];
    NSString * key3 = [keys objectAtIndex:2];
    
    NSString * appKey = self.networkConfig.pubId2;//@"Ac7Kd3lJ^KQX9Hjkn_Z(UO9jqViFh*q1";//
    
    self.bannerAdView = [[STMBannerView alloc] initWithPublisherID:key1
                                                             appID:key2
                                                       placementID:key3
                                                            appKey:appKey
                                                             frame:self.rSizeAd];
    
    self.bannerAdView.delegate = self;
	self.adNetworkView = self.bannerAdView;
     [self.bannerAdView loadAd]; // 开始加载广告
    
 //    [self setupDefaultDummyHackTimer];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--舜飞 stopBeingDelegate--");
    self.bannerAdView.delegate = nil;
    self.bannerAdView = nil;
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
        CGSizeMake(320, 50),CGSizeMake(300, 250),
        CGSizeMake(460, 100),CGSizeMake(728, 90)};
    
    [self setSizeParameter:nil size:sizeArr];
}

#pragma mark  delegate
/**
 *  The banner ad loaded.
 *
 *  @param bannerView The `bannerView` instance.
 */
- (void)bannerViewDidLoadAd:(STMBannerView *)bannerView{
    AWLogInfo(@" did receiveAd");
    [self.adViewView adapter:self didReceiveAdView:self.adNetworkView];
}

/**
 *  The banner ad load failed.
 *
 *  @param bannerView The `bannerView` instance.
 *  @param error      The error information of `bannerView` load fail.
 */
- (void)bannerView:(STMBannerView *)bannerView didFailToLoadAdWithError:(NSError *)error{
    AWLogInfo(@" fail, code:%d",error);
    [self.adViewView adapter:self didFailAd:error];
}

/**
 *  The banner ad tapped.
 *
 *  @param bannerView The `bannerView` instance.
 */
- (void)bannerViewDidTap:(STMBannerView *)bannerView{}

/**
 *  The banner ad closed.
 *
 *  @param bannerView The `bannerView` instance.
 */
- (void)bannerViewDidDismiss:(STMBannerView *)bannerView{}

@end
