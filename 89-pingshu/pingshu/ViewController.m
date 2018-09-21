//
//  ViewController.m
//  pingshu
//
//  Created by Jay on 16/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "PingShuHtml.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    [PingShuHtml searchPingShuKeyWord:@"三" completed:^(NSArray<NSDictionary *> *objs) {
        NSLog(@"%s", __func__);
    }];
    [PingShuHtml getPingShuURL:@"http://m.zgpingshu.com/mingrentang/shilianjun/" completed:^(NSArray<NSDictionary *> *objs) {
        NSLog(@"%s", __func__);
    }];
    
    [PingShuHtml getMingRenTangCompleted:^(NSArray<NSDictionary *> *objs) {
        NSLog(@"%s", __func__);
    }];
    
    [PingShuHtml getLongPingShuPageNo:0 classId:@"" completed:^(NSArray<NSDictionary *> *objs) {
        NSLog(@"%s", __func__);
    }];
    
    [PingShuHtml getPingShuDetail:@"http://m.zgpingshu.com/pingshu/shantianfang/575/" completed:^(NSDictionary *obj) {
        NSLog(@"%s", __func__);
    }];
    
    [PingShuHtml pingShuMp3:@"http://m.zgpingshu.com/playdata/575/2.html" completed:^(NSString *obj) {
     NSLog(@"%s", __func__);
    }];
    
    [PingShuHtml getPingShuPageNo:0 completed:^(NSArray<NSDictionary *> *objs) {
        NSLog(@"%s", __func__);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
