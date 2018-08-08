//
//  SPButtomView.m
//  page
//
//  Created by Jay on 7/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPButtomView.h"

@interface SPButtomView ()
@property (nonatomic, weak) UIButton *previousChapter;
@property (nonatomic, weak) UIButton *nextChapter;
@property (nonatomic, weak) UISlider *slider;
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
        

        [self addSubview:({
            
            UIButton *previousChapter = [UIButton buttonWithType:UIButtonTypeCustom];
            [previousChapter setTitle:@"上一章" forState:UIControlStateNormal];
            previousChapter.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            previousChapter.titleLabel.font = [UIFont systemFontOfSize:12];
            [previousChapter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _previousChapter = previousChapter;
            previousChapter;
        })];
        
        [self addSubview:({
            
            UIButton *nextChapter = [UIButton buttonWithType:UIButtonTypeCustom];
            [nextChapter setTitle:@"下一章" forState:UIControlStateNormal];
            nextChapter.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            nextChapter.titleLabel.font = [UIFont systemFontOfSize:12];
            [nextChapter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _nextChapter = nextChapter;
            nextChapter;
        })];
        
        
        [self addSubview:({
            
            UISlider *slider = [[UISlider alloc] init];
            [slider setThumbImage:[UIImage imageNamed:@"RM_3"] forState:UIControlStateNormal];
            slider.maximumValue = 1.0;
            slider.maximumValue = 1.0;
            _slider = slider;
            slider;
        })];

        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.previousChapter.frame = CGRectMake(0, 10, 55, 32);
    self.nextChapter.frame = CGRectMake(self.bounds.size.width - self.previousChapter.bounds.size.width, 10, 55, 32);
    CGFloat sx = CGRectGetMaxX(self.previousChapter.frame) + 10;
    CGFloat sw = self.bounds.size.width - 2 * sx;
    self.slider.frame = CGRectMake(sx, 10, sw, 32);
    
    CGFloat count = 4;
    CGFloat buttonY = CGRectGetMaxY(self.previousChapter.frame) ;
    CGFloat buttonH = self.bounds.size.height - buttonY;
    CGFloat buttonW = self.bounds.size.width / count;
    for (NSInteger i = 0; i < count; i ++) {
        UIView *btn = self.subviews[i];
        btn.frame = CGRectMake(i * buttonW, buttonY, buttonW, buttonH);
    }

}

@end
