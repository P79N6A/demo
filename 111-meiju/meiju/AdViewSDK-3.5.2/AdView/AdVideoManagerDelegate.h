//
//  Header.h
//  AdViewDevelop
//
//  Created by maming on 16/9/8.
//  Copyright © 2016年 maming. All rights reserved.
//

@class AdVideoManager;

typedef enum
{
    VideoEventType_None = 0,
    VideoEventType_StartLoadAd,
    VideoEventType_DidLoadAd,
    VideoEventType_FailLoadAd,
    VideoEventType_FailShow,
    VideoEventType_Close_PlayEnd,
    VideoEventType_Close_Playing,
    VideoEventType_StartPlay,
    VideoEventType_EndPlay,
    VideoEventType_DidClickAd,
}VideoEventType;

typedef enum {
    AdVideoLoadType_Loading = 0,
    AdVideoLoadType_DidLoadAd,
    AdVideoLoadType_FailLoadAd,
    AdVideoLoadType_PresentAd,
    AdVideoLoadType_NotInit,
} AdVideoLoadType;

@protocol AdVideoManagerDelegate<NSObject>

@optional
/**
 * 信息回调
 */
- (void)adVideoManager:(AdVideoManager*)manager didGetEvent:(VideoEventType)eType error:(NSError*)error;

/**
 * 
 */
- (void)adVideoManager:(AdVideoManager*)manager videoAvailable:(BOOL)avilable;

/**
 * 是否打开测试模式，缺省为NO
 */
- (BOOL)adVideoTestMode;

/**
 * 是否打开日志模式，缺省为NO
 */
- (BOOL)adVideoLogMode;

/**
 * 是否获取地理位置，缺省为NO
 */
- (BOOL)adVideoOpenGps;

///**
// * 是否使用html5广告，缺省为NO
// */
//- (BOOL)adVideoUsingHtml5;

/**
 * 是否使用应用内打开AppStore，缺省为NO
 */
- (BOOL)adVideoUsingSKStoreProductViewController;

@end