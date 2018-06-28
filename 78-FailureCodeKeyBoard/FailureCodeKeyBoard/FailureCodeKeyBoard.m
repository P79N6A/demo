//
//  FailureCodeKeyBoard.m
//  FailureCodeKeyBoard
//
//  Created by Jay on 25/6/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "FailureCodeKeyBoard.h"

@implementation FailureCodeKeyBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
    return self;
}

- (void)setCodes:(NSArray *)codes{
    _codes = codes;
    [codes enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 5.0;
        btn.tag = idx;
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.showsTouchWhenHighlighted = YES;
        [btn setTitle:[obj valueForKey:@"code"] forState:UIControlStateNormal];
        btn.frame = [[obj valueForKey:@"frame"] CGRectValue];
        btn.backgroundColor = [UIColor orangeColor];
        [self addSubview:btn];
    }];
}

- (void)clickAction:(UIButton *)sender{
    !(_clickBlock)? : _clickBlock(_codes[sender.tag]);
}

@end
