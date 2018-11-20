//
//  NativeDelegate.h
//  AD_Demo
//
//  Created by 深海 on 16/3/14.
//  Copyright © 2016年 faf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NativeAdDelegate <NSObject>
/**
 *  原生广告加载广告数据成功回调，返回为NativeAdData对象的数组
 */
-(void)onAdSuccess:(NSArray *)nativeAdDataArray;

/**
 *  原生广告加载广告数据失败回调
 */
-(void)onAdFailed:(AdError *)error;

@end
