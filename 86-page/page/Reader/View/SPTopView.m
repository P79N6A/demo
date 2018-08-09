//
//  SPTopView.m
//  page
//
//  Created by Jay on 7/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPTopView.h"

@interface SPTopView ()
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *markButton;

@end

@implementation SPTopView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backButton];
        [self addSubview:self.markButton];
    }
    return self;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"G_Back_0"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UIButton *)markButton{
    if (!_markButton) {
        _markButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_markButton setImage:[UIImage imageNamed:@"RM_17"] forState:UIControlStateNormal];
        [_markButton setImage:[UIImage imageNamed:@"RM_18"] forState:UIControlStateSelected];

    }
    return _markButton;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 按钮宽
    CGFloat buttonW = 50;
    
    // 返回按钮
    _backButton.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, buttonW, self.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    
    // 书签按钮
    _markButton.frame = CGRectMake(self.bounds.size.width - buttonW, [UIApplication sharedApplication].statusBarFrame.size.height, buttonW, self.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);


}

@end
