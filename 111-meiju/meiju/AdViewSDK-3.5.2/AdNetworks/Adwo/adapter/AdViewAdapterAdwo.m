/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdapterAdwo.h"
#import "AdviewObjCollector.h"

@interface AdViewAdapterAdwo ()
- (NSString *)adwoPublisherIdForAd;
@end


@implementation AdViewAdapterAdwo

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeADWO;
}

+ (void)load {
    [[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
}

- (void)getAd {
	[self updateSizeParameter];
    UIView *adView = AdwoAdCreateBanner([self adwoPublisherIdForAd],![self isTestMode], self);
    
	if (nil == adView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
    AWLogInfo(@"Adwo view:%@", adView);
    
    adView.frame = self.rSizeAd;
    //    [adView performSelector:@selector(setAGGChannel:) withObject:[NSNumber numberWithInteger:ADWOSDK_AGGREGATION_CHANNEL_ADVIEW]];    //
    //    AdwoAdSetBannerRequestInterval(16);
    adwoAdStopBannerAutoRefresh();
    if (!AdwoAdSetAdAttributes(adView, &(const struct AdwoAdPreferenceSettings){.adSlotID = 0,.disableGPS = [self helperUseGpsMode],.animationType = ADWO_ANIMATION_TYPE_AUTO,.spreadChannel = ADWOSDK_SPREAD_CHANNEL_APP_STORE}))
        AWLogInfo(@"Adwo set AdwoAdPreferenceSettings fail!");
    
    [self addActAdViewInContain:adView rect:self.rSizeAd];
    
    AWLogInfo(@"Adwo adtype:%d", self.nSizeAd);
    BOOL load = AdwoAdLoadBannerAd(adView, self.nSizeAd, nil);
    if (!load) {
        [adViewView adapter:self didFailAd:nil];
		return;
    }
    
    [self setupDummyHackTimer:14.0f];
}

- (void)stopBeingDelegate {
    UIView *adView = self.actAdView;
	AWLogInfo(@"--Adwo stopBeingDelegate--");
    [self cleanupDummyHackTimer];
    
    if (adView != nil) {
        //        adwoAdStopBannerAutoRefresh();
        if (!self.bGotView)
            [self.adNetworkView removeFromSuperview];
        else {
            //here can get image for actAdView, and to remove actAdView.
            //[self getImageOfActAdViewForRemove];
        }
        AdwoAdRemoveAndDestroyBanner(adView);
        self.adNetworkView = nil;
        self.actAdView = nil;
    }
}

- (void)cleanupDummyRetain {
    [self cleanupDummyHackTimer];
    [super cleanupDummyRetain];
    
    //    UIView *adView = self.actAdView;
    //    AdwoAdPauseBannerRequest(adView);
    //    adwoAdStopBannerAutoRefresh();
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    int flagArr[] = {ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_320x50,
        ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_720x110,
        ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_320x50,
        ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_320x50,
        ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_320x50,
        ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_720x110};
    CGSize sizeArr[] = {CGSizeMake(320,50),CGSizeMake(720,110),
        CGSizeMake(320,50),CGSizeMake(320,50),
        CGSizeMake(320,50),CGSizeMake(720,110)};
    
    [self setSizeParameter:flagArr size:sizeArr];
}

- (void)dealloc {
    
}

#pragma mark AwAdDelegate methods

- (NSString *)adwoPublisherIdForAd {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(AdwoApIDString)]) {
		apID = [adViewDelegate AdwoApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	return apID;
	
	//return @"a2c491847b8e4be78b8aa223ae625e43";
}

- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(adwoAdViewDidFailToLoadAd:)
                               withObject:adView waitUntilDone:NO];
        return;
    }
    AWLogInfo(@"adwoAdViewDidFailToLoadAd");
    [self cleanupDummyHackTimer];
    
    [adViewView adapter:self didFailAd:nil];
}

- (void)adwoAdViewDidLoadAd:(UIView *)adView {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(adwoAdViewDidLoadAd:)
                               withObject:adView waitUntilDone:NO];
        return;
    }
    AWLogInfo(@"adwoAdViewDidLoadAd, size: %@", NSStringFromCGRect(adView.frame));
    [self cleanupDummyHackTimer];
    
    adView.frame = self.rSizeAd;
    [adViewView adapter:self didReceiveAdView:self.adNetworkView];
}

- (void)adwoDidPresentModalViewForAd:(UIView*)adView {
    AWLogInfo(@"adwoDidPresentModalViewForAd");
    //    if (!AdwoAdPauseBannerRequest(adView))
    //        AWLogInfo(@"adwo pause fail");
    
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void)adwoDidDismissModalViewForAd:(UIView*)adView {
    AWLogInfo(@"adwoDidDismissModalViewForAd");
    //    if (!AdwoAdResumeBannerRequest(adView))
    //        AWLogInfo(@"adwo resumed fail");
    
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

#pragma Report

- (BOOL)shouldSendExMetric {
	return NO;
}

- (UIViewController*)adwoGetBaseViewController {
	if ([adViewDelegate respondsToSelector:@selector(viewControllerForPresentingModalView)])
	{
		return [adViewDelegate viewControllerForPresentingModalView];
    }
    return nil;
}

// 用于获取广告点击计数
- (void)adwoClickAdAction:(UIView*)adView
{
    AWLogInfo(@"adwoClickAdAction");
    [adViewView adapter:self shouldReport:self.adNetworkView DisplayOrClick:NO];
}

// 用于获取广告展示计数
- (void)adwoShowAdAction:(UIView*)adView
{
    AWLogInfo(@"adwoShowAdAction");
    [adViewView adapter:self shouldReport:self.adNetworkView DisplayOrClick:YES];
}

@end
