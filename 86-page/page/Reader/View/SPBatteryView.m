//
//  SPBatteryView.m
//  page
//
//  Created by Jay on 8/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPBatteryView.h"

@interface SPBatteryView ()
@property (nonatomic,weak) UIView *batteryLevelView;

@end


@implementation SPBatteryView

- (void)setTintColor:(UIColor *)tintColor{
    [super setTintColor:tintColor];
    self.batteryLevelView.backgroundColor = tintColor;
}

- (void)setBatteryLevel:(CGFloat)batteryLevel{
    _batteryLevel = batteryLevel;
    [self setNeedsLayout];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, 25, 10)];
    if (self) {
        
        
        [self addSubview:({
            
            UIView *batteryLevelView = [UIView new];
            batteryLevelView.layer.masksToBounds = YES;
            _batteryLevelView = batteryLevelView;
            batteryLevelView;
            
        })];

        self.image = [[UIImage imageNamed:@"G_Battery_Black"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.tintColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    frame = CGRectMake(frame.origin.x, frame.origin.y, 25.0, 10.0);
    [super setFrame:frame];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat spaceW = 1 * (self.frame.size.width / 25.0) * 20.0/25.0;
    CGFloat spaceH = 1 * (self.frame.size.height / 10.0) * 20.0/25.0;
    
    CGFloat batteryLevelViewY = 2.1 * spaceH;
    CGFloat batteryLevelViewX = 1.4 * spaceW;
    CGFloat batteryLevelViewH = self.frame.size.height - 3.4 * spaceH;
    CGFloat batteryLevelViewW = self.frame.size.width  * 20.0 / 25.0;
    CGFloat batteryLevelViewWScale = batteryLevelViewW/100.0;
    
    CGFloat tempBatteryLevel = _batteryLevel;
    if (_batteryLevel < 0) {
        tempBatteryLevel = 0;
    }else if (_batteryLevel > 1){
        tempBatteryLevel = 1.0;
    }
    
    self.batteryLevelView.frame = CGRectMake(batteryLevelViewX, batteryLevelViewY, tempBatteryLevel * 100 * batteryLevelViewWScale, batteryLevelViewH);
    
    self.batteryLevelView.layer.cornerRadius = batteryLevelViewH * 0.125;
}

@end
