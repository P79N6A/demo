//
//  SPStatusView.m
//  page
//
//  Created by Jay on 8/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPStatusView.h"
#import "SPBatteryView.h"

#import "const.h"


@interface SPStatusView ()
@property (nonatomic, weak)  SPBatteryView *batteryView;
@property (nonatomic, weak)  UILabel *timeLabel;
@property (nonatomic, weak)  NSTimer *timer;

@end
@implementation SPStatusView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        //self.backgroundColor = [DZMColor_1 colorWithAlphaComponent:0.4];
        
        [self addSubview:({
            
            SPBatteryView *batteryView = [[SPBatteryView alloc] init];
            _batteryView = batteryView;
            batteryView.tintColor = [UIColor colorWithRed:127/255.0 green:136/255.0 blue:138/255.0 alpha:1.0];
            [UIDevice currentDevice].batteryMonitoringEnabled = YES;
            batteryView.batteryLevel = [UIDevice currentDevice].batteryLevel;
            batteryView;
        })];
        
        
        [self addSubview:({
            UILabel *timeLabel = [[UILabel alloc] init];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.font = DZMFont_12;
            timeLabel.textColor = DZMColor_3;
            _timeLabel = timeLabel;
            timeLabel;
        })];

        
        [self addSubview:({
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = DZMFont_12;
            titleLabel.textColor = DZMColor_3;
            _titleLabel = titleLabel;
            titleLabel;
        })];
        
        [self didChangeTime];
        
        [self addTimer];
        
    }
    return self;
}


- (NSString *)GetCurrentTimerString:(NSString *)dateFormat{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = dateFormat;
    return [dateformatter stringFromDate:[NSDate date]];
}




- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat space = isX ? DZMSpace_1 : 0;
    self.batteryView.frame = CGRectMake(self.bounds.size.width - 25 - space, 0.5 * (self.bounds.size.height - 10), 25, 10);
    
    CGFloat timeLabelW = DZMSizeW(50);
    self.timeLabel.frame = CGRectMake(self.batteryView.frame.origin.x - timeLabelW, 0, timeLabelW, self.bounds.size.height);
    
    self.titleLabel.frame = CGRectMake(space, 0, self.timeLabel.frame.origin.x - space, self.bounds.size.height);
    
}

- (void)addTimer{
    if (!_timer) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(didChangeTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
}

- (void)removeTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)didChangeTime{
    self.timeLabel.text = [self GetCurrentTimerString:@"HH:mm"];
    self.batteryView.batteryLevel = [UIDevice currentDevice].batteryLevel;
}

- (void)dealloc{
    [self removeTimer];
}

@end
