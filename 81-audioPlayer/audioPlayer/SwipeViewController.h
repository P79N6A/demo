//
//  SwipeViewController.h
//  动画_test
//
//  Created by YangJingping on 16/7/7.
//  Copyright © 2016年 YangJingping. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PresentToViewController;

/**/

@interface SwipeViewController : UIPercentDrivenInteractiveTransition

@property(nonatomic,assign)BOOL interacting;

- (void)handleDismissViewController:(UIViewController *)controller;

@end
