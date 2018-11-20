//
//  SmtaranNative.h
//  ios_sdk
//
//  Created by fwang.work on 14-3-13.
//  Copyright (c) 2014年 fwang. All rights reserved.
//



@class SmtaranNativeAd;

@protocol SmtaranNativeDelegate<NSObject>

/**
 *  adNative被点击
 *  @param adNative
 */
-(void)smtaranNativeClick:(SmtaranNativeAd*) adNative;

/**
*  adNative展示
*  @param adNative
*/
-(void)smtaranNativeAppeared:(SmtaranNativeAd*) adNative;

@end

@interface SmtaranNativeAd : UIView

/**
 *  SmtaranNativeDelegate
 *  @param delegate
 */
@property (nonatomic, assign) id<SmtaranNativeDelegate> delegate;

/**
 *  实际广告的大小
 *  @param size
 */
@property (nonatomic, readonly) CGSize size;

/**
 *  native广告元数据(JSON)
 *  @param content
 {
 id=114937 //广告的唯一标示,可以用来去重相同的广告
 height = 250;//广告位的高
 width = 300;//广告位的宽
 title = "信息流广告";//展示的标题
 desc = "";//展示描述
 image = "http://xxxxxxxx.jpg";//广告展示图片
 logo = "http://xxxxxxxx.png";//应用logo
 packageSize = "7.3";//包大小，单位MB
 star = 0;   //展示星级
 }
 */
@property (nonatomic, strong) NSDictionary *content;

//内部函数
-(id)initWithDE:(NSMutableDictionary *)_userinfo
        options:(NSMutableDictionary *)_options
           size:(CGSize)_adSize
       slotData:(NSDictionary *)_slotData;
@end
