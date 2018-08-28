//
//  test.m
//  iqy
//
//  Created by Jay on 28/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "test.h"

@implementation test

- (BOOL)canBecomeFirstResponder{
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self becomeFirstResponder];
}
@end
