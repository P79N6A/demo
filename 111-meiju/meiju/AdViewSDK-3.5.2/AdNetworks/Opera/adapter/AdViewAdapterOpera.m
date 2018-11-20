//
//  AdViewAdapterGDTMob.m
//  AdViewSDK
//
//  Created by 马明 on 14-1-28.
//
//

#import "AdViewAdapterOpera.h"
#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "OperaAdManager.h"

@implementation AdViewAdapterOpera

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeOpera;
}

+ (void)load {
    if (NSClassFromString(@"BannerAdView") != nil) {
        [[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
    }
}

- (void)getAd {
    Class BannerClass = NSClassFromString (@"BannerAdView");
	
	if (nil == BannerClass) {
		AWLogInfo(@"no Opera lib, can not create.");
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
    [self updateSizeParameter];
    [[OperaAdManager getInstance] setAdvertiseInfo:@"adview"];
    
    NSString * appKey = self.networkConfig.pubId;//@"5585s07027";//
     bannerView = [[BannerAdView alloc]initWithFrame:self.rSizeAd slotToken:appKey refreshTimer:OperaBannerAdRefreshTimeHalfMinute animationType:OperaBannerAnimationOptionTransitionRandom];
    bannerView.delegate = self;

	if (nil == bannerView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
	self.adNetworkView = bannerView;
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--Opera stopBeingDelegate--");
    BannerAdView* View = (BannerAdView*)self.adNetworkView;
    View.delegate = nil;
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
        CGSizeMake(320, 50),CGSizeMake(300, 250),
        CGSizeMake(460, 100),CGSizeMake(728, 90)};
    
    [self setSizeParameter:nil size:sizeArr];
}

#pragma mark Opera delegate
/**
 * @brief bannerAd banner 请求数据成功
 * @param bannerAd
 */
-(void)operaBannerAdRequestSuccessed:(BannerAdView *)bannerAd{
    AWLogInfo(@"Opera did receiveAd");
    [self.adViewView adapter:self didReceiveAdView:self.adNetworkView];
}
/**
 * @brief bannerAd banner 请求数据失败
 * @param bannerAd
 */
-(void)operaBannerAdRequestFailure:(BannerAdView *)bannerAd error:(NSString *)error{
    AWLogInfo(@"Opera fail");
    [self.adViewView adapter:self didFailAd:[NSError errorWithDomain:error code:0 userInfo:nil]];
}
/**
 * @brief bannerAd banner 展示成功
 * @param bannerAd
 */
-(void)operaBannerAdShowSuccessed:(BannerAdView *)bannerAd{
    AWLogInfo(@"Opera operaBannerAdShowSuccessed");
}

/**
 * @brief bannerAd banner 展示失败
 * @param bannerAd
 */
-(void)operaBannerAdShowFailure:(BannerAdView *)bannerAd{
    AWLogInfo(@"Opera fail");
    [self.adViewView adapter:self didFailAd:nil];
}

/**
 * @brief bannerAd banner 广告被点击
 * @param bannerAd
 */
-(void)operaBannerAdClick:(BannerAdView *)bannerAd{
    AWLogInfo(@"Opera operaBannerAdClick");
}

/**
 * @brief bannerAd banner 广告被关闭
 * @param bannerAd
 */
-(void)operaBannerAdClose:(BannerAdView *)bannerAd{
    AWLogInfo(@"Opera operaBannerAdClose");
}

@end
