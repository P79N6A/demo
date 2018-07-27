//
//  TransFromAnimation.m
//  audioPlayer
//
//  Created by Jay on 27/7/18.
//  Copyright © 2018年 Jayson. All rights reserved.
//

#import "TransFromAnimation.h"

@interface TransFromAnimation ()

@property(nonatomic,assign)YJPPresentAnimationType type;

@end

@implementation TransFromAnimation

+(instancetype)transfromWithAnimationType:(YJPPresentAnimationType)type
{
    return [[self alloc]initWithAnimationType:type];
}

-(instancetype)initWithAnimationType:(YJPPresentAnimationType)type
{
    if (self = [super init]) {
        self.type=type;
    }
    return self;
}


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (_type == YJPPresentAnimationPresent) {
        [self presentVC:transitionContext];
    }
    else if (_type == YJPPresentAnimationDismiss)
    {
        [self dismissVC:transitionContext];
    }
}


#pragma mark -
-(void)presentVC:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIView *presentView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [transitionContext.containerView addSubview:presentView];
    
    presentView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    [UIView animateWithDuration:0.25 animations:^{
        presentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
    
}

#pragma mark -
-(void)dismissVC:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    
    UIView *presentView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [transitionContext.containerView addSubview:presentView];
    
    [UIView animateWithDuration:0.25 animations:^{
        presentView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];

    }



@end
