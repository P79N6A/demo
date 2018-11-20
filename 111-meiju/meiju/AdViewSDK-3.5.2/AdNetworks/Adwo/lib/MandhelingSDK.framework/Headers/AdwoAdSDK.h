//
//  AdwoAdSDK.h
//  Adwo SDK 6.7
//
//  Created by zenny_chen on 12-8-17.
//  Copyright (c) 2011～2015 Adwo, Inc All rights reserved.
//
/////////////////////// NOTES /////////////////////////////

/**
 * !!IMPORTANT!!
 * 本次SDK将仅支持XCode6.0或更高版本，支持iOS 8.3，并且最低支持iOS 6.0系统。
 * 注意！本SDK以及附属的Demo属于本公司机密，未经许可不得擅自发布！
 * Release Notes：
 * 在AWAdViewDelegate中增加了必须实现的adwoGetBaseViewController接口。
 * 必须添加的框架：
 * AdSupport.framework
 * AudioToolbox.framework
 * AVFoundation.framework
 * CoreMedia.framework
 * CoreMotion.framework
 * CoreTelephony.framework
 * EventKit.framework
 * MessageUI.framework
 * PassKit.framework
 * QuartzCore.framework
 * StoreKit.framework
 * SystemConfiguration.framework
 * Social.framework（将required变为optional）
*/

@import UIKit;


/** Adwo Ad SDK版本号的数值表示 */
#define ADWO_SDK_VERSION                    0x6C

/** Adwo Ad SDK版本号的字符串表示 */
#define ADWO_SDK_VERSION_STRING             @"6.93"

//混淆代码
#if 1

#define AWAdViewDelegate  LUWAK_AssDelegate
#define adwoGetBaseViewController   LUWAK_GetBaseViewController
#define adwoAdViewDidFailToLoadAd   LUWAK_DidFailToLoadAss
#define adwoAdViewDidLoadAd         LUWAK_DidLoadAss
#define adwoFullScreenAdDismissed   LUWAK_ShitDismissed
#define adwoDidPresentModalViewForAd    LUWAK_DidPresentModalViewForAss
#define adwoDidDismissModalViewForAd    LUWAK_DidDismissModalViewForAss
#define adwoUserClosedImplantAd     LUWAK_GodClosedGoldenAss
#define adwoUserClosedBannerAd      LUWAK_GodClosedSilverAss
#define adwoAdRequestShouldPause    LUWAK_AssShouldPause
#define adwoAdRequestMayResume      LUWAK_AssMayResume
#define adwoAdNotifyToFetchBonus LUWAK_NotifyToFetchBonus
#define adwoUserClosedVideoAd LUWAK_UserClosedVideoAd
#define adwoUserPlayVideoAd LUWAK_UserPlayVideoAd

#define AWSocialShareDelegate       LUWAK_Ass_ShareDelegate
#define adwoSocialShareMessage      LUWAK_HeavenShareMessage

#define adwoAdStopBannerAutoRefresh LUWAK_StopBannerAutoRefresh
#define AdwoAdCreateBanner  LUWAK_CreateBanner
#define AdwoAdRemoveAndDestroyBanner    LUWAK_RemoveAndDestroyBanner
#define AdwoAdLoadBannerAd  LUWAK_LoadBannerAss
#define AdwoAdAddBannerToSuperView  LUWAK_AddBannerToSuperView
#define AdwoAdGetBannerRequestInterval  LUWAK_GetBannerRequestInterval
#define AdwoAdGetFullScreenAdHandle LUWAK_GetFullScreenAssHandle
#define AdwoAdLoadFullScreenAd  LUWAK_LoadFullScreenAss
#define AdwoAdShowFullScreenAd  LUWAK_ShowFullScreenAss
#define AdwoAdSetGroundSwitchAdAutoToShow   LUWAK_SetGroundSwitchAssAutoToShow
#define AdwoAdGetFullScreenRequestInterval  LUWAK_GetFullScreenRequestInterval
#define AdwoAdCreateImplantAd   LUWAK_CreateImplantAss
#define AdwoAdRemoveAndDestroyImplantAd LUWAK_RemoveAndDestroyImplantAss
#define AdwoAdLoadImplantAd LUWAK_LoadImplantAss
#define AdwoAdShowImplantAd LUWAK_ShowImplantAss
#define AdwoAdImplantAdActivate LUWAK_mplantAssActivate
#define AdwoAdSetImplantAdInteractiveInfo   LUWAK_SetImplantAssInteractiveInfo
#define AdwoAdGetImplantRequestInterval LUWAK_GetImplantRequestInterval
#define AdwoAdGetLatestErrorCode    LUWAK_GetLatestErrorCode
#define AdwoAdSetAdAttributes   LUWAK_SetAssAttributes
#define AdwoAdSetKeywords   LUWAK_SetKeywords
#define AdwoAdSetDelegate   LUWAK_SetDelegate
#define AdwoAdGetAdInfo LUWAK_GetAssInfo
#define AdwoAdGetCurrentAdID    LUWAK_GetCurrentAssID
#define AdwoAdRegisterSocialShareDelegate   LUWAK_RegisterSocialShareDelegate
#define AdwoAdReceiveSocialShareResult  LUWAK_ReceiveSocialShareResult
#define AdwoAdLaunchETA LUWAK_LaunchETA

#define AdwoUtilities LUWAK_Utilities
#define AdwoStringOnData    AWStringOnData
#define AdwoGetIntegerOnDataReverse AWGetIntegerOnDataReverse
#define AdwoGetIntegerOnData  AWGetIntegerOnData
#define AdwoGetDoubleOnData AWGetDoubleOnData

#define AdwoLaunchingAdInfo LUWAK_LaunchingAssInfo
#define AdwoFSAdShowInfo    LUWAK_FSAssShowInfo

#endif



/** 如果你的程序工程中没有包含CoreLocation.frameowrk，
 * 那么把下面这个宏写到你的AppDelegate.m或ViewController.m中类实现的上面空白处。
 * 如果已经包含了CoreLocation.framework，那么请不要在其它地方写这个宏。
 * 注意：这个宏不能写在类中，也不能写在函数或方法中。详细用法请参考AdwoSDKBasic这个Demo～
*/
#define ADWO_SDK_WITHOUT_CORE_LOCATION_FRAMEWORK(...)    \
@interface CLLocationManager : NSObject             \
                                                    \
@end                                                \
                                                    \
@implementation CLLocationManager                   \
                                                    \
@end                                                \
                                                    \
double kCLLocationAccuracyBest = 0.0;

/** 如果你不想添加PassKit.framework，那么需要在你的ViewController.m或AppDelegate.m中加入这个宏
 * 详细用法请参考AdwoSDKBasic这个Demo～
*/
#define ADWO_SDK_WITHOUT_PASSKIT_FRAMEWORK(...)     \
@interface PKAddPassesViewController : NSObject     \
@end                                                \
                                                    \
@implementation PKAddPassesViewController           \
@end                                                \
                                                    \
@interface PKPass : NSObject                        \
                                                    \
@end                                                \
                                                    \
@implementation PKPass                              \
                                                    \
@end


#define ADWOSDK_DUMMYLAUNCHINGAD_VIEW_TAG           0x542B

#define ADWOADSDK_MAX_ETA_AD_SIZES           8


/** Adwo Ad SDK 错误码 */
enum ADWO_ADSDK_ERROR_CODE
{
    // General error code
    /** 操作成功 */
    ADWO_ADSDK_ERROR_CODE_SUCCESS,
    /** 广告对象初始化失败 */
    ADWO_ADSDK_ERROR_CODE_INIT_FAILED,
    /** 已经用当前广告对象调用了加载接口 */
    ADWO_ADSDK_ERROR_CODE_AD_HAS_BEEN_LOADED,
    /** 不该为空的参数为空 */
    ADWO_ADSDK_ERROR_CODE_NULL_PARAMS,
    /** 参数值非法 */
    ADWO_ADSDK_ERROR_CODE_ILLEGAL_PARAMETER,
    /** 非法广告对象句柄 */
    ADWO_ADSDK_ERROR_CODE_ILLEGAL_HANDLE,
    /** 代理为空或adwoGetBaseViewController方法没实现 */
    ADWO_ADSDK_ERROR_CODE_ILLEGAL_DELEGATE,
    /** 非法的广告对象句柄引用计数 */
    ADWO_ADSDK_ERROR_CODE_ILLEGAL_ADVIEW_RETAIN_COUNT,
    /** 意料之外的错误 */
    ADWO_ADSDK_ERROR_CODE_UNEXPECTED_ERROR,
    /** 广告请求太过频繁 */
    ADWO_ADSDK_ERROR_CODE_AD_REQUEST_TOO_OFTEN,
    /** 广告加载失败 */
    ADWO_ADSDK_ERROR_CODE_LOAD_AD_FAILED,
    /** 广告已经被加载或展示过 */
    ADWO_ADSDK_ERROR_CODE_AD_HAS_BEEN_SHOWN,
    /** 全屏广告还没准备好展示 */
    ADWO_ADSDK_ERROR_CODE_FS_AD_NOT_READY_TO_SHOW,
    /** 全屏广告资源破损 */
    ADWO_ADSDK_ERROR_CODE_FS_RESOURCE_DAMAGED,
    /** 开屏全屏广告正在请求 */
    ADWO_ADSDK_ERROR_CODE_FS_LAUNCHING_AD_REQUESTING,
    /** 当前全屏已设置为自动展示 */
    ADWO_ADSDK_ERROR_CODE_FS_ALREADY_AUTO_SHOW,
    /** 当前事件触发型广告已被禁用 */
    ADWO_ADSDK_ERROR_CODE_ETA_DISABLED,
    /** 没找到相应合法尺寸的事件触发型广告 */
    ADWO_ADSDK_ERROR_CODE_ETA_SIZE_INVALID,
    
    // Server request relevant error code
    /** 服务器繁忙 */
    ADWO_ADSDK_ERROR_CODE_REQUEST_SERVER_BUSY,
    /** 当前没有广告 */
    ADWO_ADSDK_ERROR_CODE_REQUEST_NO_AD,
    /** 未知请求错误 */
    ADWO_ADSDK_ERROR_CODE_REQUEST_UNKNOWN_ERROR,
    /** PID不存在 */
    ADWO_ADSDK_ERROR_CODE_REQUEST_INEXIST_PID,
    /** PID未被激活 */
    ADWO_ADSDK_ERROR_CODE_REQUEST_INACTIVE_PID,
    /** 请求数据有问题 */
    ADWO_ADSDK_ERROR_CODE_REQUEST_REQUEST_DATA,
    /** 接收到的数据有问题 */
    ADWO_ADSDK_ERROR_CODE_REQUEST_RECEIVED_DATA,
    /** 当前IP下广告已经投放完 */
    ADWO_ADSDK_ERROR_CODE_REQUEST_NO_AD_IP,
    /** 当前广告都已经投放完 */
    ADWO_ADSDK_ERROR_CODE_REQUEST_NO_AD_POOL,
    /** 没有低优先级广告 */
    ADWO_ADSDK_ERROR_CODE_REQUEST_NO_AD_LOW_RANK,
    /** 开发者在Adwo官网注册的Bundle ID与当前应用的Bundle ID不一致 */
    ADWO_ADSDK_ERROR_CODE_REQUEST_BUNDLE_ID,
    /** 服务器响应出错 */
    ADWO_ADSDK_ERROR_CODE_REQUEST_RESPONSE_ERROR,
    /** 设备当前没连网络，或网络信号不好 */
    ADWO_ADSDK_ERROR_CODE_REQUEST_NETWORK_CONNECT,
    /** 请求URL出错 */
    ADWO_ADSDK_ERROR_CODE_REQUEST_INVALID_REQUEST_URL
};

/** Adwo Ad banner size */
enum ADWO_ADSDK_BANNER_SIZE
{
    /** Banner types for iPhone/iPod Touch 
     *
     * The default size is 320x50
    */
    ADWO_ADSDK_BANNER_SIZE_NORMAL_BANNER = 1,
    
    /** For banner on iPad
     *
     * The size is 320x50
    */
    ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_320x50 = 10,
    
    /** For banner on iPad
     *
     * The size is 720x110
     */
    ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_720x110
};

/** 应用发布渠道 */
enum ADWOSDK_SPREAD_CHANNEL
{
    /** App Store发布 */
    ADWOSDK_SPREAD_CHANNEL_APP_STORE,
    
    /** 非App Store渠道 */
    ADWOSDK_SPREAD_CHANNEL_91_STORE
};

/** 广告聚合SDK */
enum ADWOSDK_AGGREGATION_CHANNEL
{
    /** 未使用任何聚合SDK */
    ADWOSDK_AGGREGATION_CHANNEL_NONE,
    /** 果核SDK */
    ADWOSDK_AGGREGATION_CHANNEL_GUOHEAD,
    /** AdView SDK */
    ADWOSDK_AGGREGATION_CHANNEL_ADVIEW,
    /** 芒果SDK */
    ADWOSDK_AGGREGATION_CHANNEL_MOGO,
    /** AdWhirl SDK */
    ADWOSDK_AGGREGATION_CHANNEL_ADWHIRL,
    /** 艾德思奇SDK */
    ADWOSDK_AGGREGATION_CHANNEL_ADSAGE,
    /** AdMob SDK */
    ADWOSDK_AGGREGATION_CHANNEL_ADMOB,
    /** 一搜SDK */
    ADWOSDK_AGGREGATION_CHANNEL_YISOU = 8
};

/** 全屏广告展示形式ID */
enum ADWOSDK_FSAD_SHOW_FORM
{
    /** App Fun插页式全屏广告加品牌全屏广告（App Fun优先） */
    ADWOSDK_FSAD_SHOW_FORM_APPFUN_WITH_BRAND,
    /** 应用启动后立即展示全屏广告 */
    ADWOSDK_FSAD_SHOW_FORM_LAUNCHING,
    /** 后台切换到前台后立即显示全屏广告 */
    ADWOSDK_FSAD_SHOW_FORM_GROUND_SWITCH,
    /** App Fun插页式全屏广告 */
    ADWOSDK_FSAD_SHOW_FORM_APPFUN,
    /** 品牌插页式全屏 */
    ADWOSDK_FSAD_SHOW_FORM_BRAND,
    
    /** 当前全屏广告种类个数（开发者不应该直接使用此枚举常量） */
    ADWOSDK_FSAD_SHOW_FORM_COUNT
};

/** 植入性广告展示形式ID */
enum ADWOSDK_IMAD_SHOW_FORM
{
    /** 普通植入性广告 */
    ADWOSDK_IMAD_SHOW_FORM_COMMON,
    
    /** 视频激励性广告 */
    ADWOSDK_IMAD_SHOW_FORM_VIDEO,
    
    /** ETA类型声纹广告 */
    ADWOSDK_IMAD_ETA_VOICEPRINT_FORM,
    
    /** ETA类型iBeacon广告 */
    ADWOSDK_IMAD_ETA_IBEACON_FORM,
    
    /** 植入性广告种类个数（开发者不应该直接使用此枚举常量）*/
    ADWOSDK_IMAD_SHOW_FORM_COUNT
};

/** Banner动画类型 */
enum ADWO_ANIMATION_TYPE
{
    // Animation moving
    
    /** 由Adwo服务器来控制动画类型 */
    ADWO_ANIMATION_TYPE_AUTO,
    /** 无动画，直接切换 */
    ADWO_ANIMATION_TYPE_NONE,
    /** 从左到右的推移 */
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_LEFT,
    /** 从右到左推移 */
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_RIGHT,
    /** 从下到上推移 */
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_BOTTOM,
    /** 从上到下推移 */
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_TOP,
    /** 新广告从左到右移动，并覆盖在老广告条上 */
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_LEFT,
    /** 新广告从右到左移动，并覆盖在老广告条上 */
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_RIGHT,
    /** 新广告从下到上移动，并覆盖在老广告条上 */
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_BOTTOM,
    /** 新广告从上到下移动，并覆盖在老广告条上 */
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_TOP,
    
    /** 淡入淡出 */
    ADWO_ANIMATION_TYPE_CROSS_DISSOLVE,
    
    // Animation transition
    
    /** 向上翻页 */
    ADWO_ANIMATION_TYPE_CURL_UP,
    /** 向下翻页 */
    ADWO_ANIMATION_TYPE_CURL_DOWN,
    /** 从左到右翻页 */
    ADWO_ANIMATION_TYPE_FLIP_FROMLEFT,
    /** 从右到左翻页 */
    ADWO_ANIMATION_TYPE_FLIP_FROMRIGHT
};

/** 全屏广告动画类型 */
enum ADWO_SDK_FULLSCREEN_ANIMATION_TYPE
{
    /** 由Adwo服务器来控制动画类型 */
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_AUTO,
    /** 无动画，直接出现消失 */
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_NONE,
    /** 从左到右出现消失 */
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_LEFT_TO_RIGHT,
    /** 从右到左出现消失 */
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_RIGHT_TO_LEFT,
    /** 从底到顶出现消失 */
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_BOTTOM_TO_TOP,
    /** 从顶到底出现消失 */
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_TOP_TO_BOTTOM,
    /** 水平方向伸缩出现消失 */
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_SCALE_LEFT_RIGHT,
    /** 垂直方向伸缩出现消失 */
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_SCALE_TOP_BOTTOM,
    /** 淡入淡出 */
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_CROSS_DISSOLVE,
};


@protocol AWAdViewDelegate <NSObject>

@required

/**
 * @brief 当SDK需要弹出自带的Browser以显示mini site时需要使用当前广告所在的控制器。
 * @warning AWAdView的delegate必须被设置，并且此接口必须被实现。
 * @return 一个视图控制器对象
*/
- (UIViewController* __nonnull)adwoGetBaseViewController;

@optional

/**
 * @brief 捕获当前加载广告失败通知。当你所创建的广告视图对象请求广告失败后，SDK将会调用此接口来通知。参数adView指向当前请求广告的广告对象句柄。开发者可以通过errorCode属性来查询失败原因。
*/
- (void)adwoAdViewDidFailToLoadAd:(UIView* __nonnull)adView;

/**
 * @brief 捕获广告加载成功通知。当你广告加载成功时，SDK将会调用此接口。参数adView指向当前请求广告的广告对象句柄。这个接口对于全屏广告展示而言，一般必须实现以捕获可以展示全屏广告的时机。
*/
- (void)adwoAdViewDidLoadAd:(UIView* __nonnull)adView;

/**
 * @brief 当全屏广告被关闭时，SDK将调用此接口。一般而言，当全屏广告被用户关闭后，开发者应当将当前全屏广告对象置空，使其无效化。对于全屏广告而言，没有提供给开发者的释放接口，所有回收工作由SDK自行处理。若开发者要在此接口中重新创建新的全屏广告对象，至少延迟3秒。
*/
- (void)adwoFullScreenAdDismissed:(UIView* __nonnull)adView;

/**
 * @brief 当SDK弹出自带的全屏展示浏览器时，将会调用此接口。参数adView指向当前请求广告对象句柄。这里需要注意的是，当adView弹出全屏展示浏览器时，此adView不允许被释放，否则会导致SDK崩溃。
*/
- (void)adwoDidPresentModalViewForAd:(UIView* __nonnull)adView;

/**
 * @brief 当SDK自带的全屏展示浏览器被用户关闭后，将会调用此接口。参数adView指向当前请求广告对象句柄。
*/
- (void)adwoDidDismissModalViewForAd:(UIView* __nonnull)adView;

/**
 * @brief 用户点击植入性广告的关闭按钮之后，SDK将会发出此消息。参数adView指向当前请求广告对象句柄。在此消息中，开发者可以调用AdwoAdRemoveAndDestroyImplantAd接口。
 */
- (void)adwoUserClosedImplantAd:(UIView* __nonnull)adView;

/**
 * @brief 用户点击横幅广告的关闭按钮之后，SDK将会发出此消息。参数adView指向当前请求广告对象句柄。在此消息中，开发者可以调用AdwoAdRemoveAndDestroyBanner接口来移除Banner广告。
 */
- (void)adwoUserClosedBannerAd:(UIView* __nonnull)adView;
/**
 * @brief 当用户观看视频激励广告并获取积分时回调此方法，开发者可以在此回调中送分。
 */
- (void)adwoAdNotifyToFetchBonus:(UIView* __nonnull)adView andScore:(int)score;
/**
 * @brief 当用户点击广告触发某些事件时，需要暂停广告请求，此时SDK会发送此消息来通知开发者不要去释放当前的广告对象也不要去请求新的广告。
 */
- (void)adwoAdRequestShouldPause:(UIView* __nonnull)adView;

/**
 * @brief 表示当前SDK需要暂停的事件已经完成，开发者接收到此消息之后可以释放当前的广告对象。对于Banner可以重新请求。
 */
- (void)adwoAdRequestMayResume:(UIView* __nonnull)adView;

/**
 * @brief 当用户关闭视频广告时的回调。
 * @param forceClose 1：用户强制关闭视频，0：用户正常至少已观看完一次视频。
 */
- (void)adwoUserClosedVideoAd:(int)forceClose adView:(UIView* __nonnull)adView;

/**
 * @brief 用户点击广告播放视频时回调此方法。
 * @param
 */
- (void)adwoUserPlayVideoAd:(UIView* __nonnull)adView;

@end


@protocol AWSocialShareDelegate <NSObject>

@required

/**
 * @brief 分享指定消息到指定社区的代理
 * @param shareInfo: 分享信息。这是一个字典类型，根据不同的分享社区，key的名称也有可能不同。
 * @param socialName: 指明了当前要把指定消息分享到哪个社区。
*/
- (void)adwoSocialShareMessage:(NSDictionary* __nonnull)shareInfo social:(NSString* __nonnull)socialName;

@end


// 偏好属性设置
struct AdwoAdPreferenceSettings
{    
    int adSlotID;                                   // 广告位ID（仅用于Banner与植入性广告）
    unsigned animationType;                         // 动画类型
    enum ADWOSDK_SPREAD_CHANNEL spreadChannel;      // 渠道类型（App Store、91等）
    BOOL disableGPS;                                // 是否禁用GPS
    BOOL unclickable;                               // 广告是否不可点击
    CGSize userSpecAdSize;                          // 开发者指定广告尺寸
};


#ifdef __cplusplus
extern "C" {
#endif
/**
  *获取当前是否可通过ETA广告的标志
  *如果返回YES，则App可以打开麦克风或其他外设收事件信号，否则请勿打开麦克风等外设
 */
extern BOOL AdwoCanRequestETAAds(void);
    
    
/**
 * @brief 停止Banner广告自动轮询刷新。这个接口一般适用于广告SDK的聚合。
 * @attention 请注意，这个接口必须在创建Banner之后，加载Banner之前调用。
*/
extern void adwoAdStopBannerAutoRefresh(void);

/**
 * @brief 创建一条Banner广告
 * @param pid 申请一个应用后，页面返回出来的广告发布ID（32个ASCII码字符）。
 * @param showFormalAd 是否展示正式广告。如果传NO，表示使用测试模式，SDK将给出测试广告；如果传YES，那么SDK将给出正式广告。
 * @param delegate AWAdViewDelegate代理。应用开发者应该将展示本SDK Banner的视图控制器实现AWAdViewDelegate代理，并且将视图控制器对象传给此参数。此参数不能为空。注意，此参数不会被retain。
 * @return 如果返回为空，表示广告初始化创建失败，开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。如果创建成功，则返回一个UIView对象，作为广告对象句柄。
*/
extern UIView* __nullable AdwoAdCreateBanner(NSString* __nonnull pid, BOOL showFormalAd, id<AWAdViewDelegate> __nonnull delegate);

/**
 * @brief 移除并销毁Banner广告
 * @param adView Banner对象句柄
 * @return 如果销毁成功，返回YES；否则，返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdRemoveAndDestroyBanner(UIView* __nonnull adView);

/**
 * @brief 当完成初始化和相关设置之后，调用此方法来加载Banner广告。
 * @param adView Banner对象句柄
 * @param bannerSize 指定当前的Banner尺寸。如果是用于iPhone、iPod Touch，那么使用ADWO_ADSDK_BANNER_SIZE_NORMAL_BANNER即可，该尺寸为320x50；如果是用于iPad，那么可以指定ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_320x50和ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_720x110两种尺寸。
 * @param pRemainInterval 指向剩余请求时间间隔的变量指针
 * @return 如果操作成功，返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。当这个接口返回后，Banner未必加载成功，开发者必须通过AWAdViewDelegate代理中的adwoAdViewDidLoadAd方法来捕获Banner是否加载成功。
 * @attention 这里要注意的是，广告对象应该被加到一个控制器的根视图中，即其大小撑满整个屏幕，否则某些广告展示形式可能会影响父视图的尺寸。
*/
extern BOOL AdwoAdLoadBannerAd(UIView* __nonnull adView, enum ADWO_ADSDK_BANNER_SIZE bannerSize, NSTimeInterval* __nullable pRemainInterval);

/**
 * @brief 将当前的Banner广告对象添加到用户指定的父视图上
 * @param adView Banner对象句柄
 * @param superView 用户指定的父视图
 * @return 如果操作成功，返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。当这个接口返回后，Banner未必加载成功，开发者必须通过AWAdViewDelegate代理中的adwoAdViewDidLoadAd方法来捕获Banner是否加载成功。
*/
extern BOOL AdwoAdAddBannerToSuperView(UIView* __nonnull adView, UIView* __nonnull superView);

/**
 * @brief 获取当前Banner广告的最小请求间隔时间
 * @return 当前Banner广告的最小请求间隔时间
*/
extern NSTimeInterval AdwoAdGetBannerRequestInterval(void);

/**
 * @brief 获取全屏广告对象句柄
 * @param pid 申请一个应用后，页面返回出来的广告发布ID（32个ASCII码字符）。
 * @param showFormalAd 是否展示正式广告。如果传NO，表示使用测试模式，SDK将给出测试广告；如果传YES，那么SDK将给出正式广告。
 * @param delegate AWAdViewDelegate代理。应用开发者应该将展示本SDK Banner的视图控制器实现AWAdViewDelegate代理，并且将视图控制器对象传给此参数。此参数不能为空。
 * @param fsAdForm 全屏广告类型。详情可见ADWOSDK_FSAD_SHOW_FORM枚举在值的定义
 * @return 全屏广告句柄。
 * @attention 这个接口由SDK自动管理全屏广告对象，因此开发者不需要自己释放全屏广告对象
*/
extern UIView* __nullable AdwoAdGetFullScreenAdHandle(NSString* __nonnull pid, BOOL showFormalAd, id<AWAdViewDelegate> __nonnull delegate, enum ADWOSDK_FSAD_SHOW_FORM fsAdForm);

/**
 * @brief 加载全屏广告
 * @param fsAd 全屏广告对象句柄
 * @param orientationLocked 应用是否锁定了屏幕方向。如果当前应用在展示全屏广告的时候仅支持横屏或竖屏，那么传YES；如果横竖屏都支持且会切换，则传NO
 * @param pRemainInterval 指向剩余请求时间间隔的变量指针
 * @return 若加载成功返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * @discussion 如果fsAdForm为ADWOSDK_FSAD_SHOW_FORM_LAUNCHING，那么错误码可能为ADWO_ADSDK_ERROR_CODE_FS_LAUNCHING_AD_REQUESTING。
 * 这表示当前SDK正在请求开屏全屏广告资源，因此开发者不需要等待广告加载，可以直接做自己后面的作业；如果返回YES，说明开屏全屏广告已经有加载好的资源，此时可以进行展示
 */
extern BOOL AdwoAdLoadFullScreenAd(UIView* __nonnull fsAd, BOOL orientationLocked, NSTimeInterval* __nullable pRemainInterval);

/**
 * @brief 展示全屏广告
 * @param fsAd 全屏广告对象句柄
 * @return 若展示成功，则返回YES，否则，返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdShowFullScreenAd(UIView* __nonnull fsAd);

/**
 * @brief 设置是否自动展示后台切换到前台全屏广告
 * @param fsAd 全屏广告对象句柄
 * @param autoToShow 是否自动展示。如果为YES，则当应用从后台切换到前台时，倘若此时后台切换到前台全屏广告已加载好，则由SDK自动展示；若为NO，则SDK不会自动展示，交给开发者来调用AdwoAdShowFullScreenAd接口展示全屏
 * @return 若展示成功，则返回YES，否则，返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * @attention 默认情况下，SDK会自动展示后台切换到前台广告。若当前为自动展示，那么开发者手工对后台切换到前台调用AdwoAdShowFullScreenAd接口将会返回NO，同时给出ADWO_ADSDK_ERROR_CODE_FS_ALREADY_AUTO_SHOW的错误码
*/
extern BOOL AdwoAdSetGroundSwitchAdAutoToShow(UIView* __nonnull fsAd, BOOL autoToShow);

/**
 * @brief 获取当前所指定类型的全屏广告的最小请求间隔时间
 * @param fsAdType——所指定的全屏广告类型
 * @return 当前全屏广告的最小请求间隔时间
*/
extern NSTimeInterval AdwoAdGetFullScreenRequestInterval(enum ADWOSDK_FSAD_SHOW_FORM fsAdType);

/**
 * @brief 创建植入性广告
 * @param pid 申请一个应用后，页面返回出来的广告发布ID（32个ASCII码字符）。
 * @param showFormalAd 是否展示正式广告。如果传NO，表示使用测试模式，SDK将给出测试广告；如果传YES，那么SDK将给出正式广告。
 * @param delegate AWAdViewDelegate代理。应用开发者应该将展示本SDK Banner的视图控制器实现AWAdViewDelegate代理，并且将视图控制器对象传给此参数。此参数不能为空。注意，此参数不会被retain。
 * @param adInfo 广告信息。开发者可以设置指定广告信息来请求自己想要的广告植入性广告。如果设置为空或者非有效的字符串，则由服务器来决定给出相应广告。注意，这个参数会被retain，因此如果字符串实参使用alloc分配的话，在调用完这个接口之后需要release一次。
 * @return 如果返回为空，表示广告初始化创建失败，开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。如果创建成功，则返回一个UIView对象，作为广告对象句柄。
*/
extern UIView* __nullable AdwoAdCreateImplantAd(NSString* __nonnull pid, BOOL showFormalAd, id<AWAdViewDelegate> __nonnull delegate, NSString* __nullable adInfo,enum ADWOSDK_IMAD_SHOW_FORM imAdForm);

/**
 * @brief 移除并销毁植入性广告
 * @param adView 植入性广告对象句柄
 * @return 如果销毁成功，返回YES；否则，返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 */
extern BOOL AdwoAdRemoveAndDestroyImplantAd(UIView* __nonnull adView);

/**
 * @brief 加载植入性广告
 * @param adView 植入性广告对象句柄
 * @param pRemainInterval 指向剩余请求时间间隔的变量指针
 * @return 若加载成功返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 */
extern BOOL AdwoAdLoadImplantAd(UIView* __nonnull adView, NSTimeInterval* __nullable pRemainInterval);

/**
 * @brief 展示植入性广告
 * @param adView——植入性广告对象句柄
 * @param theSuperview 植入性广告视图将被添加到的父视图
 * @return 若加载成功返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdShowImplantAd(UIView* __nonnull adView, UIView* __nonnull theSuperview);

/**
 * @brief 激活植入性广告
 * @discussion 当展示了植入性广告之后，开发者可以在适当时机调用此接口来激活植入性广告。倘若植入性广告具有动画、播放音视频等效果的话，
 * 那么往往通过调用这个接口来激活这些动态行为。
 * @param adView 植入性广告对象句柄
 * @return 若加载成功返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdImplantAdActivate(UIView* __nonnull adView);

/**
 * @brief 设置能与植入性广告内容进行互动的应用信息
 * @discussion 当开发者输入一些简短的字符串信息之后，某些定制的植入性广告将以某种方式将开发者传入的信息展示在广告页面上
 * @param adView 植入性广告对象句柄
 * @param info 指定的应用互动信息
 * @return 若加载成功返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * @attention 这个接口可以在任意时候调用。如果当前广告已经展示，那么重新设置新的信息将会刷新广告页面内容
*/
extern BOOL AdwoAdSetImplantAdInteractiveInfo(UIView* __nonnull adView, NSString* __nullable info);

/**
 * @brief 获取当前植入性广告的最小请求间隔时间
 * @return 当前植入性广告的最小请求间隔时间
 */
extern NSTimeInterval AdwoAdGetImplantRequestInterval(void);

/**
 * @brief 获取最近的错误码。具体错误码请参考ADWO_ADSDK_ERROR_CODE
 * @return 错误码枚举值
*/
extern enum ADWO_ADSDK_ERROR_CODE AdwoAdGetLatestErrorCode(void);

/**
 * @brief 设置广告对象属性。这个接口对所有广告类型（包括Banner和各类全屏等）都适用
 * @param adView 广告对象句柄
 * @param settings 设置结构体
 * @return 如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * @warning 该接口应该在广告加载之前使用。
*/
extern BOOL AdwoAdSetAdAttributes(UIView* __nonnull adView, const struct AdwoAdPreferenceSettings* __nonnull settings);

/**
 * @brief 设置关键字。关键字一般由应用自己决定，并且一般需要与本SDK进行一个合作交互。
 * 因此普通开发者可以不用关心此接口
 * @param adView 广告对象句柄
 * @param keywords 关键字字符串
 * @return 如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * @warning 该接口应该在广告加载之前使用。此外，keywords对象会被retain，因此调用好这个接口之后，如果你的keywords是被alloc出来的，则需要调用一次release。
*/
extern BOOL __attribute__((overloadable)) AdwoAdSetKeywords(UIView* __nonnull adView, NSString* __nonnull keywords);

/**
 * @brief 从关键字字典获取关键字字符串
 * @brief 以字典来设置关键字的方式方便开发者进行数据处理，此接口允许开发者传定义好的字典对象
 * @param keywordsDict 关键字字典对象
 * @return 如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * @warning 该接口应该在广告加载之前使用。此外，keywords对象会被retain，因此调用好这个接口之后，如果你的keywords是被alloc出来的，则需要调用一次release。
*/
extern BOOL __attribute__((overloadable)) AdwoAdSetKeywords(UIView* __nonnull adView, NSDictionary* __nonnull keywords);

/**
 * @brief 对当前广告视图对象设置代理对象
 * @param adView 广告对象句柄
 * @param delegate AWAdViewDelegate代理。应用开发者应该将展示本SDK广告的视图控制器实现AWAdViewDelegate代理，并且将视图控制器对象传给此参数。此参数不能为空。注意，此参数不会被retain。
 * @return 如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdSetDelegate(UIView* __nonnull adView, id<AWAdViewDelegate> __nonnull delegate);

/**
 * @brief 获取当前广告信息
 * @param adView 广告对象句柄
 * @return 如果成功，则返回当前广告信息。如果失败，则返回空，开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * @discussion 开发者可以在获得AWAdViewDelegate代理的adwoAdViewDidLoadAd通知之后来获取此广告相关的广告信息。如果为空字符串，说明当前广告并无特别信息。
*/
extern NSString* __nullable AdwoAdGetAdInfo(UIView* __nonnull adView);

/**
 * @brief 获取当前广告ID
 * @param adView 广告对象句柄
 * @param pAdID 指向输出的存放广告ID变量的指针。若所得到的广告ID为-1，说明当前广告请求尚未成功。
 * @return 如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdGetCurrentAdID(UIView* __nonnull adView, int* __nullable pAdID);

/**
 * @brief 注册社区分享代理
 * 这个接口可用于注册多个代理，使得SDK能做指定的社区分享。目前支持微信（WeChat）
 * @param delegate 接收负责分享指定信息到指定社区消息的对象代理
 * @param socialName 这个是本SDK定义好的字符串。@"WeChat"表示此代理用于负责接收分享到微信的消息通知
 * @warning 当调用这个接口之后，参数delegate对象会被retain一次。因此，当你要释放这个delegate的时候，请传空来调用此接口一次，如：AdwoAdRegisterSocialShareDelegate(nil, @"WeChat");使得代理对象delegate能被最终释放掉
*/
extern void AdwoAdRegisterSocialShareDelegate(id<AWSocialShareDelegate> __nonnull delegate, NSString* __nonnull socialName);

/**
 * @brief 社区分享的结果响应
 * @discussion 当社区分享完成之后，第三方应用程序调用此接口来通知SDK端分享的结果
 * @param adView 当前广告对象句柄
 * @param result 分享的结果。YES表示分享成功；NO表示分享失败
 * @param socialName 社区名，比如"WeChat"表示微信社区
*/
extern void AdwoAdReceiveSocialShareResult(UIView* __nonnull adView, BOOL result, NSString*__nonnull socialName);


#ifdef __cplusplus
}
#endif

