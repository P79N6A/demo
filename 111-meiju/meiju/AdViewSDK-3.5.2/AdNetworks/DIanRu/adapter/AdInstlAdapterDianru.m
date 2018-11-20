//
//  AdInstlAdapterDianru.m
//  AdInstlSDK_iOS
//
//  Created by adview on 14-2-25.
//
//

#import "AdInstlAdapterDianru.h"

#import "adViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "adViewAdNetworkRegistry.h"
#import "adViewExtraManager.h"
#import "AdInstlManagerImpl.h"

@implementation AdInstlAdapterDianru

@synthesize drView;
@synthesize rootController;

+ (AdInstlAdNetworkType)networkType
{
    return AdInstlAdNetworkTypeDianRu;
}

+ (void)load
{
	if(NSClassFromString(@"ZSDK") != nil)
    {
		[[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
	}
}

- (BOOL)loadAdInstl:(UIViewController*)controller
{
    Class dianRuInstlClass = NSClassFromString(@"ZSDK");
	if(nil == dianRuInstlClass) return NO;
    if (controller == nil) return NO;
    self.rootController = controller;
    
    BOOL bUseGPS = [self isOpenGps];
    
    AD_INIT(self.networkConfig.pubId, bUseGPS, nil, AD_INSERSCREEN)
    AD_CREATE(AD_INSERSCREEN, self)
//    AD_SHOW(AD_INSERSCREEN, self.rootController, self)
    [self.adInstlManager adapter:self requestString:@"req"];

    return YES;
}

- (BOOL)showAdInstl:(UIViewController*)controller
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    BOOL isNotPresent = (![controller isViewLoaded] || [controller isBeingDismissed] || [controller isMovingFromParentViewController]);
#else
    BOOL isNotPresent = ![controller isViewLoaded];
#endif
    if (nil == controller || isNotPresent) {
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
    
    if (nil != self.drView)
    {
        [self.rootController.view addSubview:self.drView];
        [self.adInstlManager adapter:self didGetEvent: InstlEventType_WillPresentAd error:nil];
        [self.adInstlManager adapter:self requestString:@"show"];
    }
    return YES;
    
}


#pragma mark DianRuSDK Delegate

/**
 *  请求广告列表失败
 *
 *  @param object 回调的对象，如果通过AD_CREATE创建或者广告类型是banner，object就是view。否则object就是viewController
 */
- (void)DidLoadFail:(id)object
{
    self.drView = nil;
    [self.adInstlManager adapter:self requestString:@"fail"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
    AWLogInfo(@"DIANRU DidLoadFail");
}

/**
 *  数据列表回调
 *
 *  @param object 回调的对象，如果通过DR_CREATE创建或者广告类型是banner，object就是view。否则object就是viewController
 *  @param code 广告条数大于0，那么code=0，代表成功 反之code = -1
 */
- (void)DidDataReceived:(id)object
                   Code:(int)code{
    if (code != 0){
        self.drView = nil;
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        AWLogInfo(@"DIANRU DidDataReceived Fail");
        
    }else{
        if (object) self.drView = (UIView *)object;
        
        [self.adInstlManager adapter:self requestString:@"suc"];
        [self.adInstlManager adapter:self didGetEvent: InstlEventType_DidLoadAd error:nil];
        AWLogInfo(@"DIANRU DidDataReceived");
    }

}

/**
 *  点击广告
 *
 *  @param object 广告详细信息
 */
- (void)DidViewClick:(id)object data:(id)data{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
}

/**
 *  关闭回调
 *
 *  @param object 回调的对象，如果通过DR_CREATE创建或者广告类型是banner，object就是view。否则object就是viewController
 */
- (void)DidViewClose:(id)object{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

/**
 *  广告销毁
 *
 *  @param object 回调的对象，如果通过DR_CREATE创建或者广告类型是banner，object就是view。否则object就是viewController
 */
- (void)DidViewDestroy:(id)object{
    
}


///*
// 广告弹出时回调
// */
//- (void)dianruDidViewOpenView:(UIView *)view
//{
//    if (nil != view)
//    {
//        self.adView = view;
//    }
//}
//
///*
// 点击广告关闭按钮的回调，不代表广告从内存中释放
// */
//- (void)dianruDidMainCloseView:(UIView *)view
//{
//    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
//}
//
///*
// 广告释放时回调，从内从中释放
// */
//- (void)dianruDidViewCloseView:(UIView *)view
//{
//    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
//}
//
///*
// 曝光回调
// */
//- (void)dianruDidReportedView:(UIView *)view dianruData:(id)data
//{
//    
//}
//
///*
// 点击广告回调
// */
//- (void)dianruDidClickedView:(UIView *)view dianruData:(id)data
//{
//    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
//}
//
///*
// 点击跳转回调
// */
//- (void)dianruDidJumpedView:(UIView *)view dianruData:(id)data
//{
//    
//}

- (void)stopBeingDelegate
{
    AWLogInfo(@"DianRu stopBeingDelegate");
    self.drView = nil;
//    self.adInstlManager = nil;
    self.rootController = nil;
}


@end
