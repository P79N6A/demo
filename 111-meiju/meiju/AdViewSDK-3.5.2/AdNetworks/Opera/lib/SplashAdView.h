//
//  SplashAdView.h
//  OPAdplayerSDK
//
//  Created by LW on 16/9/2.
//  Copyright © 2016年 Mr Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SplashAdView;
@protocol OperaSplashAdDelegate <NSObject>

@optional

/**
 * @brief adSplash 请求数据成功
 * @param adSplash
 */
-(void)operaSplashAdRequestSuccessed:(SplashAdView *)adSplash;
/**
 * @brief adSplash 请求数据失败
 * @param adSplash
 */
-(void)operaSplashAdRequestFailure:(SplashAdView *)adSplash error:(NSString *)error;
/**
 *  @brief adSplash被点击
 *  @param adSplash
 */
- (void)operaSplashAdClick:(SplashAdView*)adSplash;
/**
 *  @brief adSplash请求成功并展示广告
 *  @param adSplash
 */
- (void)operaSplashAdSuccessToShowAd:(SplashAdView*)adSplash;
/**
 *  @brief adSplash 展示广告失败
 *  @param adSplash
 */
- (void)operaSplashAdFailureToShowAd:(SplashAdView*)adSplash;

/**
 *  @brief AdSplash被关闭
 *  @param adSplash
 */
- (void)operaSplashAdClose:(SplashAdView*)adSplash;


@end

@interface SplashAdView : NSObject
@property (nonatomic,assign) id<OperaSplashAdDelegate>delegate;

/**
 *  拉取广告超时时间，默认为3秒
 *  详解：拉取广告超时时间，开发者调用loadAd方法以后会立即展示backgroundColor，然后在该超时时间内，如果广告拉
 *  取成功，则立马展示开屏广告，否则放弃此次广告展示机会。
 */
@property (nonatomic, assign) int fetchDelay;

/*
 *  开屏广告展示时间，默认5秒
 */
@property (nonatomic, assign) NSInteger adImpressTime;

/**
 *  @brief 初始化开屏广告
 *  @param adid 广告位id
 */
-(nonnull instancetype)initWithADID:(nonnull NSString *)adid;
/**
 *  @brief 展示开屏广告
 *  @param window 展示开屏的容器
 *  @param bottomView 自定义底部View，可以在此View中设置应用Logo
 */
-(void)loadAdAndShowInWindow:(nonnull UIWindow *)window
              withBottomView:(nullable UIView*)bottomView;


@end
