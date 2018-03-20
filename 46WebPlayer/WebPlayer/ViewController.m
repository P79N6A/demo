//
//  ViewController.m
//  WebPlayer
//
//  Created by Jay on 2018/3/2.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <SafariServices/SafariServices.h>
#import "UIAlertController+Blocks.h"

@interface ViewController ()
@property (nonatomic, strong)  WKWebView *webView;
@end

@implementation ViewController


- (WKWebView *)webView
{
    if (!_webView) {
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.mediaPlaybackRequiresUserAction = NO;//把手动播放设置NO ios(8.0, 9.0)
        config.allowsInlineMediaPlayback = YES;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
        config.mediaPlaybackAllowsAirPlay = YES;//允许播放，ios(8.0, 9.0)
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, w, h) configuration:config];
        
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
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUI];
}


- (void)setUI{
    [self.view addSubview:self.webView];
    NSString *m3u8 = @"http://acm.gg/inews.m3u8";
    NSString * html = [NSString stringWithFormat:@"<html><body style=\"margin:0;background-color:#FFFFFF;width:100%%;height:100%%;\" ><video style=\"margin:0;background-color:#000000; width:100%%; \"   controls autoplay playsinline webkit-playsinline  type=\"application/vnd.apple.mpegurl\"><source src=\"%@\" id=\"myVideo\">当前环境不支持播放</video></body></html>",m3u8];
    
    [self.webView loadHTMLString:html baseURL:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        NSString *fileExtension = m3u8.pathExtension;
        
        if ([m3u8 containsString:@"pan.baidu.com"]) {
            [UIAlertController showActionSheetInViewController:self withTitle:@"title" message:@"该链接为百度云连接,是否保存到百度云" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"保存"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
                
            } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if(buttonIndex == controller.cancelButtonIndex) return ;
                
                SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:m3u8]];
                [self presentViewController:safariVC animated:YES completion:nil];
                
                
            }];
        }
        else if([m3u8 containsString:@"html"] ||
                [fileExtension isEqualToString:@""] ||
                [fileExtension containsString:@"php"] ||
                [fileExtension containsString:@"mp4"]){
            [UIAlertController showActionSheetInViewController:self withTitle:@"title" message:@"该链接可能无法播放,是否跳到站外观看" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
                
            } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if(buttonIndex == controller.cancelButtonIndex) return ;
                
                SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:m3u8]];
                [self presentViewController:safariVC animated:YES completion:nil];
                
            }];
            return;
        }
    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
