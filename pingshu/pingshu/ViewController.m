//
//  ViewController.m
//  pingshu
//
//  Created by Jay on 16/8/18.
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
    
    [TaiJuHtml getMingRenTangCompleted:^(NSArray<NSDictionary *> *objs) {
        NSLog(@"%s", __func__);
    }];
    
    [TaiJuHtml getLongTaiJuPageNo:0 classId:@"" completed:^(NSArray<NSDictionary *> *objs) {
        NSLog(@"%s", __func__);
    }];
    
    [TaiJuHtml getTaiJuDetail:@"http://m.zgpingshu.com/pingshu/shantianfang/575/" completed:^(NSDictionary *obj) {
        NSLog(@"%s", __func__);
    }];
    
    [TaiJuHtml taiJuM3u8:@"http://m.zgpingshu.com/playdata/575/2.html" completed:^(NSString *obj) {
     NSLog(@"%s", __func__);
    }];
    
    [TaiJuHtml getTaiJuPageNo:0 completed:^(NSArray<NSDictionary *> *objs) {
        NSLog(@"%s", __func__);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
