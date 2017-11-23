//
//  ViewController.m
//  38 StoreKit
//
//  Created by FEIWU888 on 2017/10/27.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import "ViewController.h"

#import <StoreKit/StoreKit.h>

@interface ViewController ()<SKStoreProductViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APPID&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
    
    //[SKStoreReviewController requestReview];

    [self setUpAppStoreController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//加载App Store评分控制器
- (void)setUpAppStoreController
{
    // 初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    // 设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    [storeProductViewContorller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"1296519989"} completionBlock:^(BOOL result, NSError * _Nullable error) {
        if(error)  {
            NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
        }else{
            // 模态弹出App Store评分控制器
            [self presentViewController:storeProductViewContorller animated:YES completion:nil];
        }
    }];
    
}

//监听App Store取消按钮点击
- (void)productViewControllerDidFinish:(SKStoreProductViewController*)viewController
{
    [self dismissViewControllerAnimated: YES completion: nil];
}



@end
