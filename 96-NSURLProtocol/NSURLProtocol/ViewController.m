//
//  ViewController.m
//  NSURLProtocol
//
//  Created by Jay on 24/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic)  UIWebView *webView11;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:webView];
    self.webView11 = webView;
    [self.webView11 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://v.qq.com/"]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
