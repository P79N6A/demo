//
//  ViewController.m
//  free
//
//  Created by Jay on 8/5/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "DANet.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController


- (NSString *)URLDecode:(NSString *)string
{
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)URLEncode:(NSString *)string
{
    NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

    return [self urlEncodeUsingEncoding:gb2312 text:string];
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding text:(NSString *)srting
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)srting,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding)));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *parame = @{
                             @"xing":@"曹",
                             @"ming":@"志",
                             @"xingbie":@"男",
                             @"xuexing":@"A",
                             @"nian":@"1998",
                             @"yue":@"09",
                             @"ri":@"09",
                             @"hh":@"12",
                             @"mm":@"23",

                             };
    
    
    
    NSMutableArray *temp = [NSMutableArray array];
    [parame enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL * _Nonnull stop) {
        obj = [self URLEncode:obj];
        [temp addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
    }];
    
    //确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://m.dajiazhao.com/sm/scbz.asp"];
    //创建可变请求对象
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    //修改请求方法
    requestM.HTTPMethod = @"POST";
    
    
    //设置请求体
    requestM.HTTPBody = [[temp componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
    //创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //创建请求 Task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:requestM completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          
                                          NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

                                          //解析返回的数据
                                          NSLog(@"%@", [[NSString alloc] initWithData:data encoding:gb2312]);
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [self.webView loadHTMLString:[[NSString alloc] initWithData:data encoding:gb2312] baseURL:nil];
                                          });
                                      }];
    //发送请求
    [dataTask resume];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
