//
//  AdInstlAdapterGDTMob.m
//  AdInstlSDK_iOS
//
//  Created by ZhongyangYu on 14-9-28.
//
//

#import "AdInstlAdapterGDTMob.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewExtraManager.h"
#import "AdInstlManagerImpl.h"

@implementation AdInstlAdapterGDTMob

@synthesize GDTMobInstl = _GDTMobInstl;

+ (AdInstlAdNetworkType)networkType
{
    return AdInstlAdNetworkTypeGDTMob;
}

+ (void)load
{
    if(NSClassFromString(@"GDTMobInterstitial") != nil)
    {
        [[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
    }
}

- (BOOL)loadAdInstl:(UIViewController *)controller
{
    Class AderInstlClass = NSClassFromString(@"GDTMobInterstitial");
    if (nil == AderInstlClass) return NO;

    [self.adInstlManager adapter:self requestString:@"req"];

    NSString * appKey = self.networkConfig.pubId;//@"2211675583";
    NSString * placementId = self.networkConfig.pubId2;//@"2030814134092814";
    _GDTMobInstl = [[GDTMobInterstitial alloc] initWithAppkey:appKey placementId:placementId];
    
    self.GDTMobInstl.delegate = self; //设置委托
    self.GDTMobInstl.isGpsOn = [self isOpenGps]; //【可选】设置GPS开关
    
    //预加载广告
    [self.GDTMobInstl loadAd];
    
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
    if (self.GDTMobInstl.isReady)
    {
        [self.GDTMobInstl presentFromRootViewController:controller];
        return YES;
    }
    return NO;
}

#pragma mark - GTDMob delegate
/**
 *  广告预加载成功回调
 *  详解:当接收服务器返回的广告数据成功后调用该函数
 */
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial
{
    [self.adInstlManager adapter:self requestString:@"suc"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}

/**
 *  广告预加载失败回调
 *  详解:当接收服务器返回的广告数据失败后调用该函数
 */
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error
{
    AWLogInfo(@"GDT fail %@",[error description]);
    [self.adInstlManager adapter:self requestString:@"fail"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:error];
}

/**
 *  插屏广告将要展示回调
 *  详解: 插屏广告即将展示回调该函数
 */
- (void)interstitialWillPresentScreen:(GDTMobInterstitial *)interstitial
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
}

/**
 *  插屏广告视图展示成功回调
 *  详解: 插屏广告展示成功回调该函数
 */
- (void)interstitialDidPresentScreen:(GDTMobInterstitial *)interstitial
{
    [self.adInstlManager adapter:self requestString:@"show"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidShowAd error:nil];
}

/**
 *  插屏广告展示结束回调
 *  详解: 插屏广告展示结束回调该函数
 */
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用到后台
 */
- (void)interstitialApplicationWillEnterBackground:(GDTMobInterstitial *)interstitial
{}

/**
 *  插屏广告曝光回调
 */
- (void)interstitialWillExposure:(GDTMobInterstitial *)interstitial
{}

/**
 *  插屏广告点击回调
 */
- (void)interstitialClicked:(GDTMobInterstitial *)interstitial
{
    [self.adInstlManager adapter:self requestString:@"click"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
}

- (BOOL) isOpenGps {
    if ([adInstlManager.delegate respondsToSelector:@selector(adInstlOpenGps)])
        return [adInstlManager.delegate adInstlOpenGps];
    return NO;
}


- (void)stopBeingDelegate
{
    self.GDTMobInstl.delegate = nil;
    self.GDTMobInstl = nil;
}

@end
