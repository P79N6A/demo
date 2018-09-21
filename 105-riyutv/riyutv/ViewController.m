//
//  ViewController.m
//  riyutv
//
//  Created by xin on 2018/9/8.
//  Copyright © 2018年 HKDramaFan. All rights reserved.
//

#import "ViewController.h"
#import "RiJuTV.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self test];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)test{
    
    

    NSLog(@"%s", __func__);
    NSURL * url = [NSURL URLWithString:@"https://github.com/LQJJ/demo/blob/master/104-BackgroundDownload/rijutv.json?raw=trun"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:15.0];

    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSString *searchText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%s--searchText : %@", __func__,searchText);
        
    }];
    //开启网络任务
    [task resume];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [TaiJuHtml getTaiJuPageNo:1 completed:^(NSArray<NSDictionary *> *objs) {
//        ;
//    }];
    
//    [TaiJuHtml getTaiJuDetail:@"https://www.rijutv.com/riju/12497.html" completed:^(NSDictionary *obj) {
//        ;
//    }];
    
//    [TaiJuHtml taiJuM3u8:@"https://www.rijutv.com/player/29737.html" completed:^(NSArray *objs) {
//        ;
//    }];
    
//    [TaiJuHtml taiJuHls:@"https://jiexi.rijutv.com/index.php?path=6e69o9HsPT%2BaotXjc%2Fw77idji9DPinCC1sefJG7vTyXRYyXQoD0tdVoQ0q%2Bl87TgHbrS05eSEFKwsLxO6UDxsbk%2B07cdP5vCxLTaGIkvHI%2Bl9NVLTSO7r5wteWB%2FvqHJsJvI" completed:^(NSString *obj) {
//        ;
//    }];
    
//    [RiJuTV searchRiJu:@"日剧" pageNo:1 completed:^(NSArray<NSDictionary *> *objs, BOOL hasMore) {
//        ;
//    }];
    
//    [RiJuTV getJianShuObj:@"https://www.jianshu.com/p/820831f547a2" completed:^(id obj) {
//        NSLog(@"%s", __func__);
//    }];
    
  
        
        UIView *fron = [[self.view subviews] objectAtIndex:0];
        
        UIView *back = [[self.view subviews] objectAtIndex:1];

        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
    
        [UIView beginAnimations:nil context:ctx];
    
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
        [UIView setAnimationDuration:2.0];
    
    
//        fron.alpha = 0.0f;
//    
//        back.alpha = 1.0f;
    
//        fron.transform = CGAffineTransformMakeScale(0.25f, 0.25f);
    
//        back.transform = CGAffineTransformIdentity;
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];

    
    
        [UIView setAnimationDelegate:self];
    
        [UIView commitAnimations];
    

}

@end
