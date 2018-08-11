//
//  SPColorView.h
//  page
//
//  Created by Jay on 9/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPColorView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                       colors:(NSArray <UIColor *>*)colors
                  selectIndex:(NSInteger )index;

@end
