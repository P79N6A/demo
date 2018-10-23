//
//  HybridNSURLProtocol.m
//  WKWebVIewHybridDemo
//
//  Created by shuoyu liu on 2017/1/16.
//  Copyright © 2017年 shuoyu liu. All rights reserved.
//

#import "HybridNSURLProtocol.h"
#import <UIKit/UIKit.h>

//static NSString*const sourUrl  = @"https://m.baidu.com/static/index/plus/plus_logo.png";
//static NSString*const sourIconUrl  = @"http://m.baidu.com/static/search/baiduapp_icon.png";
//static NSString*const localUrl = @"http://mecrm.qa.medlinker.net/public/image?id=57026794&certType=workCertPicUrl&time=1484625241";

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

//+ (BOOL)replaceAdHostsWebString:(NSArray *)adhosts response:(NSString **)response{
//    BOOL isContain = NO;
//
//    for (NSString *adhost in adhosts) {
//        isContain = isContain | [[self class]  replaceWebString:adhost response:response];
//    }
//    return  isContain;
//}
//
//
//+ (BOOL)replaceWebString:(NSString *)adhost response:(NSString **)response{
//    BOOL isContain = NO;
//    if ([*response containsString:adhost]) {
//        *response = [*response stringByReplacingOccurrencesOfString:adhost withString:@""];
//        isContain = YES;
//    }
//    return  isContain;
//}


+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    
    if ([self isProtocolService]) {
        return nil;
    }

    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    //[mutableReqeust setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1" forHTTPHeaderField:@"User-Agent"];
    
    

    
    NSString *requestUrl = request.URL.absoluteString;
    
    //request截取重定向
    if ([self reloadURL:requestUrl])
    {
        NSURL* url1 = [NSURL URLWithString:[self reloadURL:requestUrl]];
        mutableReqeust = [NSMutableURLRequest requestWithURL:url1];
        NSLog(@"\n重定向URL：%@", requestUrl);
    }else
    //拦截广告
    if ([self stringContainsAdTypeType:requestUrl]) {
        NSLog(@"\n拦截广告URL：%@", requestUrl);
        mutableReqeust = nil;
    }else
    //拦截视频
    if([self stringContainsMediaTypeType:requestUrl])
    {
        //NSArray *urlArray = [requestUrl componentsSeparatedByString:self.sepType];
        NSArray *urlArray = [requestUrl componentsSeparatedByString:@"=http"];
        NSString *url = urlArray.lastObject;
        if (urlArray.count>1) {
            url = [NSString stringWithFormat:@"http%@",url];
        }

        NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        NSLog(@"拦截视频URL:%@--请求URL--:%@", url,requestUrl);
        NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SPVipVideoCurrentDidChange" object:nil userInfo:@{@"url":url}];
        });

        mutableReqeust = nil;
    }else
     {
        NSLog(@"\n请求URL：%@", requestUrl);
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
//    if ([mutableReqeust.URL.absoluteString isEqualToString:sourIconUrl])
//    {
//            NSData* data = UIImagePNGRepresentation([UIImage imageNamed:@"medlinker"]);
//            NSURLResponse* response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:@"image/png" expectedContentLength:data.length textEncodingName:nil];
//            [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
//            [self.client URLProtocol:self didLoadData:data];
//            [self.client URLProtocolDidFinishLoading:self];
//    }
//    else
    {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        self.task = [session dataTaskWithRequest:self.request];
        
        //NSLog(@"请求 request %@", self.request.URL.absoluteString);
        
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

//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
//    [self.client URLProtocolDidFinishLoading:self];
//}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
//    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//
//    completionHandler(NSURLSessionResponseAllow);
//}

//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
//    [self.client URLProtocol:self didLoadData:data];
//}


//FIXME:  -  防代理服务器
+ (BOOL)isProtocolService{
    
#ifdef DEBUG
    return NO;
#else
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    //NSLog(@"\n%@",proxies);
    
    NSDictionary *settings = proxies[0];
    //NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    //NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    //NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        //NSLog(@"没代理");
        return NO;
    }
    else
    {
        NSLog(@"设置了代理");
        return YES;
    }
#endif
    
}



+ (BOOL)stringContainsMediaTypeType:(NSString *)str {
    __block BOOL isContains = NO;
    NSArray *filterTypes = [self mediaType];
    [filterTypes enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *  stop) {
        if([str containsString:obj]){
            isContains = YES;
            *stop = YES;
        }
    }];
    return isContains;
}
+ (BOOL)stringContainsAdTypeType:(NSString *)str {
    __block BOOL isContains = NO;
    NSArray *filterTypes = [self adType];
    [filterTypes enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *  stop) {
        if([str containsString:obj]){
            isContains = YES;
            *stop = YES;
        }
    }];
    return isContains;
}


+ (NSString *)reloadURL:(NSString *)orginURL{
    __block NSString *url;
    [[self reloadType] enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *  stop) {
        if([orginURL containsString:key]){
            url = obj;
            *stop = YES;
        }
    }];
    return url;
}

+ (NSArray <NSString *>*)mediaType{
    NSArray *types = [[NSUserDefaults standardUserDefaults] arrayForKey:@"mediaType"];
    return types? types : @[@".m3u8"];
}

+ (NSArray <NSString *>*)adType{
    NSArray *types = [[NSUserDefaults standardUserDefaults] arrayForKey:@"adType"];
    return types? types : @[];
}

+ (NSDictionary*)reloadType{
    NSDictionary *types = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"reload"];
    return types? types : @{};
}

//+ (NSString *)sepType{
//    NSString *type = [[NSUserDefaults standardUserDefaults] stringForKey:@"sepType"];
//    return type? type : @"url=";
//}


@end
