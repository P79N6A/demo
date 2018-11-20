//
//  BannerAdView.h
//  OPAdplayerSDK
//
//  Created by LW on 16/8/23.
//  Copyright © 2016年 Mr Li. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * 轮播时间
 */
typedef NS_ENUM(NSInteger,OperaBannerRefreshTime) {
    
    OperaBannerAdRefreshTimeNone,         //不刷新
    OperaBannerAdRefreshTimeHalfMinute,   //30秒刷新
    OperaBannerAdRefreshTimeOneMinute,    //60秒刷新

};
/**
 * 轮播动画
 */
// UIViewAnimationOptions
typedef NS_ENUM(NSInteger,OperaBannerAdAnimationType) {
    
    OperaBannerAnimationOptionTransitionNone            = 0 , // default
    OperaBannerAnimationOptionTransitionFlipFromLeft   ,
    OperaBannerAnimationOptionTransitionFlipFromRight  ,
    OperaBannerAnimationOptionTransitionCurlUp         ,
    OperaBannerAnimationOptionTransitionCurlDown       ,
    OperaBannerAnimationOptionTransitionFlipFromTop    ,
    OperaBannerAnimationOptionTransitionFlipFromBottom ,
    OperaBannerAnimationOptionTransitionCrossDissolve,
    OperaBannerAnimationOptionTransitionRandom,

};

/**
 * banner 尺寸
 */
typedef NS_ENUM(NSInteger,OperaBannerSize){
    OperaBannerAdSizeNormol, // 正常尺寸320X50
    OperaBannerAdSizeLarge,  // 大尺寸
};


@class BannerAdView;
@protocol OperaBannerAdDelegate <NSObject>
@optional

/**
 * @brief bannerAd banner 请求数据成功
 * @param bannerAd
 */
-(void)operaBannerAdRequestSuccessed:(BannerAdView *)bannerAd;
/**
 * @brief bannerAd banner 请求数据失败
 * @param bannerAd
 */
-(void)operaBannerAdRequestFailure:(BannerAdView *)bannerAd error:(NSString *)error;
/**
 * @brief bannerAd banner 展示成功
 * @param bannerAd
 */
-(void)operaBannerAdShowSuccessed:(BannerAdView *)bannerAd;

/**
 * @brief bannerAd banner 展示失败
 * @param bannerAd
 */
-(void)operaBannerAdShowFailure:(BannerAdView *)bannerAd;

/**
 * @brief bannerAd banner 广告被点击
 * @param bannerAd
 */
-(void)operaBannerAdClick:(BannerAdView *)bannerAd;

/**
 * @brief bannerAd banner 广告被关闭
 * @param bannerAd
 */
-(void)operaBannerAdClose:(BannerAdView *)bannerAd;



@end


@interface BannerAdView : NSObject

@property (nonatomic,weak) id<OperaBannerAdDelegate> delegate;

/**
 * @brief 初始化 请求banner 广告
 * @param frame 是广告banner展示的位置和大小(目前大小是固定的)
 * @param refreshTimer 轮播时间
 * @param animationType 录播动画 默认是无动画
 */
-(instancetype)initWithFrame:(CGRect)frame
                   slotToken:(NSString *)slotToken
                refreshTimer:(OperaBannerRefreshTime) refreshTimer
               animationType:(OperaBannerAdAnimationType)animationType;


@end
