//
//  ViewController.m
//  extension
//
//  Created by czljcb on 2017/6/28.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Extension.h"
#import "NSObject+Extension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [UIImage imageWithCircleBorder:2.0 borderColor:[UIColor redColor] image:nil];
    
    [self perform:^{
        NSLog(@"%s", __func__);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
