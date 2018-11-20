//  AdFullScreenController.h
//
//
//  Created by zhang cheng
//  Copyright (c) 2014年 tek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdError.h"
#import "AdDelegate.h"


@interface FullScreenAd : UIViewController<UIWebViewDelegate>
/**
 *  全屏广告代理
 */
@property ( nonatomic, weak ) id<AdDelegate> fullScreenAdDelegate;
/**
 *  设置父控制器
 */
@property (nonatomic,strong) UIViewController *presentingController;
/**
 *  是否隐藏状态栏，默认隐藏
 */
@property(readwrite,nonatomic,assign) BOOL perferStatusBarHidden;
/**
 *  获取全屏对象
 *
 *  @return 返回AdFullScreenController
 */
+ (FullScreenAd *) sharedInstance;
/**
 *  请求全屏广告
 *
 *  @param adUnitId 广告位
 *  @param appid    appid
 */
- (void) loadAdWithAdUnitId:(NSString *) adUnitId AndAppId:(NSString *) appid;
/**
 *  展示全屏广告
 *
 *  @param animated 是否允许动画
 */
- (void)showFullscreenBrowserAnimated:(BOOL)animated;
/**
 *  关闭全屏广告
 *
 *  @param animated 是否允许动画
 */
- (void)closeFullscreenBrowserAnimated:(BOOL)animated;
/**
 *  设置自动关闭时间，默认3000毫秒
 *
 *  @param time 自动关闭时间
 */
- (void)setDisplayTime:(int) time;

@end


