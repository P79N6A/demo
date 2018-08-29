//
//  UIButton+loading.h
//  test
//
//  Created by Jay on 14/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, TTControlState) {
    TTControlStateNormal       = UIControlStateNormal,
    TTControlStateHighlighted  = UIControlStateHighlighted,                  // used when UIControl isHighlighted is set
    TTControlStateDisabled     = UIControlStateDisabled,
    TTControlStateSelected     = UIControlStateSelected,                  // flag usable by app (see below)
    TTControlStateFocused NS_ENUM_AVAILABLE_IOS(9_0) = UIControlStateFocused, // Applicable only when the screen supports focus
    TTControlStateLoading     = 1 << 4,                  // flag usable by app (see below)

    TTControlStateApplication  = UIControlStateApplication,              // additional flags available for application use
    TTControlStateReserved     = UIControlStateReserved               // flags reserved for internal framework use
};

@interface UIButton (loading)
@property (nonatomic, assign) BOOL loading;
- (void)setTitle:(NSString *)title forState:(TTControlState)state;
@end
