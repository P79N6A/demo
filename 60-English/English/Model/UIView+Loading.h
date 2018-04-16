//
//  UIView+Loading.h
//  BBKorean
//
//  Created by czljcb on 2018/3/28.
//  Copyright © 2018年 czljcb. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIView (Loading)
/**
 展示loading（默认灰色）
 */
- (void)showLoading;

/**
 展示指定颜色的loading
 
 @param color loading的颜色
 */
- (void)showLoadingWithColor:(UIColor *)color;

/**
 移除loading
 */
//- (void)removeLoading;
- (void)hideLoading:(NSString *)msg;

@end
