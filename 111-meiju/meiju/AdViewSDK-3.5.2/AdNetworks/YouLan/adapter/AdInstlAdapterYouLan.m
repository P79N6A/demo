//
//  AdInstlAdapterGDTMob.m
//  AdInstlSDK_iOS
//
//  Created by ZhongyangYu on 14-9-28.
//
//

#import "AdInstlAdapterYouLan.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewExtraManager.h"
#import "AdInstlManagerImpl.h"
#import "YLSdkManager.h"


@implementation AdInstlAdapterYouLan


+ (AdInstlAdNetworkType)networkType
{
    return AdInstlAdNetworkTypeYouLan;
}

+ (void)load
{
    if(NSClassFromString(@"YLIntersitial") != nil)
    {
        [[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
    }
}

- (BOOL)loadAdInstl:(UIViewController *)controller
{
    Class AderInstlClass = NSClassFromString(@"YLIntersitial");
    if (nil == AderInstlClass) return NO;
    self.isReady = NO;

    [self.adInstlManager adapter:self requestString:@"req"];
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGFloat width = size.width;
    CGFloat height = size.width * 250 /320;
    CGRect viewFrame = CGRectMake(0, 0, width, height);
    
    // sdk设置
    // 此clientId由幽蓝分配
    [YLSdkManager setClientId:networkConfig.pubId];
    
    // ID
    self.intersitial =[YLIntersitial initAdWithAdSpaceId:networkConfig.pubId2 adSize:CGSizeMake(300, 250) delegate:self frame:viewFrame];

    //@"1044"
    
    //预加载广告
    [self.intersitial startRequest];
    
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
    if (self.isReady)
    {
        self.intersitial.center = controller.view.center;
        [controller.view addSubview:self.intersitial];
        [self.adInstlManager adapter:self requestString:@"show"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
        return YES;
    }
    return NO;
}

#pragma mark - YouLan delegate

- (void)onClick:(UIView *)adView{
    [self.adInstlManager adapter:self requestString:@"click"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
    
}
- (void)onAdSucessed:(UIView *)adView{
    self.isReady = YES;
    [self.adInstlManager adapter:self requestString:@"suc"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}
- (void)onAdFailed:(UIView *)adView{
    
    [self.adInstlManager adapter:self requestString:@"fail"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
    
}
- (void)onAdClose{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}
- (void)browserClosed{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissModal error:nil];
}



- (void)stopBeingDelegate
{
    self.intersitial = nil;
}

@end
