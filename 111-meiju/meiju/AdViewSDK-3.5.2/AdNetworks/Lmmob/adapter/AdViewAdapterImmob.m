/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdapterImmob.h"
#import "AdViewViewImpl.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewLog.h"
#import "AdViewView.h"
#import "AdviewObjCollector.h"

#define LMMOB_CHANNEL_KEY		@"channelID"
#define LMMOB_VIEW_CLASS_NAME	@"MMediaView"

@interface AdViewAdapterImmob()

- (void)updateAdFrame:(UIView*)view;
- (UIView*)makeAdView;

@end

@implementation AdViewAdapterImmob

+ (AdViewAdNetworkType) networkType {
    return AdViewAdNetworkTypeImmob;
}

+ (void) load
{
    if (NSClassFromString(LMMOB_VIEW_CLASS_NAME)){
        //AWLogInfo(@"AdView: Found LMMob AdNetwork");
        [[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
    }
}

- (void) getAd
{
    Class lmmob_view_class = NSClassFromString(LMMOB_VIEW_CLASS_NAME);
	if (nil == lmmob_view_class) {
		AWLogInfo(@"no lmmob sdk, can not show.");
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
    MBJoyView* lmmob_view = (MBJoyView*)[self makeAdView];
	if (nil == lmmob_view) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
    lmmob_view.frame = self.rSizeAd;
    
    self.adNetworkView = lmmob_view;
	self.bWaitAd = NO;
	[lmmob_view mBJoyRequest];
    
//    [self.adViewView adapter:self didReceiveAdView:lmmob_view];
    [[self immobViewController].view addSubview:self.adNetworkView];
//    [lmmob_view mBJoyHide];

}

- (void) stopBeingDelegate
{
	AWLogInfo(@"--LMMOB stopBeingDelegate--");
    MBJoyView* lmmob_view = (MBJoyView*)self.adNetworkView;

    [lmmob_view performSelector:@selector(setDelegate:) withObject:nil];
	
	//maybe need wait release in AdviewObjCollector.
	if (self.bWaitAd && nil != lmmob_view) {
		[[AdviewObjCollector sharedCollector] addObj:lmmob_view];
	}
	
	//[lmmob_view removeFromSuperview];
	self.adNetworkView = nil;
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    int flagArr[] = {0,0,
        0,0,
        0,0};
    
    [self setSizeParameter:flagArr size:nil];
}

- (void) dealloc
{
    
}

- (void)updateAdFrame:(UIView*)view {
	//can not set, it will be set by lmmod sdk.
//    CGRect r = CGRectMake(0.0f, 0.0f, 320.0f, 50.0f);
//    view.frame = r;
}

- (UIView*)makeAdView {
    NSString *appIdString = self.networkConfig.pubId;
    AWLogInfo(@"LMMob: application id: %@", appIdString);
    
    Class lmmob_view_class = NSClassFromString(LMMOB_VIEW_CLASS_NAME);
    MBJoyView* lmmob_view = [[lmmob_view_class alloc] initWithUnitId:appIdString mBJoyType:MBJoyTypeBanner rootViewController:[self immobViewController] userInfo:nil];
	if (nil == lmmob_view) {
		return nil;
	}
	
	AWLogInfo(@"lmmob view:%u", lmmob_view);
	self.adNetworkView = lmmob_view;
    
	lmmob_view.delegate = self;
//	[lmmob_view.UserAttribute setObject:@"adview" forKey:LMMOB_CHANNEL_KEY];

    [self updateAdFrame:lmmob_view];
	return lmmob_view;
}

- (UIViewController *)immobViewController {
	if ([self.adViewDelegate respondsToSelector:@selector(viewControllerForPresentingModalView)])
		return [self.adViewDelegate viewControllerForPresentingModalView];
	return nil;
}

#pragma mark immobViewDelegate
- (void)mBJoyViewDidReceiveAd:(MBJoyView *)mBJoyView {
    AWLogInfo(@"immobViewDidReceiveAd");
    self.bWaitAd = NO;
    [self updateAdFrame:self.adNetworkView];
    [self.adViewView adapter:self didReceiveAdView:mBJoyView];
    [mBJoyView mBJoyDisplay];
}

- (void)mBJoyView: (MBJoyView*) mBJoyView didFailToReceiveMBJoyAdWithError: (NSInteger) errorCode {
    AWLogInfo(@"immobView fail, code:%d", errorCode);
	self.bWaitAd = NO;

	[self.adViewView adapter:self didFailAd:[NSError errorWithDomain:@"err code" code:errorCode userInfo:nil]];
}

- (void)onPresentScreen:(MBJoyView *)mBJoyView {
    AWLogInfo(@"immobViewDelegate onPresentScreen");
    self.bWaitAd = NO;
    [self updateAdFrame:self.adNetworkView];
    [self.adViewView adapter:self didReceiveAdView:self.adNetworkView];
}

- (void)onDismissScreen:(MBJoyView *)mBJoyView {
	AWLogInfo(@"immobViewDelegate onDismissScreen");
    //[self helperNotifyDelegateOfFullScreenModalDismissal];
}

@end
