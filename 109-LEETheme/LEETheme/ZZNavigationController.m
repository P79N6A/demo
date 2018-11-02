//
//  ZZNavigationController.m
//  LEETheme
//
//  Created by Jay on 1/11/2018.
//  Copyright © 2018 Jay. All rights reserved.
//

#import "ZZNavigationController.h"

#import <LEETheme/LEETheme.h>

@interface ZZNavigationController ()

@end

@implementation ZZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}
-(void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    self.navigationBar.lee_theme.LeeConfigTintColor(@"ident1")//左右
                      .LeeConfigBarTintColor(@"navColor");//主题
    self.navigationBar.lee_theme
    .LeeAddCustomConfig(kDay, ^(UINavigationBar *bar) {
        // title
        bar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor yellowColor],NSFontAttributeName:[UIFont systemFontOfSize:24]};
    })
    .LeeAddCustomConfig(kNight, ^(UINavigationBar *bar) {
        
        bar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:24]};
    });
    
}


@end
