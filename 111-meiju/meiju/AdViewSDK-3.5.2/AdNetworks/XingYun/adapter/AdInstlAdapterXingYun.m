//
//  AdInstlAdapterXingYun.m
//  AdViewAll
//
//  Created by 张宇宁 on 14-12-10.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//

#import "AdInstlAdapterXingYun.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewExtraManager.h"
#import "AdInstlManagerImpl.h"
@interface AdInstlAdapterXingYun ()
@end


@implementation AdInstlAdapterXingYun
@synthesize gunInitServer;
@synthesize pobAppFrame;

+ (AdInstlAdNetworkType)networkType
{
    return AdInstlAdNetworkTypeXingYun;
}
//@"PobAppFrame"是嵌入广告类的类名
//sharedInstlRegistry插屏
//sharedBannerRegistry横幅
//sharedSpreadScreenRegistry开屏
+ (void)load
{
    if (NSClassFromString(@"PobAppFrame") != nil) {
        [[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
    }
}

- (BOOL)loadAdInstl:(UIViewController *)controller
{
    Class XingYunInstlClass = NSClassFromString(@"PobAppFrame");
    Class XingYunInstlServer = NSClassFromString(@"GuInitServer");
    if(nil == XingYunInstlClass) return NO;
    if (nil == XingYunInstlServer) return NO;
    if (controller == nil) return NO;
    self.rootController = controller;
    //从后台接受AppID
    NSString *appID = self.networkConfig.pubId;
    //实例化
    self.gunInitServer = [[XingYunInstlServer alloc] init];
    [self.gunInitServer setInfo:appID Channel:@"" User_info:@""];
    //请求广告
    self.pobAppFrame = [[XingYunInstlClass alloc] orientation:@"Portrait" andDelegate:self];
    //向AdView服务器发送请求汇报，方便开发者查看
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
    if (self.pobAppFrame)
    {
        //广告展示
        [self.pobAppFrame showpobFrame:self.rootController];
        return YES;
    }
    return NO;
}
- (void)dealloc
{
    AWLogInfo(@"AdInstlAdapterXingYun dealloc");
}

#pragma mark delegate
//插屏弹出成功
- (void)showPobFrameSucess
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
    [self.adInstlManager adapter:self requestString:@"show"];
}

//插屏弹出失败
- (void)showPobFrameFail
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
    [self.adInstlManager adapter:self requestString:@"fail"];
}

//插屏关闭
- (void)closePobAppFrame
{
    if (self.pobAppFrame) {
        self.pobAppFrame = nil;
    }
    if (self.gunInitServer) {
        self.gunInitServer = nil;
    }
    if (self.rootController) {
        self.rootController = nil;
    }
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

//获取数据成功
- (void)initPobFrameSuccess
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
    [self.adInstlManager adapter:self requestString:@"suc"];
}

//获取数据失败
- (void)initPobFrameFail
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
    [self.adInstlManager adapter:self requestString:@"fail"];
}

- (void)stopBeingDelegate
{
    AWLogInfo(@"xingyun stop being delegate");
    if (self.pobAppFrame) {
        self.pobAppFrame = nil;
    }
    if (self.gunInitServer) {
        self.gunInitServer = nil;
    }
    if (self.rootController) {
        self.rootController = nil;
    }
}
@end
