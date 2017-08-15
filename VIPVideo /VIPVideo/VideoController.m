//
//  VideoController.m
//  VIPVideo
//
//  Created by pkss on 2017/5/22.
//  Copyright © 2017年 J. All rights reserved.
//

#import "VideoController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <MediaPlayer/MediaPlayer.h>
@interface VideoController ()<UIWebViewDelegate>;
@property (nonatomic, strong) JSContext *jsContext;
/** <##> */
@property (nonatomic, strong) MPMoviePlayerController *playerController;
@end

@implementation VideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = [UIScreen mainScreen].bounds;
    
    [self.view addSubview:webView];
    webView.delegate = self;
    
    NSString *url = [NSString stringWithFormat:@"https://api.47ks.com/webcloud/?v=http://m.youku.com/video/id_XNjY2MzAzNzQw.html"];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (MPMoviePlayerController *)playerController
{
        // 1.获取视频的URL
        NSURL *url = [NSURL URLWithString:self.url];
        
        // 2.创建控制器
        _playerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
        
        // 3.设置控制器的View的位置
        _playerController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
        
        // 4.将View添加到控制器上
        [self.view addSubview:_playerController.view];
        
        // 5.设置属性
        _playerController.controlStyle = MPMovieControlStyleNone;
    
    return _playerController;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self) weakSelf = self;
    //点击传参数 jstoocHavePrams方法名称
    self.jsContext[@"callOC"] = ^(){
        //调用方法处理内容
        //获得参数数组
        NSArray *prams = [JSContext currentArguments];
        for (id obj in prams) {
            NSLog(@"====%@",[obj toObject]);
            weakSelf.url = [obj toObject];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf playerController];

            });
        }
        
    };
    
    NSString *js = @"var url = document.getElementById(\"vod\").src;alert(url);callOC(url);";
    [webView stringByEvaluatingJavaScriptFromString:js];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

@end
