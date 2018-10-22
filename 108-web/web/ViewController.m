//
//  ViewController.m
//  web
//
//  Created by Jay on 19/10/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

#import "SPSafariController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)eventP{
   
    UIView *v = touches.anyObject.view;
    
    if (v != self.view) {
        return;
    }
    
    SPSafariController *webVC = [[SPSafariController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
    //nav.navigationBar.tintColor = [UIColor colorWithRed:0.322 green:0.322 blue:0.322 alpha:1.00];
    [self presentViewController:nav animated:YES completion:NULL];
}



@end
