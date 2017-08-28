//
//  UIViewController+Extension.m
//  Hello
//
//  Created by czljcb on 2017/8/20.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "UIViewController+Extension.h"

#import <objc/runtime.h>


@implementation UIViewController (Extension)
//
//- (void)setHud:(MBProgressHUD *)hud{
//    objc_setAssociatedObject(self, @selector(hud), hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (MBProgressHUD *)hud{
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//
//#pragma mark - 显示指示器
//- (void)showHUD:(NSString *)title{
//    [self hideHUD];
//    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view ? self.navigationController.view : self.view animated:YES];
//    self.hud.yOffset = 0;
//    self.hud.mode = MBProgressHUDModeIndeterminate;//mode;
//    self.hud.dimBackground = NO;//isDim;
//    
//    self.hud.labelText  = title;
//}
//
//#pragma mark - 操作成功
//- (void)showHUDComplete:(NSString *)title
//{
//    [self hideHUD];
//    
//    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view ? self.navigationController.view : self.view animated:YES];
//    self.hud.customView = [[UIImageView alloc] initWithImage: LOADIMAGE(@"MBProgressHUD.bundle/success@2x", @"png")];
//    self.hud.userInteractionEnabled = NO;
//    self.hud.mode = MBProgressHUDModeCustomView;
//    if (title.length > 0)
//    {
//        self.hud.labelText = title;
//    }
//    
//    [self hideHUDDelay:1];
//    
//}
//
//#pragma mark - 操作失败
//- (void)showHUDFail:(NSString *)title
//{
//    [self hideHUD];
//    
//    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view ? self.navigationController.view : self.view animated:YES];
//    self.hud.yOffset = 0;//self.yOffset;
//    self.hud.customView = [[UIImageView alloc] initWithImage:LOADIMAGE(@"MBProgressHUD.bundle/error@2x", @"png")];
//    self.hud.mode = MBProgressHUDModeCustomView;
//    if (title.length > 0)
//    {
//        self.hud.labelText = title;
//    }
//    [self hideHUDDelay:1];
//    
//}
//
//#pragma mark - 隐藏指示器
//- (void)hideHUD
//{
//    [self.hud hide:YES];
//}
//
//#pragma mark - 延时隐藏指示器
//- (void)hideHUDDelay:(int)scecond
//{
//    [self.hud hide:YES afterDelay:scecond];
//}

@end
