//
//  OperaVideoAd.h
//  OPAdplayerSDK
//
//  Created by LW on 16/7/21.
//  Copyright © 2016年 Mr Li. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, OperaVideoAdSize){

    OperaVideoAdSizeNormol, // 半屏播放
    OperaVideoAdSizeLarge,  // 全屏播放
};


@class OperaVideoAd;
@protocol OperaVideoAdDelegate <NSObject>

@optional

/**
 * @brief videoAd 被点击
 * @param videoAd
 */

-(void)OperaVedioAdClick:(OperaVideoAd *)videoAd;

/**
 * @brief videoAd 被关闭
 * @param videoAd
 */
-(void)OperaVedioAdClose:(OperaVideoAd *)videoAd;


@end


@interface OperaVideoAd : NSObject
@property(nonatomic, assign) id<OperaVideoAdDelegate> delegate;

/**
 *  @brief 初始化并请求视频广告
 *  @param adSize 广告视图大小
 *  @param delegate 该广告所使用的委托
 *  @param slotToken 视频广告位id
 *  @param UserVc 要求用户传进一个controller(必须要传)
 */
-(id)initVideoAdSize:(OperaVideoAdSize)adSize delegate:(id<OperaVideoAdDelegate>) delegate slotToken:(NSString *)slotToken ViewController:(nonnull UIViewController *)UserVc;


@end
