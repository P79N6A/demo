//
//  ViewController.m
//  35BuglyDemo
//
//  Created by FEIWU888 on 2017/10/19.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self test];
}

- (void)test{
    NSArray *array = @[@"33"];
    NSLog(@"%@",array[0]);
    NSLog(@"%@",array[1]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
