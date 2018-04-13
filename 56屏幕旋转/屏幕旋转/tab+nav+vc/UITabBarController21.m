//
//  UITabBarController21.m
//  屏幕旋转
//
//  Created by Jay on 2018/4/3.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "UITabBarController21.h"

@interface UITabBarController21 ()

@end

@implementation UITabBarController21

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return self.selectedViewController.supportedInterfaceOrientations;
}
@end
