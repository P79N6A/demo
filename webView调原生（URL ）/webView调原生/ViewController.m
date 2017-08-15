//
//  ViewController.m
//  webView调原生
//
//  Created by windy on 2017/3/28.
//  Copyright © 2017年 Jayson. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end


@implementation ViewController
#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1"];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
    self.webView.delegate = self;
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
}

- (void)callName:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"web调起原生" message:msg preferredStyle:UIAlertControllerStyleAlert] ;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *getURLString = [request.URL absoluteString];
    NSLog(@"总的字符串：%@",getURLString);
    NSString *htmlHeadString = @"wammall://";
    //协议头可以自己定义
    if([getURLString hasPrefix:htmlHeadString])
    {
        NSString *subString = [getURLString substringFromIndex:htmlHeadString.length];
        NSArray *arrayStr = [subString componentsSeparatedByString:@"?"];
        NSString *fistStr = [arrayStr firstObject];
        NSString *methodName = [fistStr stringByReplacingOccurrencesOfString:@"_" withString:@":"];
        //调用方法
        SEL  selector = NSSelectorFromString(methodName);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        //-Warc-performSelector-leaks为唯一的警告标识
        [self performSelector:selector withObject:[arrayStr lastObject]];
#pragma clang diagnostic pop
        //注意：系统提供的方法最多只有两个参数，如果要多个参数，使用我的扩展类
        // - (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects
        return NO;
    }
    else
        return YES;
}
@end
