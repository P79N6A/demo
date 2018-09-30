//
//  SPWebViewController.m
//  riyutv
//
//  Created by Jay on 30/9/18.
//  Copyright © 2018年 HKDramaFan. All rights reserved.
//

#import "SPWebViewController.h"
#import <WebKit/WebKit.h>


@interface SPWebViewController ()
<WKNavigationDelegate,UIScrollViewDelegate>
@property (strong, nonatomic)  WKWebView *webView;
@end

@implementation SPWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.webView];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];

}
/// FIXME: UIScrollViewDelegate
-(UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return nil;
}
#pragma mark - WKNavigationDelegate
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    [self.js enumerateObjectsUsingBlock:^(NSString * js, NSUInteger idx, BOOL * _Nonnull stop) {
        [webView evaluateJavaScript:js completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            //NSLog(@"%s-js--%@----%@", __func__,js,error);
        }];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        webView.hidden = NO;
    });
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    //decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
    NSString *url = navigationAction.request.URL.absoluteString;
    NSLog(@"%s-域名--%@", __func__,url);
    if([self stringContainsAdTypeType:url]) decisionHandler(WKNavigationActionPolicyCancel);
    else decisionHandler(WKNavigationActionPolicyAllow);
    
}







- (WKWebView *)webView
{
    if (!_webView) {
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        //config.mediaPlaybackRequiresUserAction = NO;//把手动播放设置NO ios(8.0, 9.0)
        if (@available(iOS 9.0, *)) {
            config.requiresUserActionForMediaPlayback = NO;
        } else {
            // Fallback on earlier versions
        }//把手动播放设置NO ios(8.0, 9.0)
        
        config.allowsInlineMediaPlayback = YES;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
        
        //config.mediaPlaybackAllowsAirPlay = YES;//允许播放，ios(8.0, 9.0)
        if (@available(iOS 9.0, *)) {
            config.allowsAirPlayForMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
        }//允许播放，ios(8.0, 9.0)
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, w, h) configuration:config];
        _webView.backgroundColor = [UIColor blackColor];
        //_webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.hidden = YES;
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


- (BOOL)stringContainsAdTypeType:(NSString *)url {
    __block BOOL isContains = NO;
    [self.filter enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *  stop) {
        if([url containsString:obj]){
            isContains = YES;
            *stop = YES;
        }
    }];
    return isContains;
}
- (NSArray<NSString *> *)js{
    if (!_js) {
        _js = @[
                @"var navbar = document.getElementsByClassName('ui-navbar')[0];navbar.parentNode.removeChild(navbar);",
                @"var search = document.getElementsByClassName('ui-input-search')[0];search.parentNode.removeChild(search);",
                @"var header = document.getElementsByClassName('ui-header')[0];header.parentNode.removeChild(header);",
                @"var footer = document.getElementsByClassName('ui-footer')[0];footer.parentNode.removeChild(footer);",
                @"var listview = document.getElementById('myEpg');listview.parentNode.removeChild(listview);",
               
                @"var video = document.getElementById('ikdsPlayer');video.setAttribute(\"webkit-playsinline\",\"\");video.setAttribute(\"playsinline\",\"\");",
                
                @"var myLiveBack = document.getElementById('myLiveBack');myLiveBack.setAttribute(\"style\",\"padding: 0px;margin-left: 0px;\");",
                
                @"var body = document.getElementsByTagName('body')[0];body.setAttribute(\"style\",\"background-color:black\");",
                @"var bodyc = document.getElementsByClassName('ui-body-c')[0];bodyc.setAttribute(\"style\",\"padding-top: 0px;background-color:black;min-height: 0px;\");",
                
                //@"var uicontent = document.getElementsByClassName('ui-content')[0];uicontent.setAttribute(\"style\",\"padding-top: 0px; background-color: black; min-height: 0px;\");"
                ];
    }
    return _js;
}
- (NSArray<NSString *> *)filter{
    if (!_filter) {
        _filter = @[@"google",@"ads"];
    }
    return _filter;
}
@end
