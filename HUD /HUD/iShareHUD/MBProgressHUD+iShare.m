//
//  MBProgressHUD+iShare.m
//  HUD
//
//  Created by pkss on 2017/4/28.
//  Copyright © 2017年 J. All rights reserved.
//

#import "MBProgressHUD+iShare.h"

#define SafeString(A) A?A:@""

static CGFloat const kMinimumDismissTimeInterval = 1.0f;
static CGFloat const kFontSize = 16;

static void (^cannelBlock)(void);

@implementation MBProgressHUD (iShare)

/*!
 *  显示成功文字和图片,几秒后消失
 */
+ (void)MB_showSuccess:(NSString *)success{
    [self MB_showText:success icon:@"success_white.png" view:nil afterDelay:[self displayDurationForString:SafeString(success)] offsetY:0.f];
}

/*!
 *  显示成功文字和图片,几秒后消失(放到指定view中)
 */
+ (void)MB_showSuccess:(NSString *)success toView:(UIView *)view{
    [self MB_showText:success icon:@"success_white.png" view:view afterDelay:[self displayDurationForString:SafeString(success)] offsetY:0.f];
}

#pragma mark --- 显示出错,几秒后消失
/*!
 *  显示出错图片和文字,几秒后消失
 */
+ (void)MB_showError:(NSString *)error{
    [self MB_showText:error icon:@"error_white.png" view:nil afterDelay:[self displayDurationForString:SafeString(error)] offsetY:0.f];
}
/*!
 *  显示出错图片和文字,几秒后消失(放到指定view中)
 */
+ (void)MB_showError:(NSString *)error toView:(UIView *)view{
    [self MB_showText:error icon:@"error_white.png" view:view afterDelay:[self displayDurationForString:SafeString(error)] offsetY:0.f];
}

#pragma mark --- 显示信息,几秒后消失
/*!
 *  只显示文字,几秒后消失
 */
+ (void)MB_showText:(NSString *)text{
    
    // [self MB_showText:text icon:nil toView:nil];  // 无偏移量的情况
    
    // 只有文字时在底部提示:
    [self MB_showText:text icon:nil view:nil afterDelay:[self displayDurationForString:SafeString(text)] offsetY:MBProgressMaxOffset];
    
}
/*!
 *  只显示文字,几秒后消失(放到指定view中)
 */
+ (void)MB_showText:(NSString *)text toView:(UIView *)view{
    //    [self MB_showText:text icon:nil toView:view]; // 无偏移量的情况
    [self MB_showText:text icon:nil view:view afterDelay:[self displayDurationForString:SafeString(text)] offsetY:MBProgressMaxOffset];
}

/*!
 *  只显示图片,几秒后消失
 */
+ (void)MB_showIcon:(NSString *)icon{
    [self MB_showText:nil icon:icon toView:nil];
}
/*!
 *  只显示图片,几秒后消失(放到指定view中)
 */
+ (void)MB_showIcon:(NSString *)icon toView:(UIView *)view{
    [self MB_showText:nil icon:icon toView:view];
}

/*!
 *  显示文字和图片,几秒后消失
 */
+ (void)MB_showText:(NSString *)text icon:(NSString *)icon{
    [self MB_showText:text icon:icon toView:nil];
}
/*!
 *  显示文字和图片,几秒后消失(放到指定view中)
 */
+ (void)MB_showText:(NSString *)text icon:(NSString *)icon toView:(UIView *)view{
    [self MB_showText:text icon:icon view:view afterDelay:[self displayDurationForString:SafeString(text)] offsetY:0.f];
}

#pragma mark --- private
+ (void)MB_showText:(NSString *)text icon:(NSString *)icon view:(UIView *)view afterDelay:(NSTimeInterval)delay offsetY:(CGFloat)offset_y{
    
    if (view == nil) {
        view = [self rootWindowView];
    }
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.label.font = [UIFont systemFontOfSize:kFontSize];
    hud.contentColor = [UIColor whiteColor];
    hud.label.numberOfLines = 0;
    hud.bezelView.layer.cornerRadius = 10.f;
    hud.bezelView.layer.masksToBounds = YES;
    
    
    // TODO: change the hud style
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;   // HUD主色调无效果, 默认MBProgressHUDBackgroundStyleBlur 毛玻璃效果
    hud.bezelView.backgroundColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.0];
    hud.offset = CGPointMake(0.f,offset_y);
    
    
    // YES代表需要蒙版效果(默认是NO) hud.dimBackground = YES;
    //    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    //    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];  // 不需要蒙板效果: [UIColor clearColor];
    
    // 设置图片:
    NSString *imageStr = [NSString stringWithFormat:@"MBHUD.bundle/%@",icon];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageStr]];
    
    
    if ([UIImage imageNamed:imageStr]) {
        hud.minSize = CGSizeMake(80, 80);
    }
    
    
    // 再设置模式:
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 几秒后消失
    [hud hideAnimated:YES afterDelay:delay];
    
}

+ (UIView *)rootWindowView {
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    return view;
}



#pragma mark --- 显示HUD
/*!
 *  只显示菊花(需要主动让它消失,HUD放在Window中)
 */
+ (MBProgressHUD *)MB_showHUD{
    return [self MB_showMessage:nil toView:nil];
}
/*!
 *  显示菊花和文字(需要主动让它消失,HUD放在Window中)
 */
+ (MBProgressHUD *)MB_showMessage:(NSString *)message cannel:(void (^)(void))cannel{
    MBProgressHUD *hub = [self MB_showMessage:message toView:nil];
    cannelBlock = cannel;
    [hub.bezelView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cannel)]];
    return hub;
}


+ (void)cannel{
    [self MB_hideHUD];
    (!cannelBlock)? :cannelBlock();
}
/*!
 *  显示菊花和文字(需要主动让它消失，HUD放到指定view中)
 */
+ (MBProgressHUD *)MB_showMessage:(NSString *)message toView:(UIView *)view{
    if (view == nil) {
        view = [self rootWindowView];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:kFontSize];
    hud.minSize = CGSizeMake(80, 80);
    hud.label.numberOfLines = 0;
    
    
    // TODO: change the hud style
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.0];

    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.layer.cornerRadius = 10.f;
    hud.bezelView.layer.masksToBounds = YES;

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // TODO:
    // YES代表需要蒙版效果(默认是NO) hud.dimBackground = YES;
    //    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    //    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];  // 不需要蒙板效果: [UIColor clearColor];
    
    return hud;
}


#pragma mark --- 隐藏HUD
/*!
 *  隐藏HUD(HUD在Window中)
 */
+ (void)MB_hideHUD{
    [self MB_hideHUDForView:nil];
}

/*!
 *  隐藏HUD(HUD在指定view中)
 */
+ (void)MB_hideHUDForView:(UIView *)view{
    if (view == nil) {
        view = [self rootWindowView];
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
}



#pragma mark --- 其他
+ (void)MB_showNetworkIndicator{
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
}
+ (void)MB_hideNetworkIndicator{
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = NO;
}





//******************************   **********************************//
+ (void)MB_alert:(NSString *)text{
    
    [self  MB_showText:text icon:nil toView:nil];
}


+ (BOOL)MB_alertError:(NSError *)error{
    if (error) {
        if ([error.domain isEqualToString:NSURLErrorDomain]) {
            [self MB_alert:@"网络连接发作错误"];
        } else {
#ifndef DEBUG
            [self MB_alert:[NSString stringWithFormat:@"%@", error]];
#else
            NSString *info = error.localizedDescription;
            [self MB_alert:info ? info : [NSString stringWithFormat:@"%@", error]];
#endif
        }
        return YES;
    }
    return NO;
}


+ (BOOL)MB_filterError:(NSError *)error{
    return [self MB_alertError:error] == NO;
}

+ (void)MB_showErrorAlert:(NSString *)text{
    [self  MB_showError:text];
}

+ (void)MB_showSuccessAlert:(NSString *)text{
    [self MB_showSuccess:text];
}

+ (void)MB_showHUDText:(NSString *)text{
    [self MB_toast:text];
}

+ (void)MB_toast:(NSString *)text{
    [self MB_toast:text duration:[[self class] displayDurationForString:SafeString(text)]];
}
+ (void)MB_toast:(NSString *)text duration:(NSTimeInterval)duration{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[self class] rootWindowView] animated:YES];
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:kFontSize-2];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    
    // TODO: change the hud style
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    
    [hud hideAnimated:YES afterDelay:duration];
}


#pragma mark - Getters
+ (NSTimeInterval)displayDurationForString:(NSString*)string {
    return MAX((float)string.length * 0.06 + 0.5, kMinimumDismissTimeInterval);
}

@end
