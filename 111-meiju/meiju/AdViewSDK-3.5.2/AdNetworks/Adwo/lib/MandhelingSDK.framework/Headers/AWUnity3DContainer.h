//
//  AWUnity3DContainer.h
//  AdwoAdSDK
//
//  Created by Zenny Chen on 15/6/29.
//  Copyright (c) 2015年 adwo. All rights reserved.
//

#import "AdwoAdSDK.h"

@interface AWUnity3DContainer : NSObject

@end

/**
 * 用于Unity3D游戏引擎安沃广告的广告类型
*/
enum AWU3D_AD_TYPE
{
    /** banner类型 */
    AWU3D_AD_TYPE_BANNER,
    
    /** 插屏广告 */
    AWU3D_AD_TYPE_APP_FUN,
    
    /** 开屏广告 */
    AWU3D_AD_TYPE_LAUNCHING,
    
    /** 后台切换到前台广告 */
    AWU3D_AD_TYPE_GROUND_SWITCH,
    
    /** 信息流广告 */
    AWU3D_AD_TYPE_IMPLANT_INFO_STREAM,
    
    /** 视频激励广告 */
    AWU3D_AD_TYPE_IMPLANT_VIDEO_BOUNS,
    
    /** 当前提供给Unity3D所支持的广告种类个数（开发者不要直接使用此常量）*/
    AWU3D_AD_TYPE_COUNT
};

/**
 * 回调函数接口：
 * function awAdViewDidFailToLoadAd(adType:string)——当广告加载失败时给目标发送此消息，adType为AWU3D_AD_TYPE中的值
 *
 * function awAdViewDidLoadAd(adType:string)——当广告加载成功后会给目标发送此消息，adType为AWU3D_AD_TYPE中的值
 *
 * function awFullScreenAdDismissed(adType:string)——当全屏广告退出时会给目标发送此消息，adType为AWU3D_AD_TYPE中的值
 *
 * function awDidPresentModalViewForAd(adType:string)——当广告SDK弹出minisite框时会给目标发送此消息。adType为AWU3D_AD_TYPE中的值
 *
 * function awDidDismissModalViewForAd(adType:string)——当广告SDK所弹出的minisite框退出时给目标发送消息。adType为AWU3D_AD_TYPE中的值
 *
 * function awUserClosedImplantAd(adType:string)——当用户关闭植入性广告之后，SDK会给当前目标发送此消息。adType为AWU3D_AD_TYPE中的值
 *
 * function awUserClosedBannerAd(adType:string)——当用户关闭Banner后，SDK会给当前目标发送此消息。adType为AWU3D_AD_TYPE中的值
 *
 * function awAdNotifyToFetchBonus(score:string)——当用户观看完视频激励广告并获得奖励之后，SDK向当前目标发送此消息。score参数为用户获得多少积分。adType为AWU3D_AD_TYPE中的值
 *
 * function awAdRequestShouldPause(adType:string)——当当前广告弹出了minisite、变成半屏状态，或其它用户浏览状态时，SDK会给当前目标发送此消息，以提示当前广告对象不允许被释放，也不应该去重新请求该种广告的新的广告。adType为AWU3D_AD_TYPE中的值
 *
 * function awAdRequestMayResume(adType:string)——当当前广告所弹出的minisite被用户关闭时，半屏恢复时，或其它浏览状态恢复时，SDK会给当前目标发送此消息，以提示广告对象允许被释放，此时应用可以重新请求该种广告的新的广告。adType为AWU3D_AD_TYPE中的值
 *
 * function awUserClosedVideoAd(closeType:string)——当当前的视频被用户关闭时，SDK会给当前目标发送此消息。closeType为"0"，说明用户至少已经完整地看过一次视频；closeType为"1"时，说明用户在第一次看视频尚未看完就关闭了。adType为AWU3D_AD_TYPE中的值
 *
 * function awUserClickedVideoAd(adType:string)——当用户点击了当前的视频，SDK会给当前目标发送此消息。adType为AWU3D_AD_TYPE中的值
*/

#ifdef __cplusplus
extern "C" {
#endif

/**
 * 对Unity3D广告做总的初始化
 * @param pid 安沃后台给开发者的每个应用唯一的广告发布ID
 * @param showFormalAd 是否展示正式广告。YES表示展示正式广告，NO表示展示测试广告
 * @param baseViewController 指定基视图控制器，用于弹出安沃广告SDK自带的视图控制器
 * @param spreadChannel 发布渠道
 * @param disableGPS 是否禁用GPS。YES表示禁用GPS，NO表示不禁用GPS
*/
extern void AWUnity3DAdInit(NSString *pid, BOOL showFormalAd,UIViewController *baseViewController, enum ADWOSDK_SPREAD_CHANNEL spreadChannel, BOOL disableGPS);

/**
 * 创建Banner
 * @param adSlotID 广告位ID（由用户自定义，默认为0）
 * @param animationType banner切换动画类型，见enum ADWO_ANIMATION_TYPE
 * @return 若创建成功返回YES，否则返回NO。若创建失败，可通过AdwoAdGetLatestErrorCode()接口来获得相应错误码
*/
extern BOOL AWUnity3DAdCreateBanner(int adSlotID, unsigned animationType);

/**
 * 移除并销毁banner广告
 * @return 如果移除成功则返回YES，否则返回NO
*/
extern BOOL AWUnity3DAdRemoveAndDestroyBanner(void);
    
/**
 * 加载banner广告
 * @param x banner广告的x坐标（单位为点）
 * @param y banner广告的y坐标（单位为点）
 * @param bannerSize banner尺寸类型
 * @param notifyTarget 广告加载出错时通知的目标对象，此参数不能为空。字符串长度最大255字节。
 * @return 如果加载成功返回YES，失败返回NO。如果加载失败，可以通过AdwoAdGetLatestErrorCode()接口来查询错误码
*/
extern BOOL AWUnity3DAdLoadBannerAd(double x, double y, enum ADWO_ADSDK_BANNER_SIZE bannerSize, const char *notifyTarget);

/**
 * 获取全屏广告句柄
 * @param fsAdType 全屏广告形式。详细请见AWU3D_AD_TYPE的描述。这里只能使用AWU3D_AD_TYPE_APP_FUN、AWU3D_AD_TYPE_LAUNCHING或AWU3D_AD_TYPE_GROUND_SWITCH值。
 * @return 如果获取成功，返回YES；失败返回NO
*/
extern BOOL AWUnity3DGetFullScreenAdHandle(enum AWU3D_AD_TYPE fsAdType);

/**
 * 加载全屏广告
 * @param fsAdType 全屏广告形式。详细请见AWU3D_AD_TYPE的描述。这里只能使用AWU3D_AD_TYPE_APP_FUN、AWU3D_AD_TYPE_LAUNCHING或AWU3D_AD_TYPE_GROUND_SWITCH值。
 * @param orientationLocked 应用是否锁定了屏幕方向。如果当前应用在展示全屏广告的时候仅支持横屏或竖屏，那么传YES；如果横竖屏都支持且会切换，则传NO
 * @param notifyTarget 广告加载出错时通知的目标对象，此参数不能为空。字符串长度最大255字节。
 *
*/
extern BOOL AWUnity3DLoadFullScreenAd(enum AWU3D_AD_TYPE fsAdType, BOOL orientationLocked, const char *notifyTarget);
    
/**
 * 展示全屏广告
 * @param fsAdType 全屏广告形式。详细请见AWU3D_AD_TYPE的描述。这里只能使用AWU3D_AD_TYPE_APP_FUN、AWU3D_AD_TYPE_LAUNCHING或AWU3D_AD_TYPE_GROUND_SWITCH值。
 * @return 如果展示成功返回YES，否则返回NO
*/
extern BOOL AWUnity3DShowFullScreenAd(enum AWU3D_AD_TYPE fsAdType);

/**
 * @brief 设置是否自动展示后台切换到前台全屏广告
 * @param autoToShow 是否自动展示。如果为YES，则当应用从后台切换到前台时，倘若此时后台切换到前台全屏广告已加载好，则由SDK自动展示；若为NO，则SDK不会自动展示，交给开发者来调用AdwoAdShowFullScreenAd接口展示全屏
 * @return 若展示成功，则返回YES，否则，返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * @attention 默认情况下，SDK会自动展示后台切换到前台广告。若当前为自动展示，那么开发者手工对后台切换到前台调用AdwoAdShowFullScreenAd接口将会返回NO，同时给出ADWO_ADSDK_ERROR_CODE_FS_ALREADY_AUTO_SHOW的错误码
 */
extern BOOL AWUnity3DSetGroundSwitchAdAutoToShow(BOOL autoToShow);

/**
 * @brief 创建植入性广告
 * @param adWidth 指定植入型广告的宽度（单位为点，不是像素）
 * @param adHeight 指定植入型广告的高度（单位为点，不是像素）
 * @param adInfo 广告信息。开发者可以设置指定广告信息来请求自己想要的广告植入性广告。如果设置为空或者非有效的字符串，则由服务器来决定给出相应广告。注意，这个参数会被retain，因此如果字符串实参使用alloc分配的话，在调用完这个接口之后需要release一次。
 * @return 如果返回为NO，表示广告初始化创建失败，开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。如果创建成功，则返回YES。
 */
extern BOOL AWUnity3DCreateImplantAd(double adWidth, double adHeight, const char *adInfo,enum ADWOSDK_IMAD_SHOW_FORM imAdForm);

/**
 * 移除并释放植入型广告
 * @param imAdForm 植入性广告的类型
 * @return 如果移除成功返回YES，否则返回NO
*/
extern BOOL AWUnity3DRemoveAndDestroyImplantAd(enum ADWOSDK_IMAD_SHOW_FORM imAdForm);

/**
 * @brief 加载植入性广告
 * @param notifyTarget 广告加载出错时通知的目标对象，此参数不能为空。字符串长度最大255字节。
 * @param imAdForm 植入性广告的类型
 * @return 若加载成功返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 */
extern BOOL AWUnity3DLoadImplantAd(const char *notifyTarget, enum ADWOSDK_IMAD_SHOW_FORM imAdForm);
    
/**
 * @brief 展示植入性广告
 * @param x 展示植入型广告的x坐标（单位为点）
 * @param y 展示植入型广告的y坐标（单位为点）
 * @param imAdForm 植入性广告的类型
 * @return 若加载成功返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 */
extern BOOL AWUnity3DShowImplantAd(double x, double y, enum ADWOSDK_IMAD_SHOW_FORM imAdForm);
    
/**
 * 获取当前植入性广告的宽度
 * @attention 此接口只能在awAdViewDidLoadAd消息处理中使用
 * @param imAdForm 植入性广告的类型
 * @return 植入性广告宽度
*/
extern double AWUnity3DGetImplantAdWidth(enum ADWOSDK_IMAD_SHOW_FORM imAdForm);

/**
 * 获得当前植入性广告的高度
 * @attention 此接口只能在awAdViewDidLoadAd消息处理中使用
 * @param imAdForm 植入性广告的类型
 * @return 植入性广告高度
*/
extern double AWUnity3DGetImplantAdHeight(enum ADWOSDK_IMAD_SHOW_FORM imAdForm);
    
/**
 * @brief 激活植入性广告
 * @discussion 当展示了植入性广告之后，开发者可以在适当时机调用此接口来激活植入性广告。倘若植入性广告具有动画、播放音视频等效果的话，
 * 那么往往通过调用这个接口来激活这些动态行为。
 * @param imAdForm 植入性广告的类型
 * @return 若加载成功返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 */
extern BOOL AWUnity3DImplantAdActivate(enum ADWOSDK_IMAD_SHOW_FORM imAdForm);

#ifdef __cplusplus
}
#endif

