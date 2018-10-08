//
//  SPFuncView.m
//  page
//
//  Created by Jay on 9/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPFuncView.h"
#import "SPReadConfig.h"
#import "const.h"


@interface SPFuncView()
@property (nonatomic, assign) SPFuncViewType funcType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray <NSString *> *labels;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, assign) NSInteger fontSpace; // 1

@end

@implementation SPFuncView

- (instancetype)initWithFrame:(CGRect)frame
                     funcType:(SPFuncViewType)type
                        title:(NSString *)title
                       labels:(NSArray <NSString *> *)labels
                  selectIndex:(NSInteger )index{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.funcType = type;
        self.title = title;
        self.labels = labels;
        self.selectIndex = index;
        
        [self addSubview:({
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = DZMFont_12;
            titleLabel.text = title;
            titleLabel.frame = CGRectMake(DZMSpace_2, 0, 55, frame.size.height);
            _titleLabel = titleLabel;
            titleLabel;
        })];
        
        CGFloat tempX = CGRectGetMaxX(_titleLabel.frame) + DZMSizeW(50);
        CGFloat contentW = ScreenWidth - tempX;
        if (self.funcType == SPFuncViewTypeFont || self.funcType == SPFuncViewTypeEffect) {
            NSInteger count = labels.count;
            CGFloat buttonW = contentW / count;
            for (NSInteger i = 0; i < count; i ++) {
                NSString *label = self.labels[i];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = i;
                button.titleLabel.font = DZMFont_12;
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [button setTitle:label forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitleColor:DZMColor_2 forState:UIControlStateSelected];
                button.frame = CGRectMake(tempX + i * buttonW,0, buttonW, frame.size.height);
                [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                if (i == self.selectIndex) {
                    [self selectButton:button];
                }
            }
        }else{
            
            CGFloat buttonW = (contentW - DZMSpace_1 + DZMSpace_3) / 2;
            CGFloat buttonSpaceW = DZMSpace_3;
            //
            //            // left
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            leftButton.tag = 0;
            leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [leftButton setImage:[UIImage imageNamed:@"RM_15"] forState:UIControlStateNormal];
            leftButton.frame = CGRectMake(tempX, 0, buttonW, frame.size.height);
            [leftButton addTarget:self action:@selector(clickFontSize:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:leftButton];
            _leftButton = leftButton;
                        // right
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rightButton.tag = 1;
            rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [rightButton setImage:[UIImage imageNamed:@"RM_16"] forState:UIControlStateNormal];
            rightButton.frame = CGRectMake(CGRectGetMaxX(leftButton.frame) - buttonSpaceW, 0, buttonW, frame.size.height);
            [rightButton addTarget:self action:@selector(clickFontSize:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:rightButton];
            _rightButton = rightButton;

        }
    }
    return self;
}


- (void)clickFontSize:(UIButton *)sender{
    
    
    if (sender.tag == 0) {//left

        if (([SPReadConfig defaultConfig].fontSize - 1) >= DZMReadMinFontSize) {
            
            [SPReadConfig defaultConfig].fontSize = [SPReadConfig defaultConfig].fontSize - 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:DZMNotificationNameFontSizeChange object:nil];
            [self.superview.superview.superview setNeedsDisplay];
        }
        return;
    }
    
    if (([SPReadConfig defaultConfig].fontSize + 1) <= DZMReadMaxFontSize) {
        
        [SPReadConfig defaultConfig].fontSize = [SPReadConfig defaultConfig].fontSize + 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:DZMNotificationNameFontSizeChange object:nil];
        
    }
    

    
}
- (void)clickButton:(UIButton *)sender{
    if(sender.isSelected) return;
    [self selectButton:sender];
    
    //字体
    if (self.funcType == SPFuncViewTypeFont) {
        [SPReadConfig defaultConfig].fontType = sender.tag;
        [[NSNotificationCenter defaultCenter] postNotificationName:DZMNotificationNameFontChange object:nil];
        return;
    }
    // 动画
    if (self.funcType == SPFuncViewTypeEffect) {

        return;
    }

    
}


- (void)selectButton:(UIButton *)sender{
    if(sender.isSelected) return;
    
    self.selectButton.selected = NO;
    
    sender.selected = YES;
    
    self.selectButton = sender;
}

@end

//

