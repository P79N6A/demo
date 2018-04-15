//
//  YYWebController.m
//  fzdm
//
//  Created by czljcb on 2018/3/17.
//  Copyright © 2018年 Ward Wong. All rights reserved.
//

#import "YYWebController.h"

#import "XYYModel.h"
#import "Common.h"

@interface YYWebController ()
<
UIWebViewDelegate
>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YYWebController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kBackgroundColor;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
   
    self.webView = webView;
    
    self.webView.delegate = self;
    
    [self.view addSubview:webView];
    
    //self.urlStr = @"http://taobao.jszks.net/index.php/Movie/xiangxi?id=4596";
    NSURLRequest *re = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    
    [webView loadRequest:re];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endPlayVideo:)
                                                 name:UIWindowDidBecomeHiddenNotification
                                               object:self.view.window];
}




- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.absoluteString containsString:@"itunes.apple.com"]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1346960053?action=write-review"]];

        return NO;
    }

    if ([request.URL.absoluteString containsString:@"m3u8"]) {
        XYYModel *model = [XYYModel new];
        model.title = self.title;
        model.des = @"";
        model.url = [request.URL.absoluteString componentsSeparatedByString:@"url="].lastObject;
//        XYYPlayController *playVC = [XYYPlayController new];
//        playVC.model = model;
//        [self.navigationController pushViewController:playVC animated:YES];

        return NO;
    }
    
    return YES;
}

@end
