//
//  ViewController.m
//  原生调webView
//
//  Created by windy on 2017/3/28.
//  Copyright © 2017年 Jayson. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface ViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic, strong) JSContext *context;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1"];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
    self.webView.delegate = self;
}
- (IBAction)ocCallJSBywebView:(id)sender {
    
    NSString *param = @"OC调用JS参数";    //写入JS的参数
    //调用JS的callJS方法，并且传入param参数，这里要注意参数使用的是单引号‘’
    NSString *js = [NSString stringWithFormat:@"callJS('%@')",param];
    //把JS传入WebView的运行环境中
    NSString *string = [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    NSLog(@"%s---%@", __func__,string);
}

- (IBAction)ocCallJS:(UIBarButtonItem *)sender {
    
    

    
    //调用方法（注意：这里是JS里面的定义的方法）
    NSString *callJSstring = @"sendJSString('参数：OC call JS ')";
    NSString *jsString = @"function ocCallJS(){alert('hello oc call js');}; ocCallJS();";
    [_context evaluateScript:jsString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获得WebView的运行环境的对象
    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%s---%@", __func__,request.URL);
    return YES;
}

@end
