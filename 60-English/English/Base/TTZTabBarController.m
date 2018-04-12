//
//  TTZTabBarController.m
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZTabBarController.h"
#import "TTZNavigationController.h"
#import "ViewController.h"

@interface TTZTabBarController ()

@end

@implementation TTZTabBarController


+ (void)load {
    
    UITabBarItem *xg_tabBarItem = [UITabBarItem appearance];
    
    [xg_tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    
    [xg_tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
}

-(void)YYW_UI {
    
    
    ViewController *yyzj_radio = [[ViewController alloc] init];
    TTZNavigationController *yyzj_radioNav = [[TTZNavigationController alloc] initWithRootViewController:yyzj_radio];
    yyzj_radioNav.tabBarItem.image = [UIImage imageNamed:@"O"];
    yyzj_radioNav.tabBarItem.selectedImage = [UIImage imageNamed:@"O_select"];
    yyzj_radioNav.tabBarItem.title = @"粤语台";
    [self addChildViewController:yyzj_radioNav];
    
    
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self YYW_UI];
}

//FIXME:  -  旋转 状态栏
- (BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (BOOL)prefersStatusBarHidden{
    return self.selectedViewController.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.selectedViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return self.selectedViewController.preferredStatusBarUpdateAnimation;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return self.selectedViewController.prefersHomeIndicatorAutoHidden;
}


@end
