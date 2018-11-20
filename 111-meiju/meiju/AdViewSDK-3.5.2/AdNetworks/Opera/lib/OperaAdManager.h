//
//  OperaAdManager.h
//  OPAdplayerSDK
//
//  Created by LW on 16/7/19.
//  Copyright © 2016年 Mr Li. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OperaAdManager : NSObject

/**
 *  @brief 获得广告管理单例
 */
+ (OperaAdManager *)getInstance;

/**
 @brief 设置SDK调用初始化信息
 @param publisherID 开发者平台分配给应用的id
 @param channel 分发渠道名称
 @param flag 状态标识字段是为了标识不同渠道不同版本的不同审核状态而设置，审核标识区分大小写
 @param isPreload 针对视频广告，YES表示允许预加载视频广告物料，对其他广告形式来说无影响
 */
- (void)setPublisherID:(NSString *)publisherID withChannel:(NSString *)channel auditFlag:(NSString *)flag preload:(BOOL)isPreload;

/**
 *@brief 设置SDK初始化信息
 */
-(void)setAdvertiseInfo;
/**
 *@brief 设置SDK初始化信息,需要添加渠道号
 *@param channelID 广告位channelID
 */
-(void)setAdvertiseInfo:(NSString *)channelID;


@end
