/*
 adview openapi ad-Aduu.
*/

#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdapterAduu.h"
#import "AdViewExtraManager.h"

#import "AduuConfig.h"

@interface AdViewAdapterAduu ()
@end


@implementation AdViewAdapterAduu

@synthesize aduuView;

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeAduu;
}

+ (void)load {
	if(NSClassFromString(@"AduuView") != nil) {
		[[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
	}
}

- (void)getAd {
    Class AduuAdViewClass = NSClassFromString (@"AduuView");
	Class AduuConfigClass = NSClassFromString(@"AduuConfig");
	if (nil == AduuAdViewClass || nil == AduuConfigClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no aduu lib, can not create.");
		return;
	}
    
	
	[self updateSizeParameter];
    [AduuConfigClass launchWithAppID:[self appId] appSecret:networkConfig.pubId2 channelID:@"61"];
    CGRect r = CGRectMake(0.0f, 0.0f, self.sSizeAd.width, self.sSizeAd.height);
    AWLogInfo(@"%d",self.nSizeAd);
    AduuView* adView = [[AduuAdViewClass alloc] initWithContentSizeIdentifier:self.nSizeAd delegate:self];
	if (nil == adView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}

    adView.frame = r;
    adView.updateTime = 30;
    [adView setAduuViewOrigin:CGPointMake(0, 0)];
    [adView start];
    
    UIView *dummyView = [[UIView alloc] initWithFrame:r];
	[dummyView addSubview:adView];
    
    self.adNetworkView = dummyView;
    self.aduuView = adView;
//    AWLogInfo(@"%@",[AduuAdViewClass sdkVersion]);
}

- (BOOL)canMultiBeingDelegate {
    return NO;
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    int flagArr[] = {AduuBannerContentSizeIdentifier320x50,
        AduuBannerContentSizeIdentifier728x90,
        AduuBannerContentSizeIdentifier320x50,
        AduuBannerContentSizeIdentifier320x50,
        AduuBannerContentSizeIdentifier320x50,
        AduuBannerContentSizeIdentifier728x90};
    CGSize sizeArr[] = {CGSizeMake(320,50),CGSizeMake(720,110),
        CGSizeMake(320,50),CGSizeMake(320,50),
        CGSizeMake(320,50),CGSizeMake(720,110)};
    
    [self setSizeParameter:flagArr size:sizeArr];
}

- (void)cleanupDummyRetain {
    [super cleanupDummyRetain];
    
    if (self.aduuView) {
        [self.aduuView stop];
        self.aduuView = nil;
    }
    self.adNetworkView = nil;
}

#pragma mark -
#pragma mark delegate

- (NSString *) appId {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(aduuApIDString)]) {
		apID = [adViewDelegate aduuApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	
	return apID;
	
#if 0
	return @"4f0acf110cf2f1e96d8eb7ea";		//4f0acf110cf2f1e96d8eb7ea
#endif
}

- (BOOL)shouldSendExMetric {
    return NO;
}

//成功加载后调用
- (void)didReceiveAd:(AduuView *)adView {
    AWLogInfo(@"Aduu success to load ad.");
	[self.adViewView adapter:self didReceiveAdView:self.adNetworkView];
    [self.adViewView adapter:self shouldReport:self.adNetworkView DisplayOrClick:YES];
}

// 请求广告条数据失败后调用
//
// 详解:
//      当接收服务器返回的广告数据失败后调用该方法

- (void)didFailToReceiveAd:(AduuView *)adView  error:(NSError *)error {
    AWLogInfo(@"Aduu failed to load ad.");
	[self.adViewView adapter:self didFailAd:error];
}

- (void)didClickAd:(AduuView *)adView {
    [self.adViewView adapter:self shouldReport:self.adNetworkView DisplayOrClick:NO];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--Aduu stopBeingDelegate--");
    [self.aduuView stop];
    self.aduuView = nil;
    self.adNetworkView = nil;
}

@end
