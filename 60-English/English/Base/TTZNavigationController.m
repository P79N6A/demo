//
//  TTZNavigationController.m
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZNavigationController.h"

#import "Common.h"
#import "LBLADMob.h"

@interface TTZNavigationController ()

@end

@implementation TTZNavigationController




-(void)YYW_UI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    self.navigationBar.barTintColor = [UIColor orangeColor];

}


- (void)pop{
    [self popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self YYW_UI];
}


- (UIBarButtonItem *)backButtonItem{
    
    UIButton *yyzj_but = [UIButton buttonWithType:UIButtonTypeCustom];
    [yyzj_but addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [yyzj_but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    yyzj_but.showsTouchWhenHighlighted = YES;
    [yyzj_but setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    yyzj_but.frame = CGRectMake(0, 0, 22, 44);
    //yyzj_but.backgroundColor = [UIColor blueColor];
    //[yyzj_but setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    return [[UIBarButtonItem alloc] initWithCustomView:yyzj_but];
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count >= 1){
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [self backButtonItem];
    }
    [[LBLADMob sharedInstance] GADLoadInterstitial];

    [super pushViewController:viewController animated:animated];
    
}


////FIXME:  -  旋转 状态栏
//- (BOOL)shouldAutorotate{
//    return self.topViewController.shouldAutorotate;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    
//    return self.topViewController.supportedInterfaceOrientations;
//}
//
//- (BOOL)prefersStatusBarHidden{
//    return self.topViewController.prefersStatusBarHidden;
//}
//
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return self.topViewController.preferredStatusBarStyle;
//}
//
//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
//    return self.topViewController.preferredStatusBarUpdateAnimation;
//}
//
//- (BOOL)prefersHomeIndicatorAutoHidden {
//    return self.topViewController.prefersHomeIndicatorAutoHidden;
//}
//



@end

