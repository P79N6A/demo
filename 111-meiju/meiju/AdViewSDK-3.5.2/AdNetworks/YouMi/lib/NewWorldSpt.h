//
//  NewWorldSpt.h
//  QQWSPTSDK
//
//  Created by yuxuhong on 14-10-26.
//  Copyright (c) 2014年 QQW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// 指定要使用横屏还是竖屏的广告图片.
// 竖屏应用,选这个:kSPOTSpotTypePortrait
// 横屏应用,选这个:kSPOTSpotTypeLandscape
// 应用支持横竖屏时,选这个:kSPOTSpotTypeBoth.注意选这个sdk会缓存两张图片,不支持旋转的应用不建议选这个
typedef enum {
    kTypePortrait = 0,
    kTypeLandscape = 1,
    kTypeBoth = 2,
} SsType;

@interface NewWorldSpt : NSObject
// 初始化appid
+(void)initQQWDeveloperParams:(NSString *)QQ_appid QQ_SecretId:(NSString *)QQ_SecretId;
// 初始化插屏广告和设置使用的广告类型
+ (void)initQQWDeveLoper:(SsType)ssType;

// 显示插屏广告，有显示返回YES且flag也为YES.没显示返回NO且flag也为NO，dismiss为广告点关闭后的回调。
+ (BOOL)showQQWSPTAction:(void (^)(BOOL flag))dismissAction;

// 点击插屏广告的回调,点击成功,flag为YES,否则为NO
+ (BOOL)clickQQWSPTAction:(void (^)(BOOL flag))callbackAction;

+ (void)setController:(UIViewController *)controller;

@end
