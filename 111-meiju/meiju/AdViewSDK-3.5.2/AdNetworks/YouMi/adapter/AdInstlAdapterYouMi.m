//
//  AdInstlAdapterYouMi.m
//  AdInstlSDK_iOS
//
//  Created by adview on 13-6-5.
//
//

#import "AdInstlAdapterYouMi.h"
#import "adViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "adViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"
//#import "YouMiNewSpot.h"
#import "ConfigHeader.h"

@implementation AdInstlAdapterYouMi

+ (AdInstlAdNetworkType)networkType {
    return AdInstlAdNetworkTypeYoumi;
}

+ (void)load
{
    if(NSClassFromString(@"NewWorldSpt") != nil) {
		[[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
	}
}

- (BOOL)loadAdInstl:(UIViewController *)controller
{
    //    Class YouMiSpotClass = NSClassFromString(@"YouMiSpot");
    //    Class YouMiConfigClass = NSClassFromString(@"YouMiConfig");
    //    if (YouMiSpotClass == nil) return NO;
    //    if (YouMiConfigClass == nil) return NO;
    //    if (controller == nil) return NO;
    
    NSString * appId = self.networkConfig.pubId;
    NSString * appSecretId = self.networkConfig.pubId2;
    
    //如果报错请在.pch文件中添加 #import "youmispotconfuse.h"
    
    [NewWorldSpt initQQWDeveloperParams:appId QQ_SecretId:appSecretId];
    
    [NewWorldSpt initQQWDeveLoper:kTypeBoth];
    
    [NewWorldSpt clickQQWSPTAction:^(BOOL flag) {
        // 点击插屏广告的回调,点击成功,flag为YES,否则为NO
        [self clickYouMiSpot];
    }];
//    [YouMiNewSpot initYouMiDeveLoperSpot:kSPOTSpotTypePortrait];
    [self.adInstlManager adapter:self requestString:@"req"];
    
    //如果报错请在.pch文件中添加 #import "youmispotconfuse.h"
    
    [self performSelector:@selector(didLoad) withObject:nil afterDelay:0.5];
    
    return YES;
}

- (void)didLoad {
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}

- (void)clickYouMiSpot
{
    [self.adInstlManager adapter:self requestString:@"click"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];

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
    [self.adInstlManager adapter:self requestString:@"suc"];
    // 显示插屏广告，有显示返回YES且flag也为YES.没显示返回NO且flag也为NO，dismiss为广告点关闭后的回调。
    BOOL bRet = [NewWorldSpt showQQWSPTAction:^(BOOL flag) {
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
    }];
    
    if (bRet == NO)
    {
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
    else
    {
        [self.adInstlManager adapter:self requestString:@"show"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
    }
    return YES;
}

- (void)stopBeingDelegate {
    AWLogInfo(@"YouMi delloced");
}

@end
