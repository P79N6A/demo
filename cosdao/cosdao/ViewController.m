//
//  ViewController.m
//  cosdao
//
//  Created by Jay on 16/7/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "TaiJuHtml.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [TaiJuHtml getTaiJuPageNo:1 completed:^(NSArray<NSDictionary *> *objs) {
        
    }];
}


@end
