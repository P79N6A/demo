//
//  ViewController.m
//  hanyutv
//
//  Created by Jayson on 2018/6/24.
//  Copyright © 2018年 Jayson. All rights reserved.
//

#import "ViewController.h"
#import "JJHtml.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [JJHtml getHanYuTVPage:0 block:^(NSArray<NSDictionary *> *obj) {
        
    }];
    
    [JJHtml getHanYuTVDetail:@"https://m.y3600.com/78/1346.html" completeBlock:^(NSDictionary *obj) {
        NSLog(@"");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
