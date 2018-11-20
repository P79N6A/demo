/*
 *  AdSpreadScreenManagerDelegate.h
 *  AdSpreadScreenSDK_iOS
 *
 *  Created by zhiwen on 12-12-27.
 *  Copyright 2012 www.adview.cn. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
@class AdSpreadScreenManager;

typedef enum {
    AdSpreadScreenShowPositionTop = 1,
    AdSpreadScreenShowPositionBottom,
}AdSpreadScreenShowPosition;

typedef enum
{
    SpreadScreenEventType_None = 0,
    SpreadScreenEventType_StartLoadAd,
    SpreadScreenEventType_DidLoadAd,
    SpreadScreenEventType_FailLoadAd,
    SpreadScreenEventType_WillPresentAd,
    SpreadScreenEventType_DidDismissAd,
    SpreadScreenEventType_WillPresentModal,    //like inline browser view.
    SpreadScreenEventType_DidDismissModal,
    
    SpreadScreenEventType_DidShowAd,
    SpreadScreenEventType_DidClickAd,
}SpreadScreenEventType;

typedef enum {
    AdSpreadScreenLoadType_Loading = 0,
    AdSpreadScreenLoadType_DidLoadAd,
    AdSpreadScreenLoadType_FailLoadAd,
    AdSpreadScreenLoadType_PresentAd,
    AdSpreadScreenLoadType_NotInit,
} AdSpreadScreenLoadType;

NSString *AdSpreadScreenEventType_Name(SpreadScreenEventType type);

@protocol AdSpreadScreenManagerDelegate<NSObject>

@optional
/**
 * 信息回调
 */
- (void)adSpreadScreenManager:(AdSpreadScreenManager*)manager didGetEvent:(SpreadScreenEventType)eType error:(NSError*)error;
/**
 * 取得配置的回调通知
 */
- (void)adSpreadScreenDidReceiveConfig:(AdSpreadScreenManager*)manager;

/**
 * 配置全部无效或为空的通知
 */
- (void)adSpreadScreenReceivedNotificationAdsAreOff:(AdSpreadScreenManager*)manager;

/**
 * 是否打开测试模式，缺省为NO
 */
- (BOOL)adSpreadScreenTestMode;

/**
 * 是否打开日志模式，缺省为NO
 */
- (BOOL)adSpreadScreenLogMode;

/**
 * 是否获取地理位置，缺省为NO
 */
- (BOOL)adSpreadScreenOpenGps;

/**
 * 是否使用html5广告，缺省为NO
 */
- (BOOL)adSpreadScreenUsingHtml5;

/**
 * 是否使用应用内打开AppStore，缺省为NO
 */
- (BOOL)adSpreadUsingSKStoreProductViewController;

/**
 * 开屏背景颜色
 */
- (UIColor*)adSpreadScreenBackgroundColor;
/**
 * 开屏背景图片的名字
 */
- (NSString*)adSpreadScreenBackgroundImgName;
/**
 * 开屏显示的位置，AdSpreadScreenShowPositionTop->位置居上;AdSpreadScreenShowPositionBottom->位置居下
 */
- (AdSpreadScreenShowPosition)adSpreadScreenShowPosition;
/**
 * 开屏底部logo图片的名字
 */
- (NSString*)adSpreadScreenLogoImgName;

- (UIWindow*)adSpreadScreenWindow;

@end
