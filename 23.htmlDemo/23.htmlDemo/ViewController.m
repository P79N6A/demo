//
//  ViewController.m
//  23.htmlDemo
//
//  Created by czljcb on 2017/11/10.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    103 102
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.kugou.com/yy/rank/home/1-6666.html?from=rank"]];


    // 2.创建一个网络请求
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.89 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    //[request setHTTPMethod:@"GET"];
    
    
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务：
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"从服务器获取到数据");
        /*
         对从服务器获取到的数据data进行相应的处理：
         */
        NSString *HTML = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%s--%@", __func__,HTML);
    }];
    // 5.最后一步，执行任务（resume也是继续执行）:
    [sessionDataTask resume];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *allHtml = @"document.documentElement.innerHTML";
    

    NSString *title = [webView stringByEvaluatingJavaScriptFromString:allHtml];

    NSLog(@"%s--%@", __func__,title);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
