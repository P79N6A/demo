//
//  TTZNavigationController.m
//  playerView
//
//  Created by czljcb on 2018/4/5.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "TTZNavigationController.h"

@interface TTZNavigationController ()

@end

@implementation TTZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.topViewController.preferredStatusBarStyle;
}

@end
