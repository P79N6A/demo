//
//  AdInstlAdapterGuoHe.m
//  AdInstlSDK_iOS
//
//  Created by Ma ming on 13-5-16.
//
//

#import "AdInstlAdapterGuoHe.h"
#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"

@implementation AdInstlAdapterGuoHe

+ (AdInstlAdNetworkType)networkType {
    return AdInstlAdNetworkTypeGuoHe;
}

+ (void)load {
    if(NSClassFromString(@"GuoHeadInterstitialSDK") != nil) {
		[[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
	}
}

- (BOOL)loadAdInstl:(UIViewController *)controller {
    Class GHAdViewClass = NSClassFromString(@"GuoHeadInterstitialSDK");
    if (GHAdViewClass == nil) return NO;

    NSString * appID = self.networkConfig.pubId;
    
    [GHAdViewClass configInterstitialSDKWithAppKey:appID];
    
    [GHAdViewClass preloadInterstitialWithDelegate:self withPlace:nil];
    
    [self.adInstlManager adapter:self requestString:@"req"];
    
    return YES;
}

- (BOOL)showAdInstl:(UIViewController *)controller {
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
    [GuoHeadInterstitialSDK displayInterstitialWithDelegate:self withPlace:nil withCurrentViewController:controller];
    
    return YES;
}

#pragma mark Delegate
/**
 *  预加载成功的回调
 */
- (void)ghInterstitialSDKDidCacheSuccessWithPlace:(NSString *)place{
    [self.adInstlManager adapter:self requestString:@"suc"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
    
}

/**
 *  预加载失败的回调
 */
- (void)ghInterstitialSDKDidCacheFailureWithPlace:(NSString *)place{
    [self.adInstlManager adapter:self requestString:@"fail"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
}

/**
 *  展示插屏成功的回调
 *  可以在此时暂停游戏声音等游戏界面的操作
 */
- (void)ghInterstitialSDKDidShowSuccessWithPlace:(NSString *)place{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidShowAd error:nil];
}

/**
 *  展示插屏失败的回调
 */
- (void)ghInterstitialSDKDidShowFailureWithPlace:(NSString *)place{
    [self.adInstlManager adapter:self requestString:@"fail"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
}

/**
 *  点击插屏内容触发跳转的回调
 */
- (void)ghInterstitialSDKDidClickedWithPlace:(NSString *)place{
    [self.adInstlManager adapter:self requestString:@"click"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
}

/**
 *  被广告被关闭的回调，有两个时机：
 *  1、插屏展示成功之后，点击了关闭按钮触发
 *  2、点击了插屏内容跳转之后，再返回您的界面的时候触发
 *
 *  可以在此时重新开启游戏声音等游戏界面的操作
 */
- (void)ghInterstitialSDKDidClosedWithPlace:(NSString *)place{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

/**
 *  没有插屏活动可展示了的回调
 */
- (void)ghInterstitialSDKNoActivityWithPlace:(NSString *)place{}

- (void)stopBeingDelegate {
    AWLogInfo(@"GuoHe dealloced");
}

@end
