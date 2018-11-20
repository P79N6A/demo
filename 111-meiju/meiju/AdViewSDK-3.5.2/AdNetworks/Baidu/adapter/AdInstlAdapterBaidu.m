//
//  AdInstlAdapterAderBaidu.m
//  AdInstlSDK_iOS
//
//  Created by adview on 13-10-24.
//
//

#import "AdInstlAdapterBaidu.h"

#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"

@implementation AdInstlAdapterBaidu

@synthesize interstitialView;


+ (AdInstlAdNetworkType)networkType {
	return AdInstlAdNetworkTypeBaidu;
}

+ (void)load {
	if(NSClassFromString(@"BaiduMobAdInterstitial") != nil) {
		[[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
	}
}

- (BOOL)loadAdInstl:(UIViewController*)controller
{
    Class BaiduMobInterClass = NSClassFromString(@"BaiduMobAdInterstitial");
   
    if (BaiduMobInterClass == nil) return NO;
    if (controller == nil) return NO;
    
    self.adInstlController = controller;
    
    BaiduMobAdInterstitial *baidumobAdInstl = [[BaiduMobInterClass alloc] init] ;
    self.interstitialView = baidumobAdInstl;
     interstitialView.delegate = self;
    self.interstitialView.AdUnitTag = networkConfig.pubId2;
    //百度插屏的类型 other
    interstitialView.interstitialType = BaiduMobAdViewTypeInterstitialOther;
    
    [interstitialView load];
    [self.adInstlManager adapter:self requestString:@"req"];
    
    return YES;
}

- (BOOL)showAdInstl:(UIViewController *)controller
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    if (nil == controller || ![controller isViewLoaded] || [controller isBeingDismissed]) {
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
#else
    if (nil == controller || ![controller isViewLoaded]) {
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
#endif

    if (interstitialView.isReady) {
        [interstitialView presentFromRootViewController:self.adInstlController];
    }else {
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
    }

    return YES;
}

- (NSString *)publisherId
{
    NSString * appId = self.networkConfig.pubId;
    return  appId;
}

- (NSString*) appSpec
{
    NSString *appSecretId = self.networkConfig.pubId2;
    return appSecretId;
}

// 渠道id
- (NSString*) channelId
{
    return @"e498eab7";
}

-(BOOL) enableLocation
{
    //启用location会有一次alert提示
    return [self isOpenGps];
}

//广告预加载成功
- (void)interstitialSuccessToLoadAd:(BaiduMobAdInterstitial *)interstitial
{

    [self.adInstlManager adapter:self requestString:@"suc"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}

//广告预加载失败
- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)interstitial
{
    [self.adInstlManager adapter:self requestString:@"fail"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
}

//广告即将展示
- (void)interstitialWillPresentScreen:(BaiduMobAdInterstitial *)interstitial
{
    [self.adInstlManager adapter:self requestString:@"show"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
}

//广告展示成功
- (void)interstitialSuccessPresentScreen:(BaiduMobAdInterstitial *)interstitial{
    
}

//广告展示失败
- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)interstitial withError:(BaiduMobFailReason) reason
{
    NSError *errorMessage = nil;
    if (reason == BaiduMobFailReason_NOAD)
        errorMessage = [NSError errorWithDomain:@"没有推广返回" code:0 userInfo:nil];
    else
        errorMessage = [NSError errorWithDomain:@"网络或其他原因" code:0 userInfo:nil];
    
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:errorMessage];
    [self.adInstlManager adapter:self requestString:@"fail"];
    AWLogInfo(@"baidu insterinitl is fail ");
}

//广告展示结束
- (void)interstitialDidDismissScreen:(BaiduMobAdInterstitial *)interstitial
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

-(void)stopBeingDelegate
{
//    AWLogInfo(@"baidu insterinitl is dealloc %d",[self.interstitialView retainCount]);
    
    self.interstitialView.delegate = nil;
    self.interstitialView = nil;
    self.adInstlController = nil;
}

@end
