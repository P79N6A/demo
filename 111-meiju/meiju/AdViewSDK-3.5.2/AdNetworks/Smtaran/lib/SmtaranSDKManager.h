//
//  SDKManager.h
//  SDKManager
//
//  Created by fwang on 15/4/19.
//  Copyright (c) 2015年 fwang. All rights reserved.
//

#define MS_Test_PublishID        @"WltaiTXO10Bpa28A3Q=="
#define MS_Test_SlotToken_Banner @"6uvqOYV9Z/DZ29+wbdyI12bM"//横幅广告位
#define MS_Test_SlotToken_Poster @"Ojs66VWttyAJCw9gvQ1YB7Yd"//全屏广告位
#define MS_Test_SlotToken_Native @"gYCBUu4WDJuysLTbBrTjvA2v"//信息流广告位

#define MS_Test_Audit_Flag   @"IOS_AppStore_V7.0.0"


@interface SmtaranSDKManager : NSObject

/**
 *  @brief 获得广告管理单例
 */
+ (SmtaranSDKManager *)getInstance;

/**
 *  @brief 设置publisherID
 *  @param publisherID 开发者平台分配给应用的id
 */
- (void)setPublisherID:(NSString *)publisherID;
/**
 *  @brief 设置审核标识，审核标识区分大小写
 *  @param 状态标识字段是为了标识不同渠道不同版本的不同审核状态而设置
 */
- (void)setPublisherID:(NSString *)publisherID auditFlag:(NSString *)flag;
/**
 *  @brief 设置应用分发渠道
 *  @param deployChannel 分发渠道名称
 */
- (void)setPublisherID:(NSString *)publisherID withChannel:(NSString *)channel auditFlag:(NSString *)flag;
/**
 *  @brief 设置是否在应用内打开app store（使用store kit）
 *  @param flag YES在应用内打开，否则在应用外打开
 *  @note  在IOS7下，只支持横屏的应用内打开app store组件，应用会崩溃
 */
- (void)showStoreInApp:(BOOL)flag;

/**
 *  @brief 设置是否在应用内打开GPS
 *  @param flag YES在应用内打开，NO关闭
 *  @note  默认GPS是打开状态,需要在setPublisherID之前调用
 */
- (void)setEnableLocation:(BOOL)flag;
@end
