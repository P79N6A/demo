//
//  ViewController.m
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "PlayViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //
    //
    self.view.backgroundColor = [UIColor orangeColor];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Dispose of any resources that can be recreated.
    
    [self.navigationController pushViewController:[PlayViewController new] animated:YES];
}


@end
