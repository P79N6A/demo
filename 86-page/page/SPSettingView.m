//
//  SPSettingView.m
//  page
//
//  Created by Jay on 9/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPSettingView.h"
#import "SPColorView.h"
#import "SPFuncView.h"

#import "const.h"

@interface SPSettingView ()
@property (nonatomic, weak) SPColorView *colorView;
@property (nonatomic, weak) SPFuncView *effectView;
@property (nonatomic, weak) SPFuncView *fontView;
@property (nonatomic, weak) SPFuncView *fontSizeView;

@end
@implementation SPSettingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        NSArray *colors = @[[UIColor whiteColor],DZMReadBGColor_1,DZMReadBGColor_2,DZMReadBGColor_3,DZMReadBGColor_4,DZMReadBGColor_5];
        [self addSubview:({
            SPColorView *colorView = [[SPColorView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 74) colors:colors selectIndex:0];
            _colorView = colorView;
            colorView;
        })];
        
        
        // funcViewH
        CGFloat funcViewH = (frame.size.height - (isX ? DZMSpace_1 : 0) - 74) / 3.0;
        
        [self addSubview:({
            
            SPFuncView *effectView = [[SPFuncView alloc] initWithFrame:CGRectMake(0,74, ScreenWidth, funcViewH)
                                                              funcType:SPFuncViewTypeEffect
                                                                 title:@"翻书动画"
                                                                labels:@[@"无效果",@"平移",@"仿真",@"上下"]
                                                           selectIndex:2];
            _effectView = effectView;
            effectView;
        })];
        
        [self addSubview:({
            
            SPFuncView *fontView = [[SPFuncView alloc] initWithFrame:CGRectMake(0,74 + funcViewH, ScreenWidth, funcViewH)
                                                              funcType:SPFuncViewTypeFont
                                                                 title:@"字体"
                                                                labels:@[@"系统",@"黑体",@"楷体",@"宋体"]
                                                           selectIndex:0];
            _fontView = fontView;
            fontView;
        })];

        
        
        [self addSubview:({
            
            SPFuncView *fontSizeView = [[SPFuncView alloc] initWithFrame:CGRectMake(0,74 + funcViewH * 2, ScreenWidth, funcViewH)
                                                            funcType:SPFuncViewTypeFontSize
                                                               title:@"字号"
                                                              labels:@[]
                                                         selectIndex:0];
            _fontSizeView = fontSizeView;
            fontSizeView;
        })];


    }
    return self;
}

@end
