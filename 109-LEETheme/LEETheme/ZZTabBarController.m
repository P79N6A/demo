//
//  ZZTabBarController.m
//  LEETheme
//
//  Created by Jay on 1/11/2018.
//  Copyright © 2018 Jay. All rights reserved.
//

#import "ZZTabBarController.h"
#import "ZZNavigationController.h"

#import "ViewController.h"

#import <LEETheme/LEETheme.h>

@interface ZZTabBarController ()

@end

@implementation ZZTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)setUI{

    ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:[UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController];
    nav.tabBarItem.title = @"我的";
//    nav.tabBarItem.image = [UIImage imageNamed:@"r"];
//    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"r_select"];
    
    
    
    
    
    ZZNavigationController *nav2 = [[ZZNavigationController alloc] initWithRootViewController:[UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController];
    nav2.tabBarItem.title = @"我的2";
//    nav2.tabBarItem.image = [UIImage imageNamed:@"r"];
//    nav2.tabBarItem.selectedImage = [UIImage imageNamed:@"r_select"];

    
    self.viewControllers = @[nav,nav2];

    self.tabBar.lee_theme.LeeConfigBarTintColor(@"tabColor");
    

    
    nav.tabBarItem.lee_theme.LeeAddCustomConfig(kDay, ^(UITabBarItem *item) {
        
        item.selectedImage = [[UIImage imageNamed:@"r_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        
        item.image = [[UIImage imageNamed:@"r"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:LEEColorRGB(33, 151, 216)} forState:UIControlStateSelected];
        
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:LEEColorRGB(159, 159, 159)} forState:UIControlStateNormal];
    });
    nav.tabBarItem.lee_theme.LeeAddCustomConfig(kNight, ^(UITabBarItem *item) {
        
        item.selectedImage = [[UIImage imageNamed:@"s_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        item.image = [[UIImage imageNamed:@"s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:LEEColorRGB(33, 151, 216)} forState:UIControlStateSelected];
        
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:LEEColorRGB(159, 159, 159)} forState:UIControlStateNormal];
    });
    
    
    
    
    nav2.tabBarItem.lee_theme.LeeAddCustomConfig(kDay, ^(UITabBarItem *item) {
        
        item.selectedImage = [[UIImage imageNamed:@"ss_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        item.image = [[UIImage imageNamed:@"ss"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:LEEColorRGB(33, 151, 216)} forState:UIControlStateSelected];
        
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:LEEColorRGB(159, 159, 159)} forState:UIControlStateNormal];
    });
    nav2.tabBarItem.lee_theme.LeeAddCustomConfig(kNight, ^(UITabBarItem *item) {
        
        item.selectedImage = [[UIImage imageNamed:@"m_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        item.image = [[UIImage imageNamed:@"m"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:LEEColorRGB(33, 151, 216)} forState:UIControlStateSelected];
        
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:LEEColorRGB(159, 159, 159)} forState:UIControlStateNormal];
    });




}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
