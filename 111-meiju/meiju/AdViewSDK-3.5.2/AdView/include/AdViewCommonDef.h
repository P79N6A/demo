//
//  AdCommonDef.h
//  AdViewDevelop
//
//  Created by laizhiwen on 14-11-5.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#ifndef AdViewDevelop_AdCommonDef_h
#define AdViewDevelop_AdCommonDef_h

#define ADVIEW_VERSION_STR @"350"

#define ARC4RANDOM_MAX 0x100000000

#import "AdCommonNetworkType.h"
#import <UIKit/UIKit.h>

//和SDKTYPE匹配
typedef enum tagAdViewSDKType {
    AdViewSDKType_Banner = 0,
    AdViewSDKType_Instl = 1,
    AdViewSDKType_SpreadScreen = 4,
    AdViewSDKType_Native = 6,
    AdViewSDKType_Video = 7,
}AdViewSDKType;

BOOL isForeignAd(AdViewSDKType sdkType, int networkType);

#endif

#define REPORT_KEY @"S5PWyZU2qkyUFbSNQpgizBbUFwyYb567"

#define USER_TEST_SERVER			0

#define DEBUG_INFO					0

#if USER_TEST_SERVER		//test server, ip server

#define kAdViewDefaultReportMetricURL   @"https://test2014.adview.cn/agent/reportData.php"
//banner
#define kAdViewDefaultConfigURL                 @"https://test2014.adview.cn/agent/agent1.php"
#define kAdViewDefaultCustomAdURL               @"https://test2014.adview.cn/agent/custom.php"

//adinstl
#define kAdInstlDefaultConfigURL                @"https://test2014.adview.cn/agent/adinstl_config.php"
#define kAdInstlDefaultCustomAdURL              @"https://test2014.adview.cn/agent/custom.php"

//adspread
#define kAdSpreadScreenDefaultConfigURL         @"https://test2014.adview.cn/agent/spreadscreen_config.php"
#define kAdSpreadScreenDefaultCustomAdURL       @"https://test2014.adview.cn/agent/custom.php"

//adnative
#define kAdNativeDefaultConfigURL               @"https://test2014.adview.cn/agent/adNative_config.php"
#define kAdNativeDefaultCustomAdURL             @"https://test2014.adview.cn/agent/custom.php"

//advideo
#define kAdVideoDefaultConfigURL               @"https://test2014.adview.cn/agent/video_config.php"
#define kAdVideoDefaultCustomAdURL             @"https://test2014.adview.cn/agent/custom.php"

#define CONFIG_REACH_CHECK		0		//现在的check针对ip:124.207.233.116不可行，域名估计没问题

#else

#define kAdViewDefaultReportMetricURL   @"https://report.adview.cn/agent/reportData.php"

//banner
#define kAdViewDefaultConfigURL         @"https://config.adview.cn/agent/agent1.php"
#define kAdViewDefaultCustomAdURL       @"https://report.adview.cn/agent/custom.php"

//adinstl
#define kAdInstlDefaultConfigURL        @"https://config.adview.cn/agent/adinstl_config.php"
#define kAdInstlDefaultCustomAdURL		@"https://report.adview.cn/agent/custom.php"

//adspread
#define kAdSpreadScreenDefaultConfigURL			@"https://config.adview.cn/agent/spreadscreen_config.php"
#define kAdSpreadScreenDefaultCustomAdURL		@"https://report.adview.cn/agent/custom.php"

//adnative
#define kAdNativeDefaultConfigURL			@"https://config.adview.cn/agent/adNative_config.php"
#define kAdNativeDefaultCustomAdURL			@"https://report.adview.cn/agent/custom.php"

//advideo
#define kAdVideoDefaultConfigURL			@"https://config.adview.cn/agent/video_config.php"
#define kAdVideoDefaultCustomAdURL			@"https://report.adview.cn/agent/custom.php"

#define CONFIG_REACH_CHECK		1		//现在的check针对ip:adview，域名估计没问题, laizhiwen

#endif

#define kAdViewReportMetricURLFmt   @"https://%@/agent/reportData.php"

#define KCONFIG_FAIL_NOTIFICATION @"Config_Fail_Notification_%d"
#define KCONFIG_SUCCESS_NOTIFICATION @"Config_Success_Notification_%d"

#define kAWMinimumTimeBetweenFreshAdRequests    2.9f
#define KADVIEW_PUBLISH_CHANNEL_APPSTORE @"AppStore"
#define KADVIEW_PUBLISH_CHANNEL_CYDIA @"Cydia"
#define KADVIEW_PUBLISH_CHANNEL_91Store @"91Store"
#define kAdViewConfigRegetTimeInteval   1200
