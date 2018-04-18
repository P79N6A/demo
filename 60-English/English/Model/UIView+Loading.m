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
    [self showLoadingWithColor:[UIColor grayColor]];//
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
        
        self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 74)];
        self.loadingLabel.layer.cornerRadius = 10;
        self.loadingLabel.layer.masksToBounds = YES;
        self.loadingLabel.textColor = [UIColor whiteColor];
        self.loadingLabel.font = [UIFont systemFontOfSize:18];
        self.loadingLabel.text = msg;
        self.loadingLabel.numberOfLines = 2;
        self.loadingLabel.textAlignment = NSTextAlignmentCenter;
        self.loadingLabel.center = self.center;
        [self addSubview:self.loadingLabel];
        self.loadingLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                self.loadingLabel.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.loadingLabel removeFromSuperview];
            }];
        });
    }
}

@end
