//
//  ViewController.m
//  HUD
//
//  Created by pkss on 2017/4/28.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ViewController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "MBProgressHUD+iShare.h"
#import "NetAPIClient.h"

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
    [MBProgressHUD MB_showMessage:nil cannel:^{
        [[NetAPIClient sharedClient].tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj cancel];
        }];
    }];
    [NetAPIClient requestJsonDataWithParams:@{@"c":@"tv",@"a":@"list",@"id":@(3) } MethodType:NetworkMethodGET ResponseBlock:^(id responseObject, NSError *error) {
        [MBProgressHUD MB_hideHUD];

        if([responseObject[@"code"] boolValue]){
            [MBProgressHUD MB_showSuccess:@"上传成功"];
        }else{
            
            if (error.code == NSURLErrorCancelled) {
                [MBProgressHUD MB_showError:@"NSURLErrorCancelled"];
            }else{
                [MBProgressHUD MB_showError:responseObject[@"msg"]];
            }
            
        }

    }];
}

@end
