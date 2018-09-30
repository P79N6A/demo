//
//  ViewController.m
//  riyutv
//
//  Created by xin on 2018/9/8.
//  Copyright © 2018年 HKDramaFan. All rights reserved.
//

#import "ViewController.h"
#import "SPWebViewController.h"
#import "RiJuTV.h"

#import <WebKit/WebKit.h>

@interface ViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
@property (strong, nonatomic)  WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self test];
    
    NSString *json = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://jaysongd.github.io/api/tv.json"] encoding:NSUTF8StringEncoding error:NULL];
    NSArray *list = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONWritingPrettyPrinted error:NULL];

    NSLog(@"%s", __func__);
//
//    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.2 Safari/605.1.15"}];
//
//    //WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:self.webView];
//    self.webView.scrollView.delegate = self;
//    self.webView.navigationDelegate = self;
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.91kds.cn/jiemu_qiyijdgp.html"]]];//http://wx.iptv789.com/?act=play&token=9f2ffb31938f566ac6f5dd171c23cf33&tid=ys&id=1
////    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wx.iptv789.com/?act=play&token=9f2ffb31938f566ac6f5dd171c23cf33&tid=ys&id=1"]]];
//
//    [RiJuTV tvlist];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    SPWebViewController *vc = [SPWebViewController new];
    vc.url = @"http://m.91kds.cn/jiemu_qiyijdgp.html";
    [self presentViewController:vc animated:YES completion:nil];
}
/// FIXME: UIScrollViewDelegate
-(UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return nil;
}
#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
        NSMutableString *tagJS = [NSMutableString string];
    
    
    
    
        [tagJS appendString:@"var navbar = document.getElementsByClassName('ui-navbar')[0];"];
        [tagJS appendString:@"navbar.parentNode.removeChild(navbar);"];
    
    

    
        [tagJS appendString:@"var search = document.getElementsByClassName('ui-input-search')[0];"];
        [tagJS appendString:@"search.parentNode.removeChild(search);"];
    
    
        [tagJS appendString:@"var header = document.getElementsByClassName('ui-header')[0];"];
        [tagJS appendString:@"header.parentNode.removeChild(header);"];
    
        [tagJS appendString:@"var footer = document.getElementsByClassName('ui-footer')[0];"];
        [tagJS appendString:@"footer.parentNode.removeChild(footer);"];
        // FIXME: 预告
        [tagJS appendString:@"var listview = document.getElementById('myEpg');"];
        [tagJS appendString:@"listview.parentNode.removeChild(listview);"];
    
    
    
    
    
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
        [bodyJS appendString:@"body.setAttribute(\"style\",\"background-color:black\");"];
    
        [webView evaluateJavaScript:bodyJS completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            NSLog(@"%s-videoJS--%@----%@", __func__,obj,error);
        }];
    
        NSMutableString *pageJS = [NSMutableString stringWithString:@"var bodyc = document.getElementsByClassName('ui-body-c')[0];"];
        [pageJS appendString:@"bodyc.setAttribute(\"style\",\"padding-top: 0px;background-color:black;min-height: 0px;\");"];
    
        [webView evaluateJavaScript:pageJS completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            NSLog(@"%s-bodyJS--%@----%@", __func__,obj,error);
        }];
    
    
    
    
    
        NSMutableString *uicontentJS = [NSMutableString stringWithString:@"var uicontent = document.getElementsByClassName('ui-content')[0];"];
        [uicontentJS appendString:@"uicontent.setAttribute(\"style\",\"padding-top: 0px; background-color: black; min-height: 0px;\");"];
        [webView evaluateJavaScript:uicontentJS completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            NSLog(@"%s-uicontentJS--%@----%@", __func__,obj,error);
      
        }];
    
    
    
    
    
    
        NSLog(@"%s--%@", __func__,webView.URL.absoluteString);
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
    
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
    
    NSLog(@"%s-域名--%@", __func__,navigationAction.request.URL.host);
//    if([navigationAction.request.URL.host containsString:@".iptv789."]) decisionHandler(WKNavigationActionPolicyAllow);
//    else decisionHandler(WKNavigationActionPolicyCancel);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)test{
    
    

    NSLog(@"%s", __func__);
    NSURL * url = [NSURL URLWithString:@"https://github.com/LQJJ/demo/blob/master/104-BackgroundDownload/rijutv.json?raw=trun"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:15.0];

    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSString *searchText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%s--searchText : %@", __func__,searchText);
        
    }];
    //开启网络任务
    [task resume];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [TaiJuHtml getTaiJuPageNo:1 completed:^(NSArray<NSDictionary *> *objs) {
//        ;
//    }];
    
//    [TaiJuHtml getTaiJuDetail:@"https://www.rijutv.com/riju/12497.html" completed:^(NSDictionary *obj) {
//        ;
//    }];
    
//    [TaiJuHtml taiJuM3u8:@"https://www.rijutv.com/player/29737.html" completed:^(NSArray *objs) {
//        ;
//    }];
    
//    [TaiJuHtml taiJuHls:@"https://jiexi.rijutv.com/index.php?path=6e69o9HsPT%2BaotXjc%2Fw77idji9DPinCC1sefJG7vTyXRYyXQoD0tdVoQ0q%2Bl87TgHbrS05eSEFKwsLxO6UDxsbk%2B07cdP5vCxLTaGIkvHI%2Bl9NVLTSO7r5wteWB%2FvqHJsJvI" completed:^(NSString *obj) {
//        ;
//    }];
    
//    [RiJuTV searchRiJu:@"日剧" pageNo:1 completed:^(NSArray<NSDictionary *> *objs, BOOL hasMore) {
//        ;
//    }];
    
//    [RiJuTV getJianShuObj:@"https://www.jianshu.com/p/820831f547a2" completed:^(id obj) {
//        NSLog(@"%s", __func__);
//    }];
    
  
        
//        UIView *fron = [[self.view subviews] objectAtIndex:0];
//
//        UIView *back = [[self.view subviews] objectAtIndex:1];
//
//
//        CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//        [UIView beginAnimations:nil context:ctx];
//
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//
//        [UIView setAnimationDuration:2.0];
    
    
//        fron.alpha = 0.0f;
//    
//        back.alpha = 1.0f;
    
//        fron.transform = CGAffineTransformMakeScale(0.25f, 0.25f);
    
//        back.transform = CGAffineTransformIdentity;
//    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];

    
    
//        [UIView setAnimationDelegate:self];
//
//        [UIView commitAnimations];
//

//}


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
        //        _webView.navigationDelegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        //        _webView.alpha = 0.0;
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

@end
