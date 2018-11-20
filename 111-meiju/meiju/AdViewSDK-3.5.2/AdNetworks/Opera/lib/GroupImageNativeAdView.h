//
//  GroupImageNativeAdView.h
//  OPAdplayerSDK
//
//  Created by LW on 16/8/29.
//  Copyright © 2016年 Mr Li. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef NS_ENUM(NSInteger,GroupImageNativeAdType) {
//    
//    OperaGroupImageNativeAdThreeGongge,    // 三宫格
//    OperaGroupImageNativeAdSixGongge,      // 六宫格
//    OperaGroupImageNativeAdNineGongge,     //九宫格
//    
//    
//};


@class GroupImageNativeAdView;
@protocol GroupImageNativeAdDelegate <NSObject>

@optional


/**
 * @brief  请求数据成功
 */
-(void)operaGroupImageNativeAdRequestSuccessed:(GroupImageNativeAdView *)native;
/**
 * @brief  请求数据失败
 */
-(void)operaGroupImageNativeAdRequestFailure:(GroupImageNativeAdView *)native error:(NSString *)error;
/**
 *@brief 组图广告展示成功
 */
-(void)operaGroupImageNativeAdShowSuccessed:(GroupImageNativeAdView*)native;
/**
 *@brief 组图广告展示成功
 */
-(void)operaGroupImageNativeAdShowFailure:(GroupImageNativeAdView*)native;
/**
 *@brief 组图广告被点击
 */
-(void)operaGroupImageNativeAdClicked:(GroupImageNativeAdView*)native;

@end


@interface GroupImageNativeAdView : NSObject
@property (nonatomic,weak) id<GroupImageNativeAdDelegate> delegate;

/**
 * @brief 初始化组图信息流
 * @param slotToken 广告位id
 * @param frame 是广告banner展示的位置和大小(目前大小是固定的)
 */

-(instancetype)initWithFrame:(CGRect)frame
                   slotToken:(NSString *)slotToken;

@end
