

#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdapterMiidi.h"
#import "AdViewExtraManager.h"
#import "MiidiMobAd.h"
#import "MiidiMobAdApiConfig.h"
#import "MiidiMobAdPubHeader.h"
#import "SingletonAdapterBase.h"


@interface AdViewAdapterMiidi ()

@end

@interface AdViewAdapterMiidiImpl : SingletonAdapterBase<MiidiMobAdBannerDelegate>
{
}

@end

static AdViewAdapterMiidiImpl *gAdViewAdapterMiidiImpl = nil;

@implementation AdViewAdapterMiidi

@synthesize bGotInGet;

+ (AdViewAdNetworkType)networkType {
	return AdViewAdNetworkTypeMiidi;
}

+ (void)load {
	if(NSClassFromString(@"ADPWPattee") != nil) {
		[[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];	
	}
}

- (void)getAd {
	Class MiidiAdViewClass = NSClassFromString (@"ADPWPattee");
	if (nil == MiidiAdViewClass) {
		[self.adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no Miidi lib, can not create.");
		return;
	}
    
    if (nil == gAdViewAdapterMiidiImpl) gAdViewAdapterMiidiImpl = [[AdViewAdapterMiidiImpl alloc] init];
    
    [gAdViewAdapterMiidiImpl setAdapterValue:YES ByAdapter:self];
    
    [MiidiAdViewClass setMiidiBasPublisher:self.networkConfig.pubId withMiidiBasSecret:self.networkConfig.pubId2];
	
    UIView *adView = [gAdViewAdapterMiidiImpl getIdelAdView];
    if (nil == adView) {
        [self.adViewView adapter:self didFailAd:nil];
        return;
    }
    
	if (nil == adView) {
		[self.adViewView adapter:self didFailAd:nil];
		return;
	}
	self.adNetworkView = adView;
	
	if (self.bGotInGet)				//got in getIdelAdView, so added here.
		[self.adViewView adapter:self didReceiveAdView:self.adNetworkView];
	else {
		//[self.adViewView adapter:self shouldAddAdView:self.adNetworkView];
	}// 请求广告
}

//can being delegate even more than one instances being delegate.
- (BOOL) canMultiBeingDelegate
{
    return NO;
}

- (void)stopBeingDelegate {
	UIView *adView = (UIView*)self.adNetworkView;
	AWLogInfo(@"--Miidi stopBeingDelegate--");
	[gAdViewAdapterMiidiImpl setAdapterValue:NO ByAdapter:self];
	if (adView != nil) {
		//[gAdViewAdapterMiidiImpl addIdelAdView:adView];
		
		[adView removeFromSuperview];
//		adView.delegate = nil;
//		AWLogInfo(@"MiidiAdView retain:%d", [adView retainCount]);
		self.adNetworkView = nil;
	}
}

- (void)cleanupDummyRetain {
	[super cleanupDummyRetain];
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    int flagArr[] = {MiidiMobAdBannerViewSize320X50,MiidiMobAdBannerViewSize768X72,
        MiidiMobAdBannerViewSize320X50,MiidiMobAdBannerViewSize200X200,
        MiidiMobAdBannerViewSize460X72,MiidiMobAdBannerViewSize768X72};
    
    [self setSizeParameter:flagArr size:nil];
}

- (void)dealloc {	
	
}

@end

@implementation AdViewAdapterMiidiImpl

- (UIView*)makeAdView {
	
	[mAdapter updateSizeParameter];
    
    UIView *adView= [MiidiMobAd requestMiidiBasBanner:mAdapter.nSizeAd withMiidiBasDelegate:self];
	
	return adView;
}

#pragma mark Delegate


- (void)didMiidiBasBannerFinishLoad:(UIView *)banner
{
    banner.hidden = NO;
	AWLogInfo(@"did receive an ad from Miidi:%@", mAdapter);
	if (nil != mAdapter) {
		if (nil != mAdapter.adNetworkView) {
			[mAdapter.adViewView adapter:mAdapter didReceiveAdView:banner];
		} else {
			((AdViewAdapterMiidi*)mAdapter).bGotInGet = YES;
		}
	}
}

// 请求广告条数据失败后调用
// 
// 详解:当接收服务器返回的广告数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)didMiidiBasBannerFailedLoad:(UIView *)banner withMiidiBasError:(NSError *)error
{
	AWLogInfo(@"adview failed from Miidi:%@", [error localizedDescription]);
	[mAdapter.adViewView adapter:mAdapter didFailAd:error];	
}

//// 显示全屏广告成功后调用
////
//// 详解:显示一次全屏广告内容后调用该函数
//- (void)didMiidiBasShowAdWindow:(MiidiAdView *)adView
//{
//	AWLogInfo(@"didShowAdWindow from Miidi");
//	[mAdapter helperNotifyDelegateOfFullScreenModal];
//}
//
//// 成功关闭全屏广告后调用
////
//// 详解:全屏广告显示完成，关闭全屏广告后调用该函数
//- (void)didMiidiBasDismissAdWindow:(MiidiAdView *)adView
//{
//	AWLogInfo(@"didDismissAdWindow from Miidi");
//	[mAdapter helperNotifyDelegateOfFullScreenModalDismissal];
//}

@end
