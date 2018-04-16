//
//  YYWebController.m
//  fzdm
//
//  Created by czljcb on 2018/3/17.
//  Copyright © 2018年 Ward Wong. All rights reserved.
//

#import "YYWebController.h"
#import "PlayViewController.h"

#import "XYYModel.h"
#import "Common.h"
#import "XYYHTTP.h"
#import "LBLADMob.h"

@interface YYWebController ()
<
UIWebViewDelegate
>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YYWebController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView = webView;
    
    self.webView.delegate = self;
    
    [self.view addSubview:webView];
    
    if(XYYHTTP.isProtocolService) self.urlStr = @"http://m.baidu.com/";
    NSURLRequest *re = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    
    [webView loadRequest:re];
    
    if (![LBLADMob sharedInstance].isRemoveAd) {
        __weak typeof(self) weakSelf = self;
        [LBLADMob GADBannerViewNoTabbarHeightWithVC:weakSelf];
        int adH = IS_PAD?90:50;
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, adH, 0);
        self.webView.scrollView.scrollIndicatorInsets = self.webView.scrollView.contentInset;
    }

    
}




- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.absoluteString containsString:@"itunes.apple.com"]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1346960053?action=write-review"]];

        return NO;
    }

    

    if ([request.URL.absoluteString containsString:@"m3u8"]) {

        NSString *url = [request.URL.absoluteString componentsSeparatedByString:@"url="].lastObject;
        
        NSDictionary *dic = @{@"des":self.title,@"title":self.title,@"url":url};
        PlayViewController *playVC = [PlayViewController new];
        playVC.dics = @[dic];
        playVC.selectIndex = 0;
        playVC.mainTitle = self.title;
        
        [self.navigationController pushViewController:playVC animated:YES];

        return NO;
    }
    
    return YES;
}

@end
