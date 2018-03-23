//
//  TF2.m
//  jianpan
//
//  Created by Jay on 2018/3/22.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TF2.h"

@implementation TF2

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 100)];
    v.backgroundColor = [UIColor yellowColor];
    
    self.inputView = v;
}

@end
