//
//  UIImage+Extension.m
//  extension
//
//  Created by czljcb on 2017/6/28.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)


+ (UIImage *)imageWithOriginalRenderingMode:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



+ (UIImage *)imageWithCircleBorder:(CGFloat)border borderColor:(UIColor *)color image:(UIImage *)image
{
    
    //image = [UIImage imageWithContentsOfFile:@"/Users/czljcb/Desktop/1.png"];
    //border = 20.0;
    //color = [UIColor redColor];
    // 圆环宽度
    CGFloat borderWH = border;
    
    // 加载图片
    CGFloat interval = 0.0;
    
    CGFloat min = MIN(image.size.width, image.size.height);
    
    CGFloat ctxWH = min;
    CGRect ctxRect;
    
    if (image.size.width > image.size.height ) {
        interval = image.size.width - min;
        ctxRect = CGRectMake(interval/2.0, 0, min, min);
    }else {
        interval = image.size.height - ctxWH;
        ctxRect = CGRectMake( 0,interval/2.0, ctxWH, ctxWH);
        
        
    }
    
    // 1.开启位图上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    // 2.画大圆
    UIBezierPath *bigCirclePath = [UIBezierPath bezierPathWithOvalInRect:ctxRect];
    
    // 设置圆环的颜色
    [color set];
    
    [bigCirclePath fill];
    
    // 3.设置裁剪区域
    
    
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(ctxRect.origin.x+ 1 * borderWH, ctxRect.origin.y + 1 * borderWH, min - 2 * borderWH, min - 2 * borderWH)];
    
    [clipPath addClip];
    //4.画图片
    [image drawAtPoint:CGPointMake(borderWH, borderWH)];
    
    // 5.从上下文中获取图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    
    //[UIImagePNGRepresentation(image) writeToFile:@"users/czljcb/desktop/cz1.png" atomically:YES];
    
    return image;
}


@end
