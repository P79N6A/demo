//
//  TF1.m
//  jianpan
//
//  Created by Jay on 2018/3/22.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TF1.h"//

@implementation TF1

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 100)];
    v.backgroundColor = [UIColor orangeColor];
    
    self.inputView = v;
}
@end
