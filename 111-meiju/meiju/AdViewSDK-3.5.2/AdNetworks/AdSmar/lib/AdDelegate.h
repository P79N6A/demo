//
//  nonNativeAdDelegate.h
//  AD_Demo
//
//  Created by 深海 on 16/3/14.
//  Copyright © 2016年 faf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AdDelegate <NSObject>
/**
 *  请求广告成功
 */
- (void)onAdSuccess;
/**
 *  请求广告错误
 *
 *  @param errorCode 错误码，详见入门手册
 */
- (void)onAdFailed:(AdError *)errorCode;
/**
 *  广告关闭回调
 */
- (void)onAdClose;
/**
 *  广告被点击
 */
- (void)onAdClick;


@end
