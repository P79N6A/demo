//
//  MiidiMobAd.h
//  MiidiMobAd
//
//  Created by yangheng_MacBookPro on 15/4/16.
//  Copyright (c) 2015年 org.iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MiidiMobAdApiConfig.h"
@interface MiidiMobAd : NSObject
#pragma mark -
#pragma mark 1_0.* 配置SDK接口<开发者必调接口>


/**
 *  @brief  初始化SDK接口,必须配置
 *
 *  @param publisher 开发者应用ID ;     开发者到 www.miidi.net 上提交应用时候,获取id和密码
 *  @param secret    开发者的安全密钥 ;  开发者到 www.miidi.net 上提交应用时候,获取id和密码
 */
+ (void)setMiidiBasPublisher:(NSString *)publisher withMiidiBasSecret:(NSString *)secret;


#pragma mark 1_2.. 其他功能接口
/**
 *  @brief  获取当前SDK的版本号
 *
 *  @return SDK版本号
 */
+ (NSString *)getMiidiBasSdkVersion;

/**
 *  @brief  SDK使用的资源文件用bundle打包,此接口以防名词冲突,开发者可修改文件名和存放路径
 *
 *  @param path 设置bundle全路径 ~/resource.bundle
 */
+ (void)setMiidiBasSdkResourceBundlePath:(NSString *)path;


#pragma mark - 2_0.* 横幅广告SDK接口


/**
 *  @brief  请求横幅广告
 *
 *  @param sizeIdentifer 广告位尺寸标识符,固定的几种类型
 *  @param delegate      横幅广告Delegate
 *
 *  @return 返回autorelease的View
 */
+ (UIView *)requestMiidiBasBanner:(int)sizeIdentifer withMiidiBasDelegate:(id)delegate;


#pragma mark - 3_0.* 插屏广告SDK接口
/**
 *  @brief  请求插屏广告
 *
 *  @param complete 请求结果block error==nil表示加载成功
 */
+ (void)requestMiidiBasSplash:( void (^)(NSError *) )complete;

/**
 *  @brief  请求插屏广告状态
 *
 *  @return YES,加载完成; NO,没有
 */
+ (BOOL)requestMiidiBasSplashState;

/**
 *  @brief  展示插屏广告
 *
 *  @param dismiss 关闭插屏广告block
 */
+ (void)displayMiidiBasSplash:( void (^)() )dismiss;

/**
 *  @brief  请求插屏广告失败后调用,否则会导致直至App下次启动位置,都无法再展示广告
 */
+ (void)requestMiidiBasSplashOverForFailed;




@end
