//
//  TTZTabBarController.m
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZTabBarController.h"
#import "TTZNavigationController.h"

#import "TTZHomeViewController.h"
#import "XYYWEController.h"
#import "YYReadController.h"
#import "YYKKController.h"

@interface TTZTabBarController ()

@end

@implementation TTZTabBarController


+ (void)load {
    
    UITabBarItem *xg_tabBarItem = [UITabBarItem appearance];
    
    [xg_tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    
    [xg_tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
}

-(void)YYW_UI {
    
    
    TTZHomeViewController *yyzj_radio = [[TTZHomeViewController alloc] init];
    TTZNavigationController *yyzj_radioNav = [[TTZNavigationController alloc] initWithRootViewController:yyzj_radio];
    yyzj_radioNav.tabBarItem.image = [UIImage imageNamed:@"gj"];
    yyzj_radioNav.tabBarItem.selectedImage = [UIImage imageNamed:@"gj_s"];
    yyzj_radioNav.tabBarItem.title = @"首页";
    [self addChildViewController:yyzj_radioNav];
    
    
    

    
    YYReadController *yyzj_read = [[YYReadController alloc] init];
    TTZNavigationController *yyzj_readNav = [[TTZNavigationController alloc] initWithRootViewController:yyzj_read];
    yyzj_readNav.tabBarItem.image = [UIImage imageNamed:@"yd"];
    yyzj_readNav.tabBarItem.selectedImage = [UIImage imageNamed:@"yd_select"];
    yyzj_readNav.tabBarItem.title = @"阅读";
    [self addChildViewController:yyzj_readNav];
    
    
    XYYWEController *yyzj_we = [[XYYWEController alloc] init];
    TTZNavigationController *yyzj_weNav = [[TTZNavigationController alloc] initWithRootViewController:yyzj_we];
    yyzj_weNav.tabBarItem.image = [UIImage imageNamed:@"dl"];
    yyzj_weNav.tabBarItem.selectedImage = [UIImage imageNamed:@"dl_s"];
    yyzj_weNav.tabBarItem.title = @"我的";
    
    [self addChildViewController:yyzj_weNav];

//    YYKKController *yyzj_kk = [[YYKKController alloc] init];
//    TTZNavigationController *yyzj_kkNav = [[TTZNavigationController alloc] initWithRootViewController:yyzj_kk];
//    yyzj_kkNav.tabBarItem.image = [UIImage imageNamed:@"yd"];
//    yyzj_kkNav.tabBarItem.selectedImage = [UIImage imageNamed:@"yd_select"];
//    yyzj_kkNav.tabBarItem.title = @"阅读";
//    [self addChildViewController:yyzj_kkNav];

    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self YYW_UI];
}

////FIXME:  -  旋转 状态栏
//- (BOOL)shouldAutorotate{
//    return self.selectedViewController.shouldAutorotate;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    
//    return self.selectedViewController.supportedInterfaceOrientations;
//}
//
//- (BOOL)prefersStatusBarHidden{
//    return self.selectedViewController.prefersStatusBarHidden;
//}
//
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return self.selectedViewController.preferredStatusBarStyle;
//}
//
//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
//    return self.selectedViewController.preferredStatusBarUpdateAnimation;
//}
//
//- (BOOL)prefersHomeIndicatorAutoHidden {
//    return self.selectedViewController.prefersHomeIndicatorAutoHidden;
//}


@end
