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
    //[self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:kNavigationBarTitleFont}];
    
    
    self.navigationBar.lee_theme.LeeConfigTintColor(@"ident1").LeeConfigBarTintColor(@"ident2");
    self.navigationBar.lee_theme
    .LeeAddCustomConfig(kDay, ^(UINavigationBar *bar) {
        
        bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    })
    .LeeAddCustomConfig(kNight, ^(UINavigationBar *bar) {
        
        bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
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
