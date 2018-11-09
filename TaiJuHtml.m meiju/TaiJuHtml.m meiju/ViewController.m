//
//  ViewController.m
//  TaiJuHtml.m meiju
//
//  Created by Jay on 9/11/2018.
//  Copyright © 2018 Jay. All rights reserved.
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


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [TaiJuHtml getTaiJuPageNo:1 completed:^(NSArray<NSDictionary *> *objs) {
        NSLog(@"%s", __func__);
    }];
    
    
    [TaiJuHtml getTaiJuDetail:@"http://www.97pd.com//meiju/quanlideyouxidierji/" completed:^(NSDictionary *obj) {
        NSLog(@"%s", __func__);
    }];
    
    [TaiJuHtml taiJuM3u8:@"http://www.97pd.com//meiju/quanlideyouxidierji/play-2326-1-1.html" completed:^(NSArray *objs) {
        NSLog(@"%s", __func__);
    }];
}

@end
