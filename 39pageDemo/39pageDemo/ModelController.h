//
//  ModelController.h
//  39pageDemo
//
//  Created by FEIWU888 on 2017/10/30.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end

