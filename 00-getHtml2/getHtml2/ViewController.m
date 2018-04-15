//
//  ViewController.m
//  getHtml2
//
//  Created by czljcb on 2017/12/29.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.tvmao.com/program/GDTV-GDTV1-w5.html"]]];
//
//    NSURL *url = [NSURL URLWithString:@"https://a1.easemob.com/1157170419178547/tv/token"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    request.HTTPBody = [@"{\"grant_type\":\"client_credentials\",\"client_id\":\"YXA6zzLdQCUJEeebLlUL7cvnFA\",\"client_secret\":\"YXA66SG7hwTE89cz-zH3RPb_7klRjQU\"}" dataUsingEncoding:NSUTF8StringEncoding];
//
//    NSURLSession *session = [NSURLSession sharedSession];
//    // 由于要先对request先行处理,我们通过request初始化task
//    NSURLSessionTask *task = [session dataTaskWithRequest:request
//                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
//
//                                        }];
//    [task resume];
    
//    NSURL *url = [NSURL URLWithString:@"https://a1.easemob.com/1157170419178547/tv/chatrooms?pagenum=1&pagesize=999999"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"GET";
//    NSString *author = [NSString stringWithFormat:@"Bearer YWMtM38EKO0xEeeaOH_bC2LHyAAAAAAAAAAAAAAAAAAAAAHPMt1AJQkR55suVQvty-cUAgMAAAFgpkZzcwBPGgBPNlXKsW700nXclFPPjx9cgnlmsyLMxdtZ-XWHM-mNJQ"];
//    [request setValue:author forHTTPHeaderField:@"Authorization"];
//
//    NSURLSession *session = [NSURLSession sharedSession];
//    // 由于要先对request先行处理,我们通过request初始化task
//    NSURLSessionTask *task = [session dataTaskWithRequest:request
//                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//
//
//                                            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
//
//                                            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//
//
//
//                                        }];
//    [task resume];
    
    NSURL *url = [NSURL URLWithString:@"https://a1.easemob.com/1157170419178547/tv/chatrooms"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *author = [NSString stringWithFormat:@"Bearer YWMtM38EKO0xEeeaOH_bC2LHyAAAAAAAAAAAAAAAAAAAAAHPMt1AJQkR55suVQvty-cUAgMAAAFgpkZzcwBPGgBPNlXKsW700nXclFPPjx9cgnlmsyLMxdtZ-XWHM-mNJQ"];
    [request setValue:author forHTTPHeaderField:@"Authorization"];
    
    
    NSString *body = [NSString stringWithFormat:@"{\"name\":\"%@\",\"description\":\"server create chatroom\",\"owner\":\"Jayson\"}",@"明珠台"];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    // 由于要先对request先行处理,我们通过request初始化task
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            
                                            if (error) {
                                                                                                return ;
                                            }
                                            
                                            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                                            
                                            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                            
                                            
                                            
                                        }];
    [task resume];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%s", __func__);
}



@end
