//
//  PosterAdView.h
//  OPAdplayerSDK
//
//  Created by LW on 16/8/23.
//  Copyright © 2016年 Mr Li. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,OperaPosterAdSize) {
    
    OperaPosterAdSizeNormal,    // for iPhone 300*250
    OperaPosterAdSizeLarge,     // for iPhone 屏幕尺寸
};

@class PosterAdView;
@protocol OperaPosterAdDelegate <NSObject>

@optional

/**
 * @brief PosterAd poster 请求数据成功
 * @param PosterAd
 */
-(void)operaPosterAdRequestSuccessed:(PosterAdView *)PosterAd;

/**
 * @brief PosterAd poster 请求数据失败
 * @param PosterAd
 */
-(void)operaPosterAdRequestFailure:(PosterAdView *)PosterAd error:(NSString *)error;

/**
 * @brief PosterAd poster 展示成功
 * @param PosterAd
 */
-(void)operaPosterAdShowSuccessed:(PosterAdView *)PosterAd;

/**
 * @brief bannerAd poster 广告被点击
 * @param bannerAd
 */
-(void)operaPosterAdClick:(PosterAdView *)PosterAd;

/**
 * @brief bannerAd poster 广告被关闭
 * @param bannerAd
 */
-(void)OperaPosterAdClose:(PosterAdView *)PosterAd;



@end



@interface PosterAdView : NSObject
@property (nonatomic,weak) id<OperaPosterAdDelegate> delegate;

/**
 * @brief 初始化 请求poster 广告
 * @param adSize 广告尺寸
 * @param slotToken 广告位id
 */

-(id)initPosteradSize:(OperaPosterAdSize)adSize
             slotToken:(NSString *)slotToken;


/**
 * @brief poster 初始化完成，展示广告
 */

-(void)showPosterAd;

@end
