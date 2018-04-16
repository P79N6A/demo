//
//  TTZDateTextField.h
//  DateKeyboard
//
//  Created by Jay on 2018/4/13.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE

@interface TTZDateTextField : UITextField

@property (nonatomic, strong)IBInspectable NSDate *minDate;
@property (nonatomic, strong)IBInspectable NSDate *maxDate;

@end
