//
//  UIBarButtonItem+Button.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/22.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "UIBarButtonItem+Button.h"

@implementation UIBarButtonItem (Button)

+(UIBarButtonItem *)itemWithImage:(NSString *)image
//                  higlightedImage:(NSString *)hilight
                           target:(id)target
                           action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normal  = [UIImage imageNamed:image];
    [btn setImage:normal forState:UIControlStateNormal];
    //[btn setBackgroundImage:normal forState:UIControlStateNormal];
    //[btn setBackgroundImage:[UIImage imageNamed:hilight]forState:UIControlStateHighlighted];
    //btn.bounds = CGRectMake(0, 0, normal.size.width, normal.size.height);
    btn.bounds = CGRectMake(0, 0,22,44);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
