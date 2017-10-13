//
//  ViewController.m
//  xcode9
//
//  Created by FEIWU888 on 2017/9/18.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *sw = [UIView new];
    [self.view addSubview:sw];
    sw.backgroundColor = [UIColor redColor];
    sw.frame = CGRectMake(0, 0, 100, 100);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
