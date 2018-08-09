//
//  SPSettingView.m
//  page
//
//  Created by Jay on 9/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPSettingView.h"
#import "SPColorView.h"

#import "const.h"

@interface SPSettingView ()
@property (nonatomic, weak) SPColorView *colorView;
@end
@implementation SPSettingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        NSArray *colors = @[[UIColor whiteColor],DZMReadBGColor_1,DZMReadBGColor_2,DZMReadBGColor_3,DZMReadBGColor_4,DZMReadBGColor_5];
        [self addSubview:({
            SPColorView *colorView = [[SPColorView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 74) colors:colors selectIndex:0];
            
            colorView;
        })];

    }
    return self;
}

@end
