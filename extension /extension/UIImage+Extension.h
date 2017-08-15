//
//  UIImage+Extension.h
//  extension
//
//  Created by czljcb on 2017/6/28.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

// 加载不要被渲染的图片
+ (UIImage *)imageWithOriginalRenderingMode:(NSString *)imageName;


+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithCircleBorder:(CGFloat)border
                       borderColor:(UIColor *)color
                             image:(UIImage *)image;


@end
