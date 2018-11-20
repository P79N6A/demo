//
//   NativeAd.h
//
//  Created by zhang cheng
//  Copyright © 2015年 faf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdError.h"
#import "AdLog.h"
#import "NativeadDataModel.h"
#import "NativeAdDelegate.h"

@interface NativeAdData : NSObject

@property (nonatomic, retain) NSDictionary *properties;
@end
@class NativeAd;
@interface NativeAd : NSObject

@property (nonatomic, assign) UIViewController *controller;
/**
 *  委托对象
 */
@property (nonatomic, assign) id<NativeAdDelegate> NativeDelegate;

/**
 *  构造方法
 *  详解：appkey是应用id, placementId是广告位id
 */
-(instancetype)initWithAppId:(NSString *)appId adunitId:(NSString *)adunitId;

/**
 *  广告发起请求方法
 *  详解：[必选]发起拉取广告请求,在获得广告数据后回调delegate
 *  @param adCount 一次拉取广告的个数
 */
-(void)loadAd:(int)adCount;

/**
 *  广告数据渲染完毕即将展示时调用方法
 *  详解：[必选]广告数据渲染完毕，即将展示时需调用本方法。
 *      @param nativeAdData 广告渲染的数据对象
 *      @param view         渲染出的广告结果页面
 */
-(void)attachAd:(NativeAdDataModel *)nativeAdData toView:(UIView *)view;

/**
 *  广告点击调用方法
 *  详解：当用户点击广告时，开发者需调用本方法，系统会弹出内嵌浏览器、或内置AppStore、
 *      或打开系统Safari，来展现广告目标页面
 *      @param nativeAdData 用户点击的广告数据对象
 */
-(void)clickAd:(NativeAdDataModel *)nativeAdData;
@end
