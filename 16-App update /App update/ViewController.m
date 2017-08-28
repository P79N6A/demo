//
//  ViewController.m
//  App update
//
//  Created by pkss on 2017/5/15.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ViewController.h"


#import <StoreKit/StoreKit.h>
#import <AFNetworking.h>

@interface ViewController () <SKStoreProductViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://itunes.apple.com/cn/lookup?bundleId=com.wammallaa" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //具体实现为
        NSArray *results = [responseObject objectForKey:@"results"];
        if (results.count < 1) {
            return;
        }

        NSDictionary *result = [results firstObject];
        NSString *versionStr = [result objectForKey:@"version"];
        NSString *trackViewUrl = [result objectForKey:@"trackViewUrl"];
        NSString *releaseNotes = [result objectForKey:@"releaseNotes"];//更新日志
        NSString *artistId = [result objectForKey:@"artistId"];
        
        //NSString* buile = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString*) kCFBundleVersionKey];build号
        NSString* thisVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        
        if([self compareVersionsFormAppStore:versionStr WithAppVersion:thisVersion]){
        
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"发现新版本:%@",versionStr] message:releaseNotes preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                NSLog(@"点击了取消");
            }];
            
            UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                NSLog(@"点击了知道了");
//                NSURL * url = [NSURL URLWithString:trackViewUrl];//itunesURL = trackViewUrl的内容
//                [[UIApplication sharedApplication] openURL:url];
                
                SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
                storeProductVC.delegate = self;
                
                NSDictionary *dict = [NSDictionary dictionaryWithObject:artistId forKey:SKStoreProductParameterITunesItemIdentifier];
                [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
                    if (result) {
                        [self presentViewController:storeProductVC animated:YES completion:nil];
                    }  
                }];
            
            
            }];
            [alertVC addAction:cancelAction];
            [alertVC addAction:OKAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:^{
    }];
}

//比较版本的方法，在这里我用的是Version来比较的
- (BOOL)compareVersionsFormAppStore:(NSString*)AppStoreVersion WithAppVersion:(NSString*)AppVersion{
    NSMutableString *online = (NSMutableString *)[AppStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSMutableString *new = (NSMutableString *)[AppVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    while (online.length < new.length) { [online appendString:@"0"]; }
    while (new.length < online.length) { [new appendString:@"0"]; }
    return [online integerValue] > [new integerValue];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
