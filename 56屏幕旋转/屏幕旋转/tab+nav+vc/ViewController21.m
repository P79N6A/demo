//
//  ViewController21.m
//  屏幕旋转
//
//  Created by Jay on 2018/4/3.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController21.h"

@interface ViewController21 ()

@end

@implementation ViewController21

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

@end
