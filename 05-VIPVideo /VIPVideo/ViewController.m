//
//  ViewController.m
//  VIPVideo
//
//  Created by pkss on 2017/5/22.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ViewController.h"
#import "VideoController.h"
#import <SafariServices/SafariServices.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController () <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;
@property(nonatomic, copy)NSString *url;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.baidu.com"]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    
    return YES;
}
- (IBAction)go:(UIBarButtonItem *)sender
{
    VideoController *vc =[VideoController new];
    vc.url = self.url;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{

    NSLog(@"-------%@",webView.request.URL.absoluteString);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
     __weak typeof(self) weakSelf = self;
    //点击传参数 jstoocHavePrams方法名称
    self.jsContext[@"callOC"] = ^(){
        //调用方法处理内容
        //获得参数数组
        NSArray *prams = [JSContext currentArguments];
        for (id obj in prams) {
            NSLog(@"====%@",[obj toObject]);
            weakSelf.url = [obj toObject];
        }
        
    };
    
    NSString *js = @"var url=location.href;callOC(url);";
    [webView stringByEvaluatingJavaScriptFromString:js];


}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


@end
