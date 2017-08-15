//
//  UINavigationController+FullscreenPopGesture.m
//  tv
//
//  Created by windy on 2017/3/30.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "UINavigationController+FullscreenPopGesture.h"
#import <objc/runtime.h>

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define kWidth      [UIScreen mainScreen].bounds.size.width

@interface PopManager : NSObject <UIGestureRecognizerDelegate>
@property(nonatomic, assign) CGPoint startTouch;
@property(nonatomic, strong) UIImageView *lastScreenShotView;
@property(nonatomic, strong) UIView *blackMask;
@property(nonatomic, strong) UIView *backgroundView;
@property(nonatomic, strong) NSMutableArray *screenShotsList;
@property(nonatomic, strong) UIPanGestureRecognizer *pan;
@end

static PopManager *_manager;

@implementation PopManager

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint pt =  [gestureRecognizer locationInView:gestureRecognizer.view];
    if (pt.x > 0.7*kWidth) {
        return NO;
    }
    return YES;
}

+ (instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [PopManager new];
    });
    return _manager;
}
-(NSMutableArray *)screenShotsList{
    if (_screenShotsList == nil) {
        _screenShotsList = [NSMutableArray array];
    }
    return _screenShotsList;
}
+ (UIImage *)capture:(UIViewController *)rootVC
{
    CGRect r=rootVC.view.bounds;
    CGRect r2=[UIApplication sharedApplication].keyWindow.frame;
    if (r2.size.height<1.0) {
        r2=r;
    }
    UIGraphicsBeginImageContextWithOptions(r2.size, rootVC.view.opaque, 0.0);
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
+ (void)removeLastImg{
    [_manager.screenShotsList removeLastObject];
    _manager.backgroundView.hidden = YES;
    NSLog(@"移除截图---%lu",(unsigned long)_manager.screenShotsList.count);
}

+ (void)addImg:(UIViewController *)rootVC{
    [_manager.screenShotsList addObject:[self capture:rootVC]];
    NSLog(@"截图---%lu",(unsigned long)_manager.screenShotsList.count);
}

+ (void)addPan:(UIPanGestureRecognizer *)pan byVC:(UINavigationController *)rootVC{
    
    if (rootVC.childViewControllers.count==1) {
        [rootVC.view addGestureRecognizer:pan];
        rootVC.interactivePopGestureRecognizer.enabled = NO;
    }
    
}
+ (void)removePan:(UIPanGestureRecognizer *)pan byVC:(UIViewController *)rootVC{
    if (rootVC.childViewControllers.count == 2){
        [rootVC.view removeGestureRecognizer:pan];
    }
}


@end

@implementation UINavigationController (FullscreenPopGesture)


#pragma mark ******************************************交换系统的方法********************************************************
#pragma mark
+ (void)load
{
    [PopManager manager];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelectorPush = @selector(pushViewController:animated:);
        SEL swizzledSelectorPush = @selector(cz_pushViewController:animated:);
        
        Method originalMethodPush = class_getInstanceMethod(class, originalSelectorPush);
        Method swizzledMethodPush = class_getInstanceMethod(class, swizzledSelectorPush);
        
        BOOL successPush = class_addMethod(class, originalSelectorPush, method_getImplementation(swizzledMethodPush), method_getTypeEncoding(swizzledMethodPush));
        if (successPush) {
            class_replaceMethod(class, swizzledSelectorPush, method_getImplementation(originalMethodPush), method_getTypeEncoding(originalMethodPush));
        } else {
            method_exchangeImplementations(originalMethodPush, swizzledMethodPush);
        }
        
        /////////////
        
        SEL originalSelectorPop = @selector(popViewControllerAnimated:);
        SEL swizzledSelectorPop = @selector(cz_popViewControllerAnimated:);
        
        Method originalMethodPop = class_getInstanceMethod(class, originalSelectorPop);
        Method swizzledMethodPop = class_getInstanceMethod(class, swizzledSelectorPop);
        
        BOOL successPop = class_addMethod(class, originalSelectorPop, method_getImplementation(swizzledMethodPop), method_getTypeEncoding(swizzledMethodPop));
        if (successPop) {
            class_replaceMethod(class, swizzledSelectorPop, method_getImplementation(originalMethodPop), method_getTypeEncoding(originalMethodPop));
        } else {
            method_exchangeImplementations(originalMethodPop, swizzledMethodPop);
        }
        
        //////////
        /////////////
        
        SEL originalSelectorDisappear = @selector(viewDidDisappear:);
        SEL swizzledSelectorDisappear = @selector(cz_viewDidDisappear:);
        
        Method originalMethodDisappear = class_getInstanceMethod(class, originalSelectorDisappear);
        Method swizzledMethodDisappear = class_getInstanceMethod(class, swizzledSelectorDisappear);
        
        BOOL successDisappear = class_addMethod(class, originalSelectorDisappear, method_getImplementation(swizzledMethodDisappear), method_getTypeEncoding(swizzledMethodDisappear));
        if (successDisappear) {
            class_replaceMethod(class, swizzledSelectorDisappear, method_getImplementation(originalMethodDisappear), method_getTypeEncoding(originalMethodDisappear));
        } else {
            method_exchangeImplementations(originalMethodDisappear, swizzledMethodDisappear);
        }
    });
}

#pragma mark ******************************************覆盖系统方法********************************************************
#pragma mark
-(void)cz_viewDidDisappear:(BOOL)animated
{
    _manager.pan = nil;
    [self cz_viewDidDisappear:animated];
}
- (UIViewController *)cz_popViewControllerAnimated:(BOOL)animated
{
    [PopManager removeLastImg];
    [PopManager removePan:self.pan byVC:self];
    return [self cz_popViewControllerAnimated:animated];
}

- (void)cz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [PopManager addImg:self];
    [PopManager addPan:self.pan byVC:self];
    [self cz_pushViewController:viewController animated:animated];
}




#pragma mark ******************************************自定义方法********************************************************
#pragma mark

- (UIPanGestureRecognizer *)pan{
    if (_manager.pan == nil) {
        _manager.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                              action:@selector(paningGestureReceive:)];
        [_manager.pan delaysTouchesBegan];
        _manager.pan.delegate = _manager;
    }
    return _manager.pan;
}


- (void)moveViewWithX:(float)x
{
    //   在这处理动画
    x = x > kWidth ? kWidth:x;
    x = x < 0 ? 0 : x;
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
//    float alpha = 1.0 - (x/kWidth);
    
    frame.origin.x = x*0.2 - 0.2 * kWidth;
    
    _manager.backgroundView.frame = frame;
//    _manager.blackMask.alpha = alpha;
    
    
}

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1) return;
    
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan)
    {
        _manager.startTouch = touchPoint;
        if (!_manager.backgroundView||!_manager.backgroundView.superview)
        {
            //NSLog(@"2");
            CGRect frame = self.view.frame;
            
            _manager.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            _manager.backgroundView.backgroundColor=[UIColor orangeColor];
            [self.view.superview insertSubview:_manager.backgroundView belowSubview:self.view];
            
        }
        _manager.backgroundView.hidden = NO;
        
        
        if (_manager.lastScreenShotView) [_manager.lastScreenShotView removeFromSuperview];
        //NSLog(@"2--1");
        
        UIImage *lastScreenShot = [_manager.screenShotsList lastObject];
        _manager.lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [_manager.backgroundView addSubview:_manager.lastScreenShotView];
//        _manager.blackMask = [[UIView alloc] initWithFrame:_manager.lastScreenShotView.bounds];
//        [_manager.backgroundView addSubview:_manager.blackMask];
//        _manager.blackMask.backgroundColor = [UIColor grayColor];
        
        //加阴影--任海丽编辑
        self.view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        self.view.layer.shadowOffset = CGSizeMake(-1,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        self.view.layer.shadowRadius = 3;//阴影半径，默认3

        
        
        //NSLog(@"began");
    }else if (recoginzer.state == UIGestureRecognizerStateChanged) {
        //NSLog(@"change");
        [self moveViewWithX:touchPoint.x - _manager.startTouch.x];
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded) {
        
        //NSLog(@"end");
        if (touchPoint.x - _manager.startTouch.x > 0.5*kWidth)
        {
            //NSLog(@"3");
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:kWidth];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _manager.backgroundView.hidden = YES;
                
            }];
            
        }
    }
}


@end
