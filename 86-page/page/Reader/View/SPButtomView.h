//
//  SPButtomView.h
//  page
//
//  Created by Jay on 7/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPButtomView : UIView
@property (nonatomic, copy) void (^funClick)(NSInteger code);
@end
