//
//  TTZDateTextField.m
//  DateKeyboard
//
//  Created by Jay on 2018/4/13.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZDateTextField.h"

@interface TTZDateTextField()
@property (nonatomic, strong) UIDatePicker *keyboard;
@end

@implementation TTZDateTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUI];
}


- (void)setUI{
//
//    UIDatePicker *picker = [[UIDatePicker alloc] init];
//    picker.datePickerMode = UIDatePickerModeDate;
//    picker.minimumDate = [NSDate date];
//    picker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:15 * 24 * 3600];
    self.inputView = self.keyboard;
}


- (void)setMaxDate:(NSDate *)maxDate{
    _maxDate = maxDate;
    self.keyboard.maximumDate = maxDate;
}

- (void)setMinDate:(NSDate *)minDate{
    _minDate = minDate;
    self.keyboard.minimumDate = minDate;
}

- (UIDatePicker *)keyboard{
    if (!_keyboard) {
        _keyboard = [[UIDatePicker alloc] init];
        _keyboard.datePickerMode = UIDatePickerModeDate;
        _keyboard.minimumDate = [NSDate date];
    }
    return _keyboard;
}

@end
