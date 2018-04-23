//
//  UIView+Loading.m
//  WebPlayer
//
//  Created by czljcb on 2018/3/6.
//  Copyright © 2018年 Jay. All rights reserved.
//

//
//  UIView+Loading.m
//  AlamofireDemo
//
//  Created by Jay on 2018/2/2.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "UIView+Loading.h"
#import <objc/runtime.h>

static char ACTIVITY_INDICATOR_KEY;
static char ACTIVITY_LABEL_KEY;
static char IMAGE_VIEW_KEY;


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

- (void)setImageView:(UIView *)imageView{
    objc_setAssociatedObject(self, &IMAGE_VIEW_KEY, imageView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)imageView{
    return objc_getAssociatedObject(self, &IMAGE_VIEW_KEY);
}

/**
 展示loading（默认灰色）
 */
- (void)showLoading {
    // 默认展示灰色loading
    //    [self showLoadingWithColor:[UIColor grayColor]];//
    [self showLoadingWithColor:[UIColor whiteColor] msg:nil];//
    
}

/**
 展示loading（默认灰色）
 */
- (void)showLoading:(NSString *)msg {
    // 默认展示灰色loading
    //    [self showLoadingWithColor:[UIColor grayColor]];//
    [self showLoadingWithColor:[UIColor whiteColor] msg:msg];//
    
}


/**
 展示指定颜色的loading
 
 @param color loading的颜色
 */
- (void)showLoadingWithColor:(UIColor *)color
                         msg:(NSString *)msg{
    
    if (!self.loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
        loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        loadingView.color = color;
        loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:loadingView];
        self.loadingView = loadingView;
    }
    
    [self.loadingView startAnimating];
    
    if (!msg.length) {
        if (self.loadingLabel) {
            [self.loadingLabel removeFromSuperview];
            self.loadingLabel = nil;
        }
    }else{
        if (!self.loadingLabel) {
            UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.loadingView.bounds.size.width, 20)];
            loadingLabel.center = CGPointMake(self.loadingView.center.x,self.loadingView.center.y + 35 );
            loadingLabel.textColor = [UIColor whiteColor];
            loadingLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:loadingLabel];
            self.loadingLabel = loadingLabel;
        }
        self.loadingLabel.text = msg;
    }
    
    self.userInteractionEnabled = NO;
    
}

/**
 移除loading
 */
- (void)removeLoading{
    self.userInteractionEnabled = YES;
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }
    if (self.loadingLabel) {
        [self.loadingLabel removeFromSuperview];
        self.loadingLabel = nil;
    }
    //    if (self.loadingView) {
    //        [UIView animateWithDuration:0.25 animations:^{
    //            self.loadingView.alpha = 0.0;
    //            self.loadingLabel.alpha = 0.0;
    //
    //        } completion:^(BOOL finished) {
    //            [self.loadingView removeFromSuperview];
    //            self.loadingView = nil;
    //            [self.loadingLabel removeFromSuperview];
    //            self.loadingLabel = nil;
    //
    //        }];
    //    }
}

- (void)hideLoading:(NSString *)msg
{
    [self removeLoading];
    if (msg.length) {
        [self showAlert:msg];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)showAlert:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"知道"
                                          otherButtonTitles:nil];
    [alert show];
    [self performSelector:@selector(dimissAlert:)withObject:alert afterDelay:1.25];
}
- (void) dimissAlert:(UIAlertView *)alert {
    if(alert){
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}
#pragma clang diagnostic pop



/////
- (void)showHud{
    
    [self hideHud];
    
    self.imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.imageView.backgroundColor = [UIColor clearColor]; //背景的颜色
    self.imageView.center = self.center;
    [self addSubview:self.imageView];
    
    [self createAnimation];
    self.userInteractionEnabled = NO;
    
}

- (void)hideHud{
    self.userInteractionEnabled = YES;
    if (self.imageView) {
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.imageView removeFromSuperview];
            self.imageView = nil;
        }];
    }
}

- (void)createAnimation{
    
    NSString *base64 = @"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";
    
    //图标背景
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds          = CGRectMake(0, 0, 100, 100);
    replicatorLayer.position        = self.center;
    replicatorLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1].CGColor;
    replicatorLayer.cornerRadius    = 10;
    replicatorLayer.masksToBounds   = YES;
    
    [self.imageView.layer addSublayer:replicatorLayer];
    
    //旋转图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    imageView.image = [UIImage imageWithData:data];
    imageView.center = self.center;
    [self.imageView addSubview:imageView];
    
    //旋转动画
    CABasicAnimation *rotationAnimZ = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimZ.beginTime = 0.0;
    rotationAnimZ.toValue = @(2*M_PI);
    rotationAnimZ.duration = 1;
    rotationAnimZ.repeatCount = INFINITY;
    [imageView.layer addAnimation:rotationAnimZ forKey:@"rotationAnimZ"];
}



@end
