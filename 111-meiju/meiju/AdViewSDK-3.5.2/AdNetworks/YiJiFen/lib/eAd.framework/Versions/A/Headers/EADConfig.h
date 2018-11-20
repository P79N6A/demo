//
//  EADConfig.h
//  eAd
//
//  Created by Emar on 3/18/15.
//  Copyright (c) 2015 Emar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EADConfig : NSObject

/*!
 * @method startWithAppId:appKey:devId
 *
 * @param appId
 * 应用ID
 *
 * @param appKey
 * 在 http://www.yijifen.com 创建应用后得到的appKey
 *
 * @param devId
 * 开发者ID
 */

+ (void)startWithAppId:(NSString *)appId appKey:(NSString *)appKey devId:(NSString *)devId;

/*!
 * @method configChannel:
 *
 * @param channel
 * 市场渠道号，如有需要请配置
 *
 */

+ (void)configChannel:(NSString *)channel;

/*!
 * @method configCoopInfo:
 *
 * @param coopInfo
 * 用户ID，如果没有用户体系，则可以不配置此参数
 *
 */

+ (void)configCoopInfo:(NSString *)coopInfo;


@end
