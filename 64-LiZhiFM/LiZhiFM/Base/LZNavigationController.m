//
//  LZNavigationController.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/18.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZNavigationController.h"

#import "LZPlayView.h"

#import "LZCommon.h"
#import "UIView+Extension.h"

@interface LZNavigationController ()

@end

@implementation LZNavigationController


-(void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    self.navigationBar.barTintColor = [UIColor orangeColor];
    
    LZPlayView *playView = [LZPlayView playView];//[[LZPlayView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 100, ScreenWith, 100)];
    playView.frame = CGRectMake(0, ScreenHeight - 70, ScreenWith, 70);
    
    __weak typeof(LZPlayView) *weakPlayView = playView;
    playView.move = ^(CGFloat y){
        if (y == ScreenHeight - 70) {
            [UIView animateWithDuration:0.25 animations:^{
                weakPlayView.transform = CGAffineTransformTranslate(weakPlayView.transform, 0, 55);
            }];
            return ;
        }
        [UIView animateWithDuration:0.25 animations:^{
            weakPlayView.transform = CGAffineTransformIdentity;
        }];

    };
    [self.view addSubview:playView];
}


- (void)pop{
    [self popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUI];
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
    
    [super pushViewController:viewController animated:animated];
    
}


@end
