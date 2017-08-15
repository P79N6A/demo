//
//  ViewController.m
//  ShareUI
//
//  Created by pkss on 2017/5/10.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ViewController.h"
#import "ActivityController.h"
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ActivityController *vc = [ActivityController new];
    ItemModel *i = [[ItemModel alloc] initWithLogo:@"11" Name:@"weibo"];
    vc.topItems = @[i];
    vc.buttomItems = @[i];

    [self presentViewController:vc animated:NO completion:nil];
    [vc setDidSelect:^(NSIndexPath * index) {
        NSLog(@"%s--%ld--%ld", __func__,(long)index.section,(long)index.row);
    }];
}

@end
