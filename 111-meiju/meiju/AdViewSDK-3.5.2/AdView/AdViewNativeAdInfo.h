//
//  AdViewNativeAdInfo.h
//  AdViewDevelop
//
//  Created by maming on 15/12/25.
//  Copyright © 2015年 maming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AdViewNativeVideoStatus) {
    AdViewNativeVideoStatus_StartPlay,
    AdViewNativeVideoStatus_MiddlePlay,
    AdViewNativeVideoStatus_CompletePlay,
    AdViewNativeVideoStatus_Pause,
    AdViewNativeVideoStatus_TerminationPlay,
};

@interface AdViewNativeVideoDataAcquisitionObject : NSObject

@property (nonatomic, assign) int duration; // 视频总时长，单位为秒
@property (nonatomic, assign) int beginTime; // 视频播放开始时间，单位为妙。如果视频从头开始播放，则为0
@property (nonatomic, assign) int endTime; // 视频播放结束时间，单位为妙。如果视频播放到结尾，则等于视频总时长
@property (nonatomic, assign) int firstFrame; // 视频是否从第一帧开始播放。是的话为1，否则为0
@property (nonatomic, assign) int lastFrame; // 视频是否播放到最后一帧。播放到最后一帧则为1；否则为0
@property (nonatomic, assign) int scene;
// 视频播放场景；
// 1-> 在广告曝光区域播放
// 2-> 全屏竖屏、只展示视频
// 3-> 全屏竖屏、屏幕上方展示视频、下方展示广告推广页面
// 4-> 全屏横屏、只展示视频
// 0-> 其他自定义场景

@property (nonatomic, assign) int type;
// 播放类型
// 1-> 第一次播放
// 2-> 暂停后继续播放
// 3-> 重新开始播放

@property (nonatomic, assign) int behavior;
// 播放行为
// 1-> 自动播放
// 2-> 点击播放

@property (nonatomic, assign) int status;
// 播放状态
// 0-> 正常播放
// 1-> 视频加载中
// 2-> 下载或播放错误

@end


//物料标题
extern NSString *const AdViewNativeAdTitle;
//物料图标地址
extern NSString *const AdViewNativeAdIconUrl;
//物料图标宽度
extern NSString *const AdViewNativeAdIconWidth;
//物料图标高度
extern NSString *const AdViewNativeAdIconHeight;
//物料详情
extern NSString *const AdViewNativeAdDesc;
//物料图片地址
extern NSString *const AdViewNativeAdImageUrl;
//物料图片宽度
extern NSString *const AdViewNativeAdImageWidth;
//物料图片高度
extern NSString *const AdViewNativeAdImageHeight;
//物料图片点击地址（不为空时,需开发者处理）
extern NSString *const AdViewNativeAdLinkUrl;
//内置AppStoreID
extern NSString *const AdViewNativeAdAPPStoreitid;
//点击类型  详见集成说明文档
extern NSString *const AdViewNativeAdLinkType;
//物料评分
extern NSString *const AdViewNativeAdRating;
//物料来源
extern NSString *const AdViewNativeAdPName;
//平台LOGO
extern NSString *const AdViewNativeAdLogo;
//广告字样图片
extern NSString *const AdViewNativeAdIcon;
//video广告数据
extern NSString *const AdViewNativeAdvideoDic;

extern NSString *const AdViewNativeAdPdata;
extern NSString *const AdViewNativeAdJsonStr;
extern NSString *const AdViewNativeAdAdapter;

@interface AdViewNativeAdInfo : NSObject

@property (nonatomic, retain) NSDictionary *nativeAdDict;
@property (nonatomic, retain) NSString *nativeAdID;

/*
 * 原生广告展示调用的方法
 * 当⽤户展示广告时,开发者需调用本方法,sdk会做出相应响应（用于发送展示汇报）
 * @param view 被展示的广告View对象
 */
- (void)showNativeAdWith:(UIView*)view;
/*
 * 原生广告点击调用的方法
 * 当⽤户点击广告时,开发者需调用本方法,sdk会做出相应响应（用于发送点击汇报）
 * @param point 点击坐标，广告需要用户点击坐标的位置，否则会影响收益；如果广告视图size为（300，200），左上角point值为（0，0），右下角为（300，200）,以此为例计算point大小；
 */
- (void)clickNativeAdWithClickPoint:(CGPoint)point;
/*
 * 用于视频原生数据汇报方法
 * 当触发AdViewNativeVideoStatus中某个状态时，调用该方法
 * @param videoStatus 视频播放的状态
 * @param dataAcquistionObj 该对象中的数据用于替换响应汇报中的宏字段，务必填写
 */
- (void)reportAdStatus:(AdViewNativeVideoStatus)videoStatus withDataAcquisitionObject:(AdViewNativeVideoDataAcquisitionObject*)dataAcquistionObj;

@end
