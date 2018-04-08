//
//  ViewController.m
//  web
//
//  Created by czljcb on 2018/3/29.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "WKWebController.h"
#import <WebKit/WebKit.h>
@interface WKWebController ()<UIScrollViewDelegate,WKNavigationDelegate>
@property (nonatomic, strong)  WKWebView *webView;
@end

@implementation WKWebController


- (WKWebView *)webView
{
    if (!_webView) {
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        //config.mediaPlaybackRequiresUserAction = NO;//把手动播放设置NO ios(8.0, 9.0)
        config.requiresUserActionForMediaPlayback = NO;//把手动播放设置NO ios(8.0, 9.0)
        
        config.allowsInlineMediaPlayback = YES;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
        
        //config.mediaPlaybackAllowsAirPlay = YES;//允许播放，ios(8.0, 9.0)
        config.allowsAirPlayForMediaPlayback = YES;//允许播放，ios(8.0, 9.0)
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, w, h) configuration:config];
        _webView.backgroundColor = [UIColor blackColor];
        _webView.navigationDelegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.alpha = 0.0;
        _webView.autoresizingMask =
        
        UIViewAutoresizingFlexibleLeftMargin   |
        
        UIViewAutoresizingFlexibleWidth        |
        
        UIViewAutoresizingFlexibleRightMargin  |
        
        UIViewAutoresizingFlexibleTopMargin    |
        
        UIViewAutoresizingFlexibleHeight       |
        
        UIViewAutoresizingFlexibleBottomMargin ;
        
        
        
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
    
}
- (void)dealloc{
    NSLog(@"%s---guole", __func__);
}

- (void)setUI{
    [self.view addSubview:self.webView];
    self.view.backgroundColor = [UIColor blackColor];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.91kds.net/jiemu_cctv6.html"]];
    [self.webView loadRequest:request];
    self.webView.scrollView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(beginPlayVideo:)
                                                 name:UIWindowDidBecomeVisibleNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endPlayVideo:)
                                                 name:UIWindowDidBecomeHiddenNotification
                                               object:self.view.window];

}

-(void)beginPlayVideo:(NSNotification *)notification{
    NSLog(@"结束--ok");

}


-(void)endPlayVideo:(NSNotification *)notification{
    NSLog(@"结束");
}


-(UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return nil;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSMutableString *tagJS = [NSMutableString stringWithString:@""];
    
    [tagJS appendString:@"var navbar = document.getElementsByClassName('ui-navbar')[0];"];
    [tagJS appendString:@"navbar.parentNode.removeChild(navbar);"];

    
    [tagJS appendString:@"var search = document.getElementsByClassName('ui-input-search')[0];"];
    [tagJS appendString:@"search.parentNode.removeChild(search);"];

    
    [tagJS appendString:@"var header = document.getElementsByClassName('ui-header')[0];"];
    [tagJS appendString:@"header.parentNode.removeChild(header);"];

    [tagJS appendString:@"var footer = document.getElementsByClassName('ui-footer')[0];"];
    [tagJS appendString:@"footer.parentNode.removeChild(footer);"];
    
    [tagJS appendString:@"var listview = document.getElementById('myEpg');"];
    [tagJS appendString:@"listview.parentNode.removeChild(listview);"];
    
    
    
    [tagJS appendString:@"var aswift_1_expand = document.getElementById('aswift_1_expand');"];
    [tagJS appendString:@"aswift_1_expand.parentNode.removeChild(aswift_1_expand);"];
    
    
    [tagJS appendString:@"var msg = document.getElementById('msg');"];
    [tagJS appendString:@"msg.parentNode.removeChild(msg);"];
    
    
    //[tagJS appendString:@"var span = document.document.getElementsByTagName('span')[0];"];
    //[tagJS appendString:@"span.parentNode.removeChild(span);"];

    
    [webView evaluateJavaScript:tagJS completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
       
        NSLog(@"%s-tagJS--%@----%@", __func__,obj,error);
        
    }];
    
    
    NSMutableString *videoJS = [NSMutableString stringWithString:@"var video = document.getElementById('ikdsPlayer');video.setAttribute(\"webkit-playsinline\",\"\");"];
    [videoJS appendString:@"video.setAttribute(\"playsinline\",\"\");"];

    [webView evaluateJavaScript:videoJS completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"%s-videoJS--%@----%@", __func__,obj,error);
    }];
    
    
    NSMutableString *myLiveBackJS = [NSMutableString stringWithString:@"var myLiveBack = document.getElementById('myLiveBack');"];
    [myLiveBackJS appendString:@"myLiveBack.setAttribute(\"style\",\"padding: 0px;margin-left: 0px;\");"];
    
    [webView evaluateJavaScript:myLiveBackJS completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"%s-videoJS--%@----%@", __func__,obj,error);
    }];


    NSMutableString *bodyJS = [NSMutableString stringWithString:@"var body = document.getElementsByTagName('body')[0];"];
    [bodyJS appendString:@"body.setAttribute(\"style\",\"background-color:white\");"];
    
    [webView evaluateJavaScript:bodyJS completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"%s-videoJS--%@----%@", __func__,obj,error);
    }];

    NSMutableString *pageJS = [NSMutableString stringWithString:@"var bodyc = document.getElementsByClassName('ui-body-c')[0];"];
    [pageJS appendString:@"bodyc.setAttribute(\"style\",\"padding-top: 64px; min-height: 523px;\");"];
    
    [webView evaluateJavaScript:pageJS completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"%s-bodyJS--%@----%@", __func__,obj,error);
    }];

    
    NSMutableString *uicontentJS = [NSMutableString stringWithString:@"var uicontent = document.getElementsByClassName('ui-content')[0];"];
    [uicontentJS appendString:@"uicontent.setAttribute(\"style\",\"padding: 0px;background-color:white;\");"];
    
    [webView evaluateJavaScript:uicontentJS completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"%s-uicontentJS--%@----%@", __func__,obj,error);
        [UIView animateWithDuration:0.25 animations:^{
            webView.alpha = 1.0;
        }];
    }];


    NSLog(@"%s--%@", __func__,webView.URL.absoluteString);


}

@end
