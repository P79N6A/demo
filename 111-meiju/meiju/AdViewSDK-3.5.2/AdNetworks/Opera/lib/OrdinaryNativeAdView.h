//
//  OrdinaryNativeAdView.h
//  OPAdplayerSDK
//
//  Created by LW on 16/8/31.
//  Copyright © 2016年 Mr Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrdinaryNativeView;
@protocol OperaOrdinaryNativeAdDelegate <NSObject>

@optional

/**
 * @brief 普通信息流请求数据成功
 */
-(void)operaOrdinaryNativeAdRequestSuccessed:(OrdinaryNativeView*)native;
/**
 * @brief 普通信息流请求数据失败
 */
-(void)operaOrdinaryNativeAdRequestFailure:(OrdinaryNativeView*)native error:(NSString *)error;
/**
 *@brief 普通信息流广告展示成功
 */
-(void)operaOrdinaryNativeAdShowSuccessed:(OrdinaryNativeView*)native;
/**
 *@brief 普通信息流广告展示失败
 */
-(void)operaOrdinaryNativeAdShowFailure:(OrdinaryNativeView*)native;
/**
 *@brief 普通信息流广告被点击
 */
-(void)operaOrdinaryNativeAdClicked:(OrdinaryNativeView*)native;

@end

@interface OrdinaryNativeAdView : NSObject

@property (nonatomic,weak) id<OperaOrdinaryNativeAdDelegate> delegate;

/**
 * @brief 初始化普通信息流
 * @param slotToken 广告位id
 * @param frame 是广告banner展示的位置和大小(目前大小是固定的)
 */

-(instancetype)initWithFrame:(CGRect)frame
                   slotToken:(NSString *)slotToken;




@end
