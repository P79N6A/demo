//
//  UIViewController+Extension.h
//  Hello
//
//  Created by czljcb on 2017/8/20.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)
//@property (nonatomic, strong) MBProgressHUD *hud;
- (void)showHUD:(NSString *)title;
- (void)showHUDComplete:(NSString *)title;
- (void)showHUDFail:(NSString *)title;
- (void)hideHUD;

@end
