//
//  ViewController.m
//  tvbyb
//
//  Created by Jay on 31/5/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

#import "LZData.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [LZData getTVBYBPage:2 block:^(NSArray<NSDictionary *> *obj) {
        NSLog(@"%s", __func__);
    }];
    
    [LZData getTVBYBDetail:@"http://www.hktvyb.com/vod/detail/id/925.html" block:^(NSDictionary *obj) {
        NSLog(@"%s", __func__);
    }];
    
    [LZData getTVBYBM3u8:@"http://www.hktvyb.com/vod/play/id/925/sid/1/nid/1.html" block:^(NSArray *obj) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
