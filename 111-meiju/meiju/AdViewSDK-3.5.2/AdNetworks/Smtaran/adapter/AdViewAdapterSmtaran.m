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
#import "AdViewAdapterSmtaran.h"
#import "AdviewObjCollector.h"

#define TestUserSpot @"all"

@implementation AdViewAdapterSmtaran
@synthesize SmtaranAdView;

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeAdSage;
}

+ (void)load {
	if(NSClassFromString(@"SmtaranBannerAd") != nil) {
        //AWLogInfo(@"AdView: Find Smtaran AdNetork");
		[[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
	}
}

- (void)actGetAd {
    NSString *apID = @"";
    NSTimeInterval tmStart = [[NSDate date] timeIntervalSince1970];
    
	Class SmtaranAdBannerClass = NSClassFromString (@"SmtaranBannerAd");
	if (nil == SmtaranAdBannerClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no Smtaran lib, can not create.");
		return;
	}
    
	if ([adViewDelegate respondsToSelector:@selector(SmtaranApIDString)]) {
		apID = [adViewDelegate SmtaranApIDString];
	}
	else {
		apID = networkConfig.pubId2;
	}
	
	[self updateSizeParameter];
    
#if 1	//根据厂商建议，不调用此。
    Class SmtaranAdViewManagerClass = NSClassFromString (@"SmtaranSDKManager");
	if (nil != SmtaranAdViewManagerClass)
        [[SmtaranSDKManager getInstance] setPublisherID:apID auditFlag:MS_Test_Audit_Flag];

#endif
	
    NSString *slotToken = networkConfig.pubId3;
    if (nil == slotToken) {
        slotToken = @"";
    }
    
    //SmtaranBanner* adView = [[SmtaranAdBannerClass alloc] initWithDelegate:self   adSize:Default_size slotToken:slotToken intervalTime:Ad_NO_Refresh switchAnimeType:Random];
    
//    MSAdBannerType bannerType = MSAdBannerType_default;
    self.SmtaranAdView= [[SmtaranBannerAd alloc] initBannerAdSize:SmtaranBannerAdSizeNormal delegate:self slotToken:slotToken];
	
	if (nil == self.SmtaranAdView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
    self.SmtaranAdView.frame = self.rSizeAd;
    
//    adView.delegate = self;
    self.adNetworkView = self.SmtaranAdView;
    
    [self.SmtaranAdView  setBannerAdAnimeType:SmtaranBannerAdAnimationTypeRandom];
    
    [self.SmtaranAdView  setBannerAdRefreshTime:SmtaranBannerAdRefreshTimeNone];
     
    NSTimeInterval tmEnd = [[NSDate date] timeIntervalSince1970];
    
    AWLogInfo(@"Smtaran getad time:%f", tmEnd - tmStart);
}

//For first load Smtaran will use 5-9 second, use background mode.
- (void)getAd {
    //[self performSelectorInBackground:@selector(actGetAd) withObject:nil];
//    [self setupDefaultDummyHackTimer];
#if 0       //如果异步处理，未完成就释放，可能出错，因此屏蔽。
    if ([NSThread isMultiThreaded]) {
        adThread_ = [[NSThread alloc] initWithTarget:self selector:@selector(actGetAd) object:nil];
        [adThread_ setName:@"Smtaran_getad"];
        [adThread_ setThreadPriority:0.1f];
        [adThread_ start];
    } else
#endif
    {
        [self performSelector:@selector(actGetAd)];
    }
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--Smtaran stopBeingDelegate");
	
//    SmtaranBanner *banner = (SmtaranBanner*)self.adNetworkView;
//    banner.delegate = nil;
    if (self.SmtaranAdView.delegate){
        self.SmtaranAdView.delegate = nil;
    }
    if (self.SmtaranAdView) {
        self.SmtaranAdView = nil;
    }
    if (self.adNetworkView) {
        self.adNetworkView = nil;
    }
    
	[self cleanupDummyHackTimer];
}

- (void)cleanupDummyRetain {
	[super cleanupDummyRetain];
    
    if ([adThread_ isExecuting]) {
        self.adViewView = nil;
        self.adViewDelegate = nil;
        [[AdviewObjCollector sharedCollector] addObj:self];
    }
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
        CGSizeMake(320, 50), CGSizeMake(300, 250),
        CGSizeMake(468, 60), CGSizeMake(728, 90)};
    
    [self setSizeParameter:nil size:sizeArr];
}

- (void)smtaranBannerAdClick:(SmtaranBannerAd*)adBanner
{
    AWLogInfo(@"mobisSageStartClick");
//    [self.adViewView adapter:self shouldReport:adBanner DisplayOrClick:NO];
}

- (void)smtaranBannerAdSuccessToShowAd:(SmtaranBannerAd *)adBanner
{
    AWLogInfo(@"SmtaranStartShowAd");
    [self cleanupDummyHackTimer];
    [self.adViewView adapter:self didReceiveAdView:adBanner];
}

- (void)smtaranBannerLandingPageShowed:(SmtaranBannerAd*)adBanner {
    AWLogInfo(@"smtaranBannerLandingPageShowed");
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void)smtaranBannerLandingPageHided:(SmtaranBannerAd*)adBanner {
    AWLogInfo(@"smtaranBannerLandingPageHided");
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

- (void)smtaranBannerAdFaildToShowAd:(SmtaranBannerAd *)adBanner withError:(NSError *)error {
    [self.adViewView adapter:self didFailAd:error];
	AWLogInfo(@"SmtaranActionError:%@",error.domain);
}

- (BOOL)shouldSendExMetric
{
    return YES;
}

- (void)dealloc {
    if (self.SmtaranAdView.delegate){
        self.SmtaranAdView.delegate = nil;
    }
    if (self.SmtaranAdView) {
        self.SmtaranAdView = nil;
    }
    if (self.adNetworkView) {
        self.adNetworkView = nil;
    }
    [self cleanupDummyHackTimer];
}

#pragma mark delegate methods.

- (UIViewController *)viewControllerToPresent {
    if ([self.adViewDelegate respondsToSelector:@selector(viewControllerForPresentingModalView)])
        return [self.adViewDelegate viewControllerForPresentingModalView];
    return nil;

}

@end
