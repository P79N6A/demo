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



- (void)showLoading:(NSString *)message {
    if (!self.loadingView) {
        UIActivityIndicatorView * loadingView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
        loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self addSubview:loadingView];
        loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.loadingView = loadingView;
    }
    if(!self.loadingView.isAnimating) [self.loadingView startAnimating];
    
    if (message.length) {
        if (!self.loadingLabel) {
            UILabel * loadingLabel = [[UILabel alloc] initWithFrame:self.loadingView.bounds];
            loadingLabel.center = CGPointMake(loadingLabel.center.x, loadingLabel.center.y + 25);
            loadingLabel.textColor = [UIColor whiteColor];
            loadingLabel.font = [UIFont systemFontOfSize:13.0];
            loadingLabel.textAlignment = NSTextAlignmentCenter;
            [self.loadingView addSubview:loadingLabel];
            self.loadingLabel = loadingLabel;
        }
        self.loadingLabel.text = message;
        
    }else{
        if (self.loadingLabel){
            [self.loadingLabel removeFromSuperview];
            self.loadingLabel = nil;
        }
    }
    self.userInteractionEnabled = NO;
}

/**
 移除loading
 */
- (void)removeLoading {
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
        self.loadingLabel = nil;

    }
    self.userInteractionEnabled = YES;
}

- (void)hideLoading:(NSString *)msg
{
    [self removeLoading];
    if (msg.length) {
        [self showHud:msg];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)showHud:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil//@"温馨提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [self performSelector:@selector(dimissAlert:)withObject:alert afterDelay:1.5];
}

- (void)dimissAlert:(UIAlertView *)alert{
    if(alert){
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}
#pragma clang diagnostic pop





@end
