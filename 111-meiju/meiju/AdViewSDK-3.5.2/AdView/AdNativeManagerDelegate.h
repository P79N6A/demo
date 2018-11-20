/*
 *  AdNativeManagerDelegate.h
 *  AdNativeSDK_iOS
 *
 *  Created by zhiwen on 12-12-27.
 *  Copyright 2012 www.adview.cn. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
@class AdNativeManager;

typedef enum
{
    AdNativeReportType_None = 0,
    AdNativeReportType_Request,
    AdNativeReportType_Impression,
    AdNativeReportType_Click,
}AdNativeReportType;

typedef enum {
    AdNativeLoadType_Loading = 0,
    AdNativeLoadType_DidLoadAd,
    AdNativeLoadType_FailLoadAd,
    AdNativeLoadType_PresentAd,
    AdNativeLoadType_NotInit,
} AdNativeLoadType;

//NSString *AdNativeEventType_Name(NativeEventType type);

@protocol AdNativeManagerDelegate<NSObject>

@optional
/**
 * 用来弹出目标页的ViewController，一般为当前ViewController
 */
- (UIViewController*)viewControllerForPresentingModalView;

/**
 * 信息回调
 */
- (void)requestNativeAdSuccessed:(AdNativeManager*)manager adInfo:(NSArray*)adviewNativeAdArray;
- (void)requestNativeAdFailed:(AdNativeManager*)manager error:(NSError*)error;

/**
 * 取得配置的回调通知
 */
- (void)adNativeDidReceiveConfig:(AdNativeManager*)manager;

/**
 * 配置全部无效或为空的通知
 */
- (void)adNativeReceivedNotificationAdsAreOff:(AdNativeManager*)manager;

/**
 * 是否打开测试模式，缺省为NO
 */
- (BOOL)adNativeTestMode;

/**
 * 是否打开日志模式，缺省为NO
 */
- (BOOL)adNativeLogMode;

/**
 * 是否获取地理位置，缺省为NO
 */
- (BOOL)adNativeOpenGps;
//
///**
// * 是否使用html5广告，缺省为NO
// */
//- (BOOL)adNativeUsingHtml5;

@end