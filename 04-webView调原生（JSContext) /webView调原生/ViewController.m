//
//  ViewController.m
//  webView调原生
//
//  Created by windy on 2017/3/28.
//  Copyright © 2017年 Jayson. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>

- (void)callChangeColor:(NSString *)msg;

@end

@interface ViewController () <UIWebViewDelegate, JSObjcDelegate>

@property (nonatomic, strong) JSContext *jsContext;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end


@implementation ViewController
#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1"];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
    self.webView.delegate = self;
    
}

- (void)callName:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"web调起原生" message:msg preferredStyle:UIAlertControllerStyleAlert] ;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)callChangeColor:(NSString *)msg
{
      [self callName:msg];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //拿到WebView执行JS的执行环境，很重要的东西
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //change类似于JS里面的标识（change字符是自定义的，只要和JS中得一样就可以）
    [self.jsContext setObject:self forKeyedSubscript:@"change"];
    __weak typeof(self) weakSelf = self;
    //点击了无参数，jstoocNoPrams是JS的方法名称
    self.jsContext[@"jstoocNoPrams"] = ^(){
        //调用方法处理内容
        NSLog(@"点击了没有传参数按钮");
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf callName:nil];
            });
        });
    };
    
    //点击传参数 jstoocHavePrams方法名称
    self.jsContext[@"jstoocHavePrams"] = ^(){
        //调用方法处理内容
        //获得参数数组
        NSArray *prams = [JSContext currentArguments];
        NSString *arraySting = [[NSString alloc]init];
        for (id obj in prams) {
            NSLog(@"====%@",obj);
            arraySting = [arraySting stringByAppendingFormat:@"%@,",obj];
        }
      
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf callName:arraySting];
        });
    };
}

@end
