//
//  ViewController.m
//  sqlite
//
//  Created by FEIWU888 on 2017/11/15.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import "ViewController.h"

#import "Dog.h"

#import "DataBase.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    
    [[DataBase sharedInstance] openDB];
    [[DataBase sharedInstance] createTable:[Dog class]];
    
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < 100000; i ++) {
        Dog *d = [Dog new];
        d.name = @"阿斯顿撒点";
        d.age = i;
        [array addObject:d];
    }
    NSLog(@"%s", __func__);
    [[DataBase sharedInstance] insertDatas:array];
    NSLog(@"%s", __func__);
    
    

    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    Dog *d = [Dog new];
    d.name = @"斯顿";
    d.age = rand();
    [[DataBase sharedInstance] openDB];
    [[DataBase sharedInstance] createTable:[Dog class]];
    [[DataBase sharedInstance] searchAllModel:[Dog class] where:@"where mid == 2"];
}


@end
