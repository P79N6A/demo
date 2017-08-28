//
//  ViewController.m
//  AppIcon
//
//  Created by pkss on 2017/4/24.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    NSDictionary *parms = @{
                            @"c":  @"loveq",
                            @"debug":@(66),
                            @"a": @"checksum"
                            };
    NSArray *keyArray = [parms allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[parms objectForKey:sortString]];
    }
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@:%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }

    [manager POST:@"http://ishare.bthost.top/api/?checksum=" parameters:parms progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%s", __func__);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%s", __func__);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    if ([UIApplication sharedApplication].supportsAlternateIcons) {
//        NSLog(@"you can change this app's icon");
//    }else{
//        NSLog(@"you can not change this app's icon");
//        return;
//    }
//    
//    NSString *iconName = [[UIApplication sharedApplication] alternateIconName];
//    
//    if (iconName) {
//        // change to primary icon
//        [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
//            if (error) {
//                NSLog(@"set icon error: %@",error);
//            }
//            NSLog(@"The alternate icon's name is %@",iconName);
//        }];
//    }else{
//        // change to alterante icon
//        [[UIApplication sharedApplication] setAlternateIconName:@"newIcon-60" completionHandler:^(NSError * _Nullable error) {
//            if (error) {
//                NSLog(@"set icon error: %@",error);
//            }
//            NSLog(@"The alternate icon's name is %@",iconName);
//        }];
//    }
}


@end
