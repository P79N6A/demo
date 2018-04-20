//
//  UIView+Loading.m
//  BBKorean
//
//  Created by czljcb on 2018/3/28.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "UIView+Loading.h"
#import <objc/runtime.h>

static char ACTIVITY_INDICATOR_KEY;
static char ACTIVITY_LABEL_KEY;

@implementation UIView (Loading)

- (UIActivityIndicatorView *)loadingView {
    return objc_getAssociatedObject(self, &ACTIVITY_INDICATOR_KEY);
}

- (void)setLoadingView:(UIActivityIndicatorView *)loadingView {
    objc_setAssociatedObject(self, &ACTIVITY_INDICATOR_KEY, loadingView, OBJC_ASSOCIATION_RETAIN);
}

- (UILabel *)loadingLabel {
    return objc_getAssociatedObject(self, &ACTIVITY_LABEL_KEY);
}

- (void)setLoadingLabel:(UILabel *)loadingLabel {
    objc_setAssociatedObject(self, &ACTIVITY_LABEL_KEY, loadingLabel, OBJC_ASSOCIATION_RETAIN);
}

/**
 展示loading（默认灰色）
 */
- (void)showLoading {
    // 默认展示灰色loading
    //[self showLoadingWithColor:[UIColor grayColor]];//
    [self showLoadingWithColor:[UIColor whiteColor]];//
}

/**
 展示指定颜色的loading
 
 @param color loading的颜色
 */
- (void)showLoadingWithColor:(UIColor *)color {
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }
    self.loadingView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
    self.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self addSubview:self.loadingView];
    self.loadingView.color = color;
    self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.loadingView startAnimating];
    self.loadingView.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
}

/**
 移除loading
 */
- (void)removeLoading {
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }
}

- (void)hideLoading:(NSString *)msg
{
    [self removeLoading];
    self.userInteractionEnabled = YES;
    
    if (msg.length) {
        [self showHud:msg];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)showHud:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [self performSelector:@selector(dimissAlert:)withObject:alert afterDelay:1.0];
}

- (void)dimissAlert:(UIAlertView *)alert{
    if(alert){
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}
#pragma clang diagnostic pop





@end
