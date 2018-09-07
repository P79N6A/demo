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

#import "NSObject+DB.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    
//    [[DataBase sharedInstance] openDB];
//    [[DataBase sharedInstance] createTable:[Dog class]];
//
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < 100000; i ++) {
        Dog *d = [Dog new];
        d.name = @"阿斯顿1111撒点";
        d.age = i;
        [array addObject:d];
    }
    NSLog(@"%s", __func__);
//    [[DataBase sharedInstance] insertDatas:array];
//    [Dog insertDatas:array];
    NSLog(@"%s", __func__);
    
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    @property (nonatomic, copy) NSString *mid;
//    @property (nonatomic, copy) NSString *name;
//    @property (nonatomic, assign) BOOL sex;
//    @property (nonatomic, assign) NSInteger age;
//    @property (nonatomic, assign) CGFloat sorce;
    

//    Dog *d = [Dog new];
//    d.name = @"斯顿";
//    d.sex = YES;
//    d.age = rand();
//    d.sorce = 99.1;
//    d.sorce2 = 11.2;
//    [d insert];
    NSArray *s = [Dog searchDataWhere:@"where sorce = 99.1"];
    Dog *d = s.lastObject;
    d.name = @"hello";
    
    [d update];
    NSLog(@"%s", __func__);
//    NSLog(@"%s", __func__);
//    [[DataBase sharedInstance] openDB];
//    [[DataBase sharedInstance] createTable:[Dog class]];
//    [[DataBase sharedInstance] searchAllModel:[Dog class] where:@"where mid == 2"];

}


@end
