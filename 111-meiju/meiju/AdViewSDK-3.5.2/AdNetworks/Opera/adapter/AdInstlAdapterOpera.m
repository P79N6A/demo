//
//  AdInstlAdapterGDTMob.m
//  AdInstlSDK_iOS
//
//  Created by ZhongyangYu on 14-9-28.
//
//

#import "AdInstlAdapterOpera.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewExtraManager.h"
#import "AdInstlManagerImpl.h"
#import "OperaAdManager.h"

@implementation AdInstlAdapterOpera

+ (AdInstlAdNetworkType)networkType
{
    return AdInstlAdNetworkTypeOpera;
}

+ (void)load
{
    if(NSClassFromString(@"PosterAdView") != nil)
    {
        [[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
    }
}

- (BOOL)loadAdInstl:(UIViewController *)controller
{
    Class InstlClass = NSClassFromString(@"PosterAdView");
    if (nil == InstlClass) return NO;

    [self.adInstlManager adapter:self requestString:@"req"];

    NSString * appKey = self.networkConfig.pubId;//@"1702075038";//
    [[OperaAdManager getInstance] setAdvertiseInfo:@"adview"];
    
    _operaInstl = [[PosterAdView alloc] initPosteradSize:OperaPosterAdSizeNormal slotToken:appKey];
    _operaInstl.delegate = self;
    
//    [self performSelector:@selector(didLoad:) withObject:controller afterDelay:2];
    
    return YES;
}
- (void)didLoad:(UIViewController*)controller{
    [self.adInstlManager adapter:self requestString:@"suc"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
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
    [self.operaInstl showPosterAd];
    return YES;
}

#pragma mark - Opera delegate
/**
 * @brief PosterAd poster 请求数据成功
 * @param PosterAd
 */
-(void)operaPosterAdRequestSuccessed:(PosterAdView *)PosterAd{
    [self.adInstlManager adapter:self requestString:@"suc"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}
/**
 * @brief PosterAd poster 请求数据失败
 * @param PosterAd
 */
-(void)operaPosterAdRequestFailure:(PosterAdView *)PosterAd error:(NSString *)error{
    [self.adInstlManager adapter:self requestString:@"fail"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:[NSError errorWithDomain:error code:0 userInfo:nil]];
}
/**
 * @brief PosterAd poster 展示成功
 * @param PosterAd
 */
-(void)operaPosterAdShowSuccessed:(PosterAdView *)PosterAd{
    [self.adInstlManager adapter:self requestString:@"show"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
}
//

/**
 * @brief bannerAd poster 广告被点击
 * @param bannerAd
 */
-(void)operaPosterAdClick:(PosterAdView *)PosterAd{
    [self.adInstlManager adapter:self requestString:@"click"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
}

/**
 * @brief bannerAd poster 广告被关闭
 * @param bannerAd
 */
-(void)OperaPosterAdClose:(PosterAdView *)PosterAd{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

- (void)stopBeingDelegate
{
    self.operaInstl.delegate = nil;
    self.operaInstl = nil;
}

@end
