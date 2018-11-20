//
//  AdInstlAdapterJDAview.m
//  AdViewAll
//
//  Created by 周桐 on 15/11/20.
//  Copyright © 2015年 unakayou. All rights reserved.
//

#import "AdInstlAdapterJDAdview.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewExtraManager.h"
#import "AdInstlManagerImpl.h"

@implementation AdInstlAdapterJDAdview

+ (AdInstlAdNetworkType)networkType
{
    return AdInstlAdNetworkTypeJDAdview;
}

+ (void)load
{
    if(NSClassFromString(@"JDAdManager") != nil)
    {
        [[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
    }
}

- (BOOL)loadAdInstl:(UIViewController *)controller
{
    Class JDInstlClass = NSClassFromString(@"JDAdManager");
    if (nil == JDInstlClass) return NO;
    
    [self.adInstlManager adapter:self requestString:@"req"];
    
    JDAdAppInfo *appInfo = [[JDAdAppInfo alloc] init];
    appInfo.keywords = @"金融，财会";
    
    JDAdUser *userinfo = [[JDAdUser alloc] initJDAdUserWithGender:JDAdGenderFemale yob:@"1983" keywords:@"白领" segments:@"1,3,5"];
    
    [JDAdManager shareManager].isHttp = YES;
    [JDAdManager shareManager].istest = NO;
    [JDAdManager shareManager].app = appInfo;
    [JDAdManager shareManager].user = userinfo;
    [JDAdManager shareManager].adDelegate = self;
    [JDAdManager shareManager].adViewDelegate = self;
    
    _jdInstl = [[JDAdManager shareManager] createModalAds:JDAdSize_Modal_320_480 withRootViewController:controller canClose:YES andTagid:self.networkConfig.pubId];
    
//    [self performSelector:@selector(didLoad:) withObject:controller afterDelay:3];
    
    return YES;
}
//- (void)didLoad:(UIViewController*)controller{
//    
//    [self.adInstlManager adapter:self requestString:@"suc"];
//    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
//}
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
    if (self.jdInstl != nil)
    {
        [self.jdInstl popView];
        return YES;
    }
    return NO;
}
- (void)dealloc
{
    
}
- (void)stopBeingDelegate
{
    [JDAdManager shareManager].adDelegate = nil;
    [JDAdManager shareManager].adViewDelegate = nil;
    self.jdInstl = nil;
}

#pragma mark -  delegate
- (void)ad:(JDAd*)ad networkErrorState:(JDAdURLResponseStatus)state{
    if (JDAdURLResponseStatusSuccess != state) {
        AWLogInfo(@"JDModalAdView fail ");
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];

    }
}
- (void)ad:(JDAd*)ad loadWithError:(JDAdError)error{
    [self.adInstlManager adapter:self requestString:@"fail"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
}
//点击代理
- (void)adViewDidClicked:(JDAdView*)adView{
    [self.adInstlManager adapter:self requestString:@"click"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
} //banner，插屏都适用

//插屏代理
- (void)modalViewDidLoadSuccess:(JDModalAdView*)modalView{
    AWLogInfo(@"JDModalAdView DidLoadSuccess");
    [self.adInstlManager adapter:self requestString:@"suc"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}
//- (void)modalView:(JDModalAdView*)modal didLoadWithError:(NSError *)error{
//    AWLogInfo(@"JDModalAdView fail %@",[error description]);
//    [self.adInstlManager adapter:self requestString:@"fail"];
//    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:error];
//}

@end
