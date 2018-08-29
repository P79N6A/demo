//
//  HybridNSURLProtocol.m
//  WKWebVIewHybridDemo
//
//  Created by shuoyu liu on 2017/1/16.
//  Copyright © 2017年 shuoyu liu. All rights reserved.
//

#import "HybridNSURLProtocol.h"
#import <UIKit/UIKit.h>

static NSString*const sourUrl  = @"https://m.baidu.com/static/index/plus/plus_logo.png";
static NSString*const sourIconUrl  = @"http://m.baidu.com/static/search/baiduapp_icon.png";
static NSString*const localUrl = @"http://mecrm.qa.medlinker.net/public/image?id=57026794&certType=workCertPicUrl&time=1484625241";

static NSString* const KHybridNSURLProtocolHKey = @"KHybridNSURLProtocol";
@interface HybridNSURLProtocol ()<NSURLSessionDelegate>
@property (nonnull,strong) NSURLSessionDataTask *task;

@end


@implementation HybridNSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"]  == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame ))
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:KHybridNSURLProtocolHKey inRequest:request]
            ){
            return NO;
        }

        return YES;
    }
    return NO;
}

+ (BOOL)replaceAdHostsWebString:(NSArray *)adhosts response:(NSString **)response{
    BOOL isContain = NO;
    
    for (NSString *adhost in adhosts) {
        isContain = isContain | [[self class]  replaceWebString:adhost response:response];
    }
    return  isContain;
}


+ (BOOL)replaceWebString:(NSString *)adhost response:(NSString **)response{
    BOOL isContain = NO;
    if ([*response containsString:adhost]) {
        *response = [*response stringByReplacingOccurrencesOfString:adhost withString:@""];
        isContain = YES;
    }
    return  isContain;
}


+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [mutableReqeust setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 11_2 like Mac OS X) AppleWebKit/604.4.7 (KHTML, like Gecko)" forHTTPHeaderField:@"User-Agent"];
    
    //request截取重定向
    if ([request.URL.absoluteString isEqualToString:sourUrl])
    {
        NSURL* url1 = [NSURL URLWithString:localUrl];
        mutableReqeust = [NSMutableURLRequest requestWithURL:url1];
    }
    
    NSString *requestUrl = request.URL.absoluteString;
    // 拦截广告
    if ([requestUrl containsString:@"img.09mk.cn"]
        ||[requestUrl containsString:@"img.xiaohui2.cn"]
        ||[requestUrl containsString:@".xiaohui"]
        ||[requestUrl containsString:@".apple.com"]
        ||[requestUrl containsString:@"img2."]
        ||[requestUrl containsString:@"sysapr.cn"]
        ) {
        mutableReqeust = nil;
    }
    else
    if(
       [requestUrl containsString:@".m3u8"]
//       [requestUrl.pathExtension hasPrefix:@"m3u8"]
//       ||[requestUrl containsString:@".mp4"]
       )
    {
//        if (![[UIViewController topViewController] isKindOfClass:[HLPlayerViewController class]]) {
            NSArray *urlArray = [requestUrl componentsSeparatedByString:@"url="];
            
//            static bool isShow = NO;
//            HLPlayerViewController *playerVC = [[HLPlayerViewController alloc] init];


        
            NSLog(@"RealVideoUrl %@", [urlArray lastObject]);
//            playerVC.url = [NSURL URLWithString:[urlArray lastObject]];
//            UIViewController *topVC = [UIViewController topkeyWindowViewController];
//            __block __weak HLHomeViewController *homeVC = nil;
//            for (UIViewController *vc in topVC.navigationController.childViewControllers) {
//                if ([vc isKindOfClass:NSClassFromString(@"HLHomeViewController")]) {
//                    playerVC.title = vc.title?:vc.navigationItem.title;
//                    homeVC = (id)vc;
//                    break;
//                }
//            }
//
//
//            playerVC.backBlock = ^(BOOL finish){
//                if (finish && (urlArray.count >= 2) && [[homeVC webView] respondsToSelector:@selector(canGoBack)]) {
//                    if ([[homeVC webView] performSelector:@selector(canGoBack)]) {
//                        [[homeVC webView] performSelector:@selector(goBack)];
//                    }
//                }
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    isShow = NO;
//                });
//            };
//
//            [[UIViewController topkeyWindowViewController] presentViewController:playerVC animated:YES completion:nil];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SPVipVideoCurrentDidChange" object:nil userInfo:@{@"url":[urlArray lastObject]}];
//            if([[self topViewController] isKindOfClass:[MPMoviePlayerViewController class]]) return ;
//
//            MPMoviePlayerViewController *playVC = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:[urlArray lastObject]]];
//            playVC.view.frame = CGRectMake(0, 100, 414, 300);
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playVC animated:YES completion:nil];
        });
     
        

        
        
            mutableReqeust = nil;
//        }
    }
    else {
        NSLog(@"requestUrl = %@",requestUrl);
    }
    
    return mutableReqeust;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //给我们处理过的请求设置一个标识符, 防止无限循环,
    [NSURLProtocol setProperty:@YES forKey:KHybridNSURLProtocolHKey inRequest:mutableReqeust];
    
    //这里最好加上缓存判断，加载本地离线文件， 这个直接简单的例子。
    if ([mutableReqeust.URL.absoluteString isEqualToString:sourIconUrl])
    {
            NSData* data = UIImagePNGRepresentation([UIImage imageNamed:@"medlinker"]);
            NSURLResponse* response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:@"image/png" expectedContentLength:data.length textEncodingName:nil];
            [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
            [self.client URLProtocol:self didLoadData:data];
            [self.client URLProtocolDidFinishLoading:self];
    }
    else
    {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        self.task = [session dataTaskWithRequest:self.request];
        
        NSLog(@"xxxx request %@", self.request.URL.absoluteString);
        
        [self.task resume];
    }
}
- (void)stopLoading
{
    if (self.task != nil)
    {
        [self.task  cancel];
    }
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    [self.client URLProtocolDidFinishLoading:self];
}


@end
