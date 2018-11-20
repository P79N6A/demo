//
//  ImageNativeAdView.h
//  OPAdplayerSDK
//
//  Created by LW on 16/9/1.
//  Copyright © 2016年 Mr Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageNativeAdView;
@protocol OperaImageNativeAdDelegate <NSObject>

@optional

/**
 * @brief 卡片信息流请求数据成功
 */
-(void)operaImageNativeAdRequestSuccessed:(ImageNativeAdView*)native;
/**
 * @brief 卡片信息流请求数据失败
 */
-(void)operaImageNativeAdRequestFailure:(ImageNativeAdView*)native error:(NSString *)error;
/**
 *@brief 卡片信息流广告展示成功
 */
-(void)operaImageNativeAdShowSuccessed:(ImageNativeAdView*)native;
/**
 *@brief 卡片信息流广告展示失败
 */
-(void)operaImageNativeAdShowFailure:(ImageNativeAdView*)native;
/**
 *@brief 卡片信息流广告被点击
 */
-(void)operaImageNativeAdClicked:(ImageNativeAdView*)native;


@end

@interface ImageNativeAdView : NSObject

@property (nonatomic,weak) id<OperaImageNativeAdDelegate> delegate;

/**
 * @brief 初始化图片信息流
 * @param SlotToken 广告位id
 * @param frame 是广告banner展示的位置和大小(目前大小是固定的)
 */

-(instancetype)initWithFrame:(CGRect)frame
                   slotToken:(NSString *)slotToken;
@end
