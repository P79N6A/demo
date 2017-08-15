//
//  MBProgressHUD+iShare.h
//  HUD
//
//  Created by pkss on 2017/4/28.
//  Copyright © 2017年 J. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (iShare)


#pragma mark --- 显示成功,几秒后消失
/*!
 *  显示成功文字和图片,几秒后消失 (window中)
 */
+ (void)MB_showSuccess:(NSString *)success;
/*!
 *  显示成功文字和图片,几秒后消失(放到指定view中)
 */
+ (void)MB_showSuccess:(NSString *)success toView:(UIView *)view;

#pragma mark --- 显示出错,几秒后消失
/*!
 *  显示出错图片和文字,几秒后消失 (window中)
 */
+ (void)MB_showError:(NSString *)error;
/*!
 *  显示出错图片和文字,几秒后消失(放到指定view中)
 */
+ (void)MB_showError:(NSString *)error toView:(UIView *)view;

#pragma mark --- 显示信息,几秒后消失
/*!
 *  只显示文字,几秒后消失 (window中) , 在window底部出现
 */
+ (void)MB_showText:(NSString *)text;
/*!
 *  只显示文字,几秒后消失(放到指定view中) , 在视图底部出现
 */
+ (void)MB_showText:(NSString *)text toView:(UIView *)view;

/*!
 *  只显示图片,几秒后消失 (window中)
 */
+ (void)MB_showIcon:(NSString *)icon;
/*!
 *  只显示图片,几秒后消失(放到指定view中)
 */
+ (void)MB_showIcon:(NSString *)icon toView:(UIView *)view;

/*!
 *  显示文字和图片,几秒后消失 (window中)
 */
+ (void)MB_showText:(NSString *)text icon:(NSString *)icon;
/*!
 *  显示文字和图片,几秒后消失(放到指定view中)
 */
+ (void)MB_showText:(NSString *)text icon:(NSString *)icon toView:(UIView *)view;





#pragma mark --- 显示HUD
/*!
 *  只显示菊花(需要主动让它消失,HUD放在Window中)
 */
+ (MBProgressHUD *)MB_showHUD;
/*!
 *  显示菊花和文字(需要主动让它消失,HUD放在Window中)
 */
+ (MBProgressHUD *)MB_showMessage:(NSString *)message cannel:(void (^)(void))cannel;
/*!
 *  显示菊花和文字(需要主动让它消失，HUD放到指定view中)
 */
+ (MBProgressHUD *)MB_showMessage:(NSString *)message toView:(UIView *)view;


#pragma mark --- 隐藏HUD
/*!
 *  隐藏HUD(HUD在Window中)
 */
+ (void)MB_hideHUD;

/*!
 *  隐藏HUD(HUD在指定view中)
 */
+ (void)MB_hideHUDForView:(UIView *)view;


#pragma mark --- 其他
/*!
 *  显示系统指示器
 */
+ (void)MB_showNetworkIndicator;
/*!
 *  隐藏系统指示器
 */
+ (void)MB_hideNetworkIndicator;






#pragma mark --- 能快速调用 (全部都是加在window上的)

/*!
 *  文字提示,在window居中显示
 */
+ (void)MB_alert:(NSString *)text;
+ (BOOL)MB_alertError:(NSError *)error;
+ (BOOL)MB_filterError:(NSError *)error;
+ (void)MB_showHUDText:(NSString *)text;
+ (void)MB_toast:(NSString *)text;
+ (void)MB_toast:(NSString *)text duration:(NSTimeInterval)duration;
+ (void)MB_showErrorAlert:(NSString *)text;
+ (void)MB_showSuccessAlert:(NSString *)text;







@end
