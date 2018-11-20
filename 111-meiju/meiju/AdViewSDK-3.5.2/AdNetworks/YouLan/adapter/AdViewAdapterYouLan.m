//
//  AdViewAdapterGDTMob.m
//  AdViewSDK
//
//  Created by 马明 on 14-1-28.
//
//

#import "AdViewAdapterYouLan.h"
#import "AdViewViewImpl.h"
#import "adViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "YLSdkManager.h"


@implementation AdViewAdapterYouLan

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeYouLan;
}

+ (void)load {
    if (NSClassFromString(@"YLBanner") != nil) {
        [[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
    }
}

- (void)getAd {
    Class YLBannerClass = NSClassFromString (@"YLBanner");
	
	if (nil == YLBannerClass) {
		AWLogInfo(@"no YouLan lib, can not create.");
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
	YLBanner *adView = (YLBanner*)[self makeAdView];
	if (nil == adView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
	self.adNetworkView = adView;
    [adView startRequest]; // 开始加载广告
    

}


- (void)stopBeingDelegate {
    AWLogInfo(@"--YouLan stopBeingDelegate--");
    YLBanner *YouLanView = (YLBanner *)self.adNetworkView;
    YouLanView = nil;
	self.adNetworkView = nil;
}

- (void)dealloc {
    
}

- (UIView*)makeAdView {
    Class YLYLBannerClass = NSClassFromString (@"YLBanner");
	
	if (nil == YLYLBannerClass) {
		AWLogInfo(@"no YouLan lib, can not create.");
        [adViewView adapter:self didFailAd:nil];
		return nil;
	}
	
	if (nil == self) {
		AWLogInfo(@"have not set YouLan adapter.");
        [adViewView adapter:self didFailAd:nil];
		return nil;
	}
	
	AdViewAdapterYouLan *adapter = (AdViewAdapterYouLan *)self;
	
	[adapter updateSizeParameter];
    
    CGRect frame = CGRectMake(adapter.rSizeAd.origin.x, adapter.rSizeAd.origin.y, adapter.sSizeAd.width, adapter.sSizeAd.height);

    // sdk设置
    // 此clientId由幽蓝分配
    [YLSdkManager setClientId:networkConfig.pubId];
    
    YLBanner *adView =[YLBanner initAdWithAdSpaceId:networkConfig.pubId2 adSize:CGSizeMake(320, 50) delegate:self frame:frame];
    //@"1042"
    
    
    if (nil == adView) {
		AWLogInfo(@"did not alloc YouLanView");
		return nil;
	}
    adView.frame = frame;
    
	return adView;
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */

    CGSize sizeArr[] = {CGSizeMake(320, 50),CGSizeMake(728, 90),
        CGSizeMake(320, 50),CGSizeMake(300, 250),
        CGSizeMake(460, 100),CGSizeMake(728, 90)};
    
    [self setSizeParameter:nil size:sizeArr];
}


#pragma mark YouLan delegate
- (void)onClick:(YLBanner *)adView{
    AWLogInfo(@"YouLan click report");
    [adViewView adapter:self shouldReport:self.adNetworkView DisplayOrClick:NO];
}
- (void)onRefresh:(YLBanner *)adView{
    
}
- (void)onAdSucessed:(UIView *)adView{
    AWLogInfo(@"YouLan did receiveAd");
    [self.adViewView adapter:self didReceiveAdView:self.adNetworkView];
}
- (void)onAdFailed:(UIView *)adView{
    AWLogInfo(@"YouLan fail");
    [self.adViewView adapter:self didFailAd:nil];

}
- (void)browserClosed{
}

@end
