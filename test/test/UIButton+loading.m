
//
//  UIButton+loading.m
//  test
//
//  Created by Jay on 14/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "UIButton+loading.h"


@implementation UIButton (loading)


- (void)setTitle:(NSString *)title forState:(TTControlState)state{
    if (state == TTControlStateLoading) {
        return;
    }
    [self setTitle:title forState:state];
}
@end
