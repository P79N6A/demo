//
//  CSSplashAd.h
//  ChanceAdSDK
//
//  Created by Chance_yangjh on 16/5/10.
//  Copyright © 2016年 Chance. All rights reserved.
//

#ifndef CSSplashAd_h
#define CSSplashAd_h
#import <Foundation/Foundation.h>
#import "CSError.h"

@protocol CSSplashAdDelegate;

@interface CSSplashAd : NSObject

// 广告位ID
@property (nonatomic, copy) NSString *placementID;
// 最小展现时长
@property (nonatomic, assign) int minShowDur;
// 自动关闭时长
@property (nonatomic, assign) int minAutoCloseDur;

@property (nonatomic, weak) UIViewController *rootViewController;

@property (nonatomic, weak) id <CSSplashAdDelegate> delegate;

// 开屏广告只有一个
+ (CSSplashAd *)sharedInstance;

// 显示开屏广告
- (BOOL)showSplashInWindow:(UIWindow *)window andDownloadVideoOnlyWifi:(BOOL)onlyWifi;

@end


@protocol CSSplashAdDelegate <NSObject>

@optional

// 开屏广告请求失败
- (void)csSplashAd:(CSSplashAd *)splashAd requestError:(CSError *)error;

// 开屏广告将要关闭
- (void)csSplashAdWillClose:(CSSplashAd *)splashAd;

// 开屏广告关闭完成
- (void)csSplashAdCloseFinished:(CSSplashAd *)splashAd;

// 互动页展示
- (void)csSplashAdInteractPageShow:(CSSplashAd *)splashAd;

// 互动页关闭
- (void)csSplashAdInteractPageClose:(CSSplashAd *)splashAd;

@end
#endif
