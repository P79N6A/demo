//
//  IQAnimationImageView.h
//  liwu
//
//  Created by czljcb on 2017/8/27.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IQAnimationImageView : UIImageView


- (void)startAnimating;


/** <##> */
@property (nonatomic, assign) useconds_t displayTime;//

/** <##> */
@property (nonatomic, strong) NSArray <NSString *> *filePaths;

@property (nonatomic, copy) void (^completionBlock)();

/** <##> */
@property (nonatomic, assign,readonly) BOOL isDisplaying;

@end

