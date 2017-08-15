//
//  ViewController.m
//  chatRoom
//
//  Created by pkss on 2017/4/21.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "NSString+xx.h"
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
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    NSString *sign = [NSString stringWithFormat:@"%@%@",@"ishare.com.Jayson.app",[signArray componentsJoinedByString:@"&"]];
    
    
//    $str = md5(base64_encode('ishare.com.Jayson.app'.http_build_query(ksort($_POST))));
//    $checksum;
//    for ($i=0; $i < strlen($str) ; $i++) {
//# code...
//        if ($i%2==0) {
//# code...
//            $checksum = $outStr.$str[$i];
//        }
//    }
    
    //sign.base64Encode.md5String
    
    

    [manager POST:@"http://ishare.bthost.top/api/?checksum=" parameters:parms progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%s", __func__);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%s", __func__);
    }];
    
    UISwitch *sw = [[UISwitch alloc] init];
    sw.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [self.view addSubview:sw];
    sw.center = CGPointMake(100, 100);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
