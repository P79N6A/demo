//
//  AdViewAdapterChance.m
//  AdViewSDK
//
//  Created by Ma ming on 13-6-28.
//
//

#import "AdViewAdapterChance.h"
#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"

#import "CSADRequest.h"
#import "ChanceAd.h"

@implementation AdViewAdapterChance

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeChance;
}

+ (void)load {
    if(NSClassFromString(@"ChanceAd") != nil) {
		[[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
	}
}

- (void)getAd {
    Class ChanceAdClass = NSClassFromString(@"ChanceAd");
    Class PBBannerClass = NSClassFromString(@"CSBannerView");
    Class CSADRequestClass = NSClassFromString(@"CSADRequest");
    if (nil == ChanceAdClass || nil == PBBannerClass || nil == CSADRequestClass) {
        AWLogInfo(@"no Chance lib, can not create.");
		[adViewView adapter:self didFailAd:nil];
        return;
    }

    NSString *appID = self.networkConfig.pubId;

    CSADRequest *adRequest = [CSADRequestClass requestWithRequestInterval:40 andDisplayTime:40];
    if ([self.networkConfig.pubId2 length] > 0)
        adRequest.placementID = self.networkConfig.pubId2;
    else adRequest.placementID = @"debug";
    
    [ChanceAdClass startSession:appID];
    [self updateSizeParameter];
    UIView *view = [[UIView alloc] initWithFrame:self.rSizeAd];
    CSBannerView *bannerView = [[PBBannerClass alloc] initWithFrame:self.rSizeAd];
    bannerView.delegate = self;
//    bannerView.didReceiveAd=^(){
//        AWLogInfo(@"chance banner didReceiveAd");
//    };
    [bannerView loadRequest:adRequest];
    self.adNetworkView = view;
    [view addSubview:bannerView];
    self.actAdView = bannerView;
//    [bannerView loadRequest:adRequest];
     //设置是否是测试模式
//    [ChanceAdClass requestEventAd:@"adview" withPosition:CGPointMake(0, 0)];
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

    CGSize sizeArr[] = {CGSizeMake(320,50),CGSizeMake(720,90),
        CGSizeMake(320,50),CGSizeMake(320,50),
        CGSizeMake(320,50),CGSizeMake(720,90)};
    
    [self setSizeParameter:nil size:sizeArr];
}


#pragma mark -
#pragma mark delegate

// 收到Banner广告
//- (void)csBannerViewDidReceiveAd:(CSBannerView *)csBannerView
//{
//    AWLogInfo(@"Chance csBannerViewDidReceiveAd");
//    if (csBannerView)
//        [self.adViewView adapter:self didReceiveAdView:csBannerView];
//}

// Banner广告数据错误
- (void)csBannerView:(CSBannerView *)csBannerView
       showAdFailure:(CSError *)csError
{
    AWLogInfo(@"Chance error");
    [self.adViewView adapter:self didFailAd:nil];
}

// 将要展示Banner广告
- (void)csBannerViewWillPresentScreen:(CSBannerView *)csBannerView
{
    AWLogInfo(@"Chance will presentScreen");
    if (csBannerView)
        [self.adViewView adapter:self didReceiveAdView:csBannerView];
}

// 移除Banner广告
- (void)csBannerViewDidDismissScreen:(CSBannerView *)csBannerView
{
    AWLogInfo(@"Chance will dismiss");
}

- (void)stopBeingDelegate {
    AWLogInfo(@"Chance stop Being delegate");
    CSBannerView *banner = (CSBannerView*)self.actAdView;
    banner.delegate = nil;
    [banner removeFromSuperview];
    if (!self.bGotView) [self.adNetworkView removeFromSuperview];
    self.adNetworkView = nil;
    self.actAdView = nil;
}

@end
