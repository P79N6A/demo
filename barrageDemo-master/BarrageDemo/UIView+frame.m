//
//  UIView+frame.m
//  BuDeJie
//
//  Created by czljcb on 16/9/9.
//  Copyright © 2016年 czljcb. All rights reserved.
//

#import "UIView+frame.h"

@implementation UIView (frame)

- (void)setCx_width:(CGFloat)cx_width
{
    CGRect frame = self.frame;
    
    frame.size.width = cx_width;
    
    self.frame = frame;
}

-(CGFloat)cx_width
{
    return self.frame.size.width;
    
}

- (void)setCx_height:(CGFloat)cx_height
{
    CGRect frame = self.frame;
    
    frame.size.height = cx_height;
    
    self.frame = frame;
}

-(CGFloat)cx_height
{
    return self.frame.size.height;
}

- (void)setCx_x:(CGFloat)cx_x
{
    
    CGRect frame = self.frame;
    
    frame.origin.x = cx_x;
    
    self.frame = frame;
}

- (CGFloat)cx_x
{
    return self.frame.origin.x;
}

- (void)setCx_y:(CGFloat)cx_y
{
    
    CGRect frame = self.frame;
    
    frame.origin.y = cx_y;
    
    self.frame = frame;
}

-(CGFloat)cx_y
{
    return self.frame.origin.y;
}


-(CGPoint)cx_center
{
    return self.center;
}

-(void)setCx_center:(CGPoint)cx_center
{
    CGPoint center ;//= self.center;
    center = cx_center;
    self.center = center;
}


-(void)setCx_centerX:(CGFloat)cx_centerX
{
    CGPoint center = self.center;
    
    center.x = cx_centerX;
    
    self.center = center;
}

-(CGFloat)cx_centerX
{
    return self.center.x;
}

-(void)setCx_cebterY:(CGFloat)cx_cebterY
{
    CGPoint center = self.center;
    center.y = cx_cebterY;
    self.center = center;
}
- (CGFloat)cx_cebterY
{
    return self.center.y;
}


+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject ;
}


@end
