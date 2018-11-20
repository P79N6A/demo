//  InterstitialAd.h
//
//
//  Created by cheng ping on 14/10/20.
//  Copyright (c) 2014年 tek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdError.h"
#import "AdDelegate.h"
@interface InterstitialAd : NSObject <AdDelegate>
/**
 *  插屏广告代理
 */
@property ( nonatomic, weak ) id<AdDelegate> interstitialAdDelegate;
/**
 *  父视图
 *  需设置为显示广告的UIViewController
 */
//@property (nonatomic, assign) UIViewController *currentViewController;
@property (nonatomic ,weak) UIViewController *currentViewController;
/**
 *  获取插屏广告对象
 *
 *  @return 返回InterstitialAd对象
 */
+ (InterstitialAd *) sharedInstance;
/**
 *  请求插屏广告
 *
 *  @param adUnitId 广告位
 *  @param appid    appid
 */
- (void) loadAdWithAdUnitId:(NSString *) adUnitId AndAppId:(NSString *) appid;
/**
 *  展现插屏广告
 */
- (void) showAd;
@end
