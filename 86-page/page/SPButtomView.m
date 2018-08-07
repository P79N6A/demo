//
//  SPButtomView.m
//  page
//
//  Created by Jay on 7/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPButtomView.h"

@interface SPButtomView ()
@property (nonatomic,strong) UIButton *previousChapter;
@property (nonatomic,strong) UIButton *nextChapter;

@end

@implementation SPButtomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *funcIcons = @[@"read_bar_0",@"read_bar_1",@"read_bar_2",@"read_bar_3"];
        for (NSString *icon in funcIcons) {
            // 创建按钮
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
            button.tag = [funcIcons indexOfObject:icon];
            [self addSubview:button];
        }
        
    }
    return self;
}


@end
