//
//  ViewController.m
//  http
//
//  Created by Jay on 5/5/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "DANet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%s---是否上线：%d   是否已经评分了：%d", __func__,[DANet defaultNet].appIsOnline,[DANet defaultNet].appIsUnlocked);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
