//
//  SPFuncView.h
//  page
//
//  Created by Jay on 9/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    SPFuncViewTypeEffect,
    SPFuncViewTypeFont,
    SPFuncViewTypeFontSize,
} SPFuncViewType;



@interface SPFuncView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                     funcType:(SPFuncViewType)type
                        title:(NSString *)title
                       labels:(NSArray <NSString *> *)labels
                  selectIndex:(NSInteger )index;

@end
