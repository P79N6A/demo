//
//  SwipeViewController.m
//  动画_test
//
//  Created by YangJingping on 16/7/7.
//  Copyright © 2016年 YangJingping. All rights reserved.
//

#import "SwipeViewController.h"

@interface SwipeViewController ()

@property(nonatomic,assign)CGFloat persentCompleted;
@property(nonatomic,strong)UIViewController *dissmissVC;

@end

@implementation SwipeViewController


- (void)handleDismissViewController:(UIViewController *)controller
{
    self.dissmissVC = controller;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [controller.view addGestureRecognizer:pan];
}

-(CGFloat )completionSpeed
{
    return 1 - self.persentCompleted;
}

-(void)panAction:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture translationInView:self.dissmissVC.view];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            
            self.interacting = YES;
            
            [self.dissmissVC dismissViewControllerAnimated:YES completion:nil];
            
            break;
        }
        
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat persent = (point.y/500) <=1 ?(point.y/500):1;
            
            self.persentCompleted = persent;
            
            [self updateInteractiveTransition:persent];
            break;
        }
        
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            
            self.interacting = NO;
            
            if (gesture.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }else{
                [self finishInteractiveTransition];
            }
            break;
        }
            
        default:
            break;
    }
    
}


@end
