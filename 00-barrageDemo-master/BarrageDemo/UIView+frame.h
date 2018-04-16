//
//  UIView+frame.h
//  BuDeJie
//
//  Created by czljcb on 16/9/9.
//  Copyright © 2016年 czljcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frame)

@property CGFloat cx_width;
@property CGFloat cx_height;
@property CGFloat cx_x;
@property CGFloat cx_y;
@property CGPoint cx_center;
@property CGFloat cx_centerX;
@property CGFloat cx_cebterY;

+ (instancetype)viewFromXib;

@end
