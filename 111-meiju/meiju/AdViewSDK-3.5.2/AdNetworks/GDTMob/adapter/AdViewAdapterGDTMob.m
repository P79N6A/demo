//
//  AdViewAdapterGDTMob.m
//  AdViewSDK
//
//  Created by 马明 on 14-1-28.
//
//

#import "AdViewAdapterGDTMob.h"
#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"



@implementation AdViewAdapterGDTMob

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeGDTMob;
}

+ (void)load {
    if (NSClassFromString(@"GDTMobBannerView") != nil) {
        [[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
    }
}

- (void)getAd {
    Class GDTBannerClass = NSClassFromString (@"GDTMobBannerView");
	
	if (nil == GDTBannerClass) {
		AWLogInfo(@"no GDTMob lib, can not create.");
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
	GDTMobBannerView* adView = (GDTMobBannerView*)[self makeAdView];
	if (nil == adView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
	self.adNetworkView = adView;
    [adView loadAdAndShow]; // 开始加载广告
    
 //    [self setupDefaultDummyHackTimer];
}

//- (NSString *)appIdForAd {
//	NSString *apID;
//	if ([adViewDelegate respondsToSelector:@selector(DoMobApIDString)]) {
//		apID = [adViewDelegate DoMobApIDString];
//	}
//	else {
//		apID = networkConfig.pubId;
//	}
//	return apID;
//}

- (void)stopBeingDelegate {
    AWLogInfo(@"--GDTMob stopBeingDelegate--");
    GDTMobBannerView* gdtmobView = (GDTMobBannerView*)self.adNetworkView;
    gdtmobView.delegate = nil;
	gdtmobView.currentViewController = nil;
	self.adNetworkView = nil;
}

- (void)dealloc {
    
}

- (UIView*)makeAdView {
    Class GDTBannerClass = NSClassFromString (@"GDTMobBannerView");
	
	if (nil == GDTBannerClass) {
		AWLogInfo(@"no GDTMob lib, can not create.");
		return nil;
	}
	
	if (nil == self) {
		AWLogInfo(@"have not set GDTMob adapter.");
		return nil;
	}
	
	AdViewAdapterGDTMob *adapter = (AdViewAdapterGDTMob*)self;
	
	[adapter updateSizeParameter];
    
    CGRect frame = CGRectMake(adapter.rSizeAd.origin.x, adapter.rSizeAd.origin.y, adapter.sSizeAd.width, adapter.sSizeAd.height);
    
	GDTMobBannerView* adView = [[GDTBannerClass alloc] initWithFrame:frame appkey:networkConfig.pubId placementId:networkConfig.pubId2];//@"100720253"@"4090812164690039"
    
    if (nil == adView) {
		AWLogInfo(@"did not alloc GDTMobView");
		return nil;
	}
    adView.frame = frame;
    adView.delegate = self; // 设置 Delegate
    adView.currentViewController = [self.adViewDelegate viewControllerForPresentingModalView];
    adView.interval = 0; // 设置刷新时间为0（不自动刷新）
    adView.isGpsOn = [self helperUseGpsMode];
    adView.showCloseBtn=NO;
    
	return adView;
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

#pragma mark -
#pragma mark GDTMob delegate
- (BOOL)shouldSendExMetric {
    return YES;
}

- (void)bannerViewMemoryWarning {}

- (void)bannerViewDidReceived {
    AWLogInfo(@"GDTMOb did receiveAd");
    [self.adViewView adapter:self didReceiveAdView:self.adNetworkView];
}

- (void)bannerViewFailToReceived:(NSError*)errCode {
    AWLogInfo(@"GDTMob fail, code:%d",errCode);
    [self.adViewView adapter:self didFailAd:errCode];
}

- (void)bannerViewWillExposure {
    AWLogInfo(@"GDTMob WillExposure");
}

- (void)bannerViewWillClose {
    AWLogInfo(@"GDTMob WillClose");
}

- (void)bannerViewWillLeaveApplication {
    AWLogInfo(@"GDTMob click action");
//    [adViewView adapter:self shouldReport:self.adNetworkView DisplayOrClick:NO];
}

@end
