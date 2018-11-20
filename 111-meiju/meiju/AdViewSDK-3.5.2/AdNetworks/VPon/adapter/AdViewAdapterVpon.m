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
#import "AdViewAdapterVpon.h"
//#import "AdOnPlatform.h"

@interface AdViewAdapterVpon ()
- (NSString *) adonLicenseKey;
@end


@implementation AdViewAdapterVpon

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeVPON;
}

+ (void)load {
	if(NSClassFromString(@"VpadnBanner") != nil) {
		[[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];	
	}
}

- (void)getAd {
	Class vponBannerClass = NSClassFromString (@"VpadnBanner");
	
	if (nil == vponBannerClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no vpon lib, can not create.");
		return;
	}
	
	[self updateSizeParameter];
	
	AWLogInfo(@"Vpon version:%@",[vponBannerClass getVersionVpadn]);
	
	if ([self isTestMode]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"VPON_UDID" object:nil];
	}
//     CGPoint origin = CGPointMake(0.0,CGSizeFromVponAdSize(VponAdSizeBanner).height);
    _vpon = [[vponBannerClass alloc] initWithAdSize:VpadnAdSizeBanner];//sharedInstance] adwhirlRequestDelegate:self
//																  licenseKey:[self adonLicenseKey] 
//																		size:self.sSizeAd];
    _vpon.strBannerId = [self adonLicenseKey];
    _vpon.delegate = self;
    _vpon.platform = @"CN";
    [_vpon setIsAccessibilityElement:YES];
    [_vpon setAdAutoRefresh:NO];
//    [vpon setLocationOnOff:[self helperUseGpsMode]];
    [_vpon setRootViewController:[self.adViewView.delegate viewControllerForPresentingModalView]];
    
    if (nil == _vpon) {
        [adViewView adapter:self didFailAd:nil];
        return;
    }
    UIView *adView = [_vpon getVpadnAdView];
    [_vpon startGetAd:[self getTestIdentifiers]];
	
	adView.backgroundColor = [self helperBackgroundColorToUse];
	self.adNetworkView = adView;
//    [vpon release];
}

// 請新增此function到您的程式內 如果為測試用 則在下方填入UUID
-(NSArray*)getTestIdentifiers
{
    return [NSArray arrayWithObjects:@"E42D4D04-E927-4B9D-93DF-84762823CD34",@"36FA0EC8-B46E-45BA-85D0-E05F2D6C9EBF",@"105D334F-4A9E-41C5-9DDB-FDD054CDA8C3",
            // add your test UUID
            nil];
}

- (void)stopBeingDelegate {
  UIView *adView = (UIView *)self.adNetworkView;
	AWLogInfo(@"--Vpon stopBeingDelegate--");
  if (adView != nil) {
      self.adNetworkView = nil;
  }
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    CGSize sizeArr[] = {CGSizeMake(320, 50),CGSizeMake(728, 90),CGSizeMake(320, 50),CGSizeMake(320, 250),CGSizeMake(480, 72),CGSizeMake(728, 90)};
    
//    CGSize sizeArr[] = {ADON_SIZE_320x48,ADON_SIZE_700x105,
//        ADON_SIZE_320x48,ADON_SIZE_320X270,
//        ADON_SIZE_480x72,ADON_SIZE_700x105};
    
    [self setSizeParameter:nil size:sizeArr];
}

- (void)dealloc {
    self.adNetworkView = nil;
  
}

//return your adon Licenese Key
- (NSString *) adonLicenseKey {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(VponAdOnApIDString)]) {
		apID = [adViewDelegate VponAdOnApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	return apID;
	
	//return @"f2d0d34b319804690131a50de5900099";//@"fixme";
	
}

#pragma mark Delegate
- (void)onVpadnPresent:(UIView *)bannerView{
    NSLog(@"開啟vpon廣告頁面 %@",bannerView);
}

- (void)onVpadnDismiss:(UIView *)bannerView{
    NSLog(@"關閉vpon廣告頁面 %@",bannerView);
}

- (void)onVpadnLeaveApplication:(UIView *)bannerView{
    NSLog(@"離開publisher application");
}

//#pragma mark 回傳點擊點廣是否有效
//
//- (void)onClickAd:(UIViewController *)bannerView withValid:(BOOL)isValid withLicenseKey:(NSString *)adLicenseKey
//{
//	AWLogInfo(@"vpon click:%d", isValid);
//}

#pragma mark 通知拉取廣告成功pre-fetch完成
- (void)onVpadnAdReceived:(UIView *)bannerView {
    AWLogInfo(@"did receive an ad from vpon, %@", bannerView);
    [bannerView setAutoresizingMask:UIViewAutoresizingNone];
    [adViewView adapter:self didReceiveAdView:bannerView];
}

#pragma mark 通知拉取廣告失敗
- (void)onVpadnAdFailed:(UIView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    AWLogInfo(@"adview failed from vpon");
	[adViewView adapter:self didFailAd:nil];
}

//#pragma mark 回傳Vpon廣告抓取成功
//- (void)onRecevieAd:(UIViewController *)bannerView withLicenseKey:(NSString *)licenseKey
//{
//	AWLogInfo(@"did receive an ad from vpon, %@", bannerView);
//    [bannerView.view setAutoresizingMask:UIViewAutoresizingNone];
//    [adViewView adapter:self didReceiveAdView:bannerView.view];	
//}

//#pragma mark 回傳Vpon廣告抓取失敗
//- (void)onFailedToRecevieAd:(UIViewController *)bannerView withLicenseKey:(NSString *)licenseKey
//{
//	AWLogInfo(@"adview failed from vpon");
//	[adViewView adapter:self didFailAd:nil];		
//}

@end
