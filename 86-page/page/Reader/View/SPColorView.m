 //
//  SPColorView.m
//  page
//
//  Created by Jay on 9/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPColorView.h"
#import "SPHaloButton.h"
#import "SPReadConfig.h"

#import "const.h"


@interface SPColorView()
@property (nonatomic, strong) NSArray <UIColor *> *colors;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, weak) SPHaloButton *selectButton;
@end

@implementation SPColorView


- (instancetype)initWithFrame:(CGRect)frame
                       colors:(NSArray <UIColor *>*)colors
                  selectIndex:(NSInteger )index
{
    self = [super initWithFrame:frame];
    if (self) {
        self.colors = colors;
        self.selectIndex = index;
        
        NSInteger count = colors.count;
        if (self.selectIndex >= count) {
            self.selectIndex = 0;
        }
        CGFloat publicButtonWH = [SPHaloButton HaloButtonSize:CGSizeMake(39, 39)].width;
        CGFloat spaceW = (ScreenWidth - 2 * DZMSpace_1 - count * publicButtonWH) / (count - 1);
        for (NSInteger i = 0; i < count; i ++) {
            UIColor *color = self.colors[i];
            SPHaloButton *publicButton = [[SPHaloButton alloc] initWithFrame:CGRectMake(DZMSpace_1 + i * (publicButtonWH + spaceW), DZMSpace_1,  publicButtonWH, publicButtonWH) haloColor:color];
            publicButton.tag = i;
            publicButton.layer.cornerRadius = publicButtonWH * 0.5;
            [publicButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:publicButton];
            if (self.selectIndex == i) {
                [self selectButton:publicButton];
            }
        }
    }
    return self;
}




- (void)clickButton:(SPHaloButton *)sender{
    [self selectButton:sender];
    [SPReadConfig defaultConfig].themeType = sender.tag;
    [[NSNotificationCenter defaultCenter] postNotificationName:DZMNotificationNameThemeColorChange object:nil];
    
    NSLog(@"%s-DZMNotificationNameThemeColorChange-%ld", __func__,(long)sender.tag);
}

- (void)selectButton:(SPHaloButton *)sender{
    
    self.selectButton.spImageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.selectButton.spImageView.layer.borderWidth = 0;
    
    sender.spImageView.layer.borderColor = DZMColor_2.CGColor;
    sender.spImageView.layer.borderWidth = 2.0;
    
    self.selectButton = sender;
}


@end


