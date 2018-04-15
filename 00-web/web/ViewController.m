//
//  ViewController.m
//  web
//
//  Created by czljcb on 2018/3/29.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.91kds.net/jiemu_cctv6.html"]];
    
    [self.webView.scrollView setContentOffset:CGPointMake(0, 45)];
    //self.webView.scrollView.scrollEnabled = NO;
    self.webView.backgroundColor = [UIColor blackColor];
    self.webView.scrollView.delegate = self;
    [self.webView loadRequest:request];
    self.webView.hidden = YES;
    [self.webView setMediaPlaybackRequiresUserAction:NO];

}


-(UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return nil;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSMutableString *str = [NSMutableString stringWithString:@""];
    
    

    
    [str appendString:@"var navbar = document.getElementsByClassName('ui-navbar')[0];"];
    [str appendString:@"navbar.parentNode.removeChild(navbar);"];

    
    [str appendString:@"var search = document.getElementsByClassName('ui-input-search')[0];"];
    [str appendString:@"search.parentNode.removeChild(search);"];

    
    [str appendString:@"var header = document.getElementsByClassName('ui-header')[0];"];
    [str appendString:@"header.parentNode.removeChild(header);"];

    [str appendString:@"var footer = document.getElementsByClassName('ui-footer')[0];"];
    [str appendString:@"footer.parentNode.removeChild(footer);"];
    
    [str appendString:@"var listview = document.getElementById('myEpg');"];
    [str appendString:@"listview.parentNode.removeChild(listview);"];
    
    
    
    [str appendString:@"var aswift_1_expand = document.getElementById('aswift_1_expand');"];
    [str appendString:@"aswift_1_expand.parentNode.removeChild(aswift_1_expand);"];


    [str appendString:@"var box = document.getElementsByClassName('ui-body-c')[0];"];
    [str appendString:@"var tagStyle = document.createElement('style');tagStyle.setAttribute('type', 'padding-top: 0px; min-height: 287px; padding-bottom: 0px;');"];
    [str appendString:@"var tagHeadAdd = box(tagStyle);"];
//


    //
    
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    self.webView.hidden = NO;
    NSLog(@"%s--%@", __func__,webView.request.URL.absoluteString);


}

@end
