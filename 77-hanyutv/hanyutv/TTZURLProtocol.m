//
//  TTZURLProtocol.m
//  hanyutv
//
//  Created by Jay on 29/6/18.
//  Copyright © 2018年 Jayson. All rights reserved.
//

#import "TTZURLProtocol.h"

#define protocolKey @"protocolKey"

@implementation TTZURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    
    if ([NSURLProtocol propertyForKey:protocolKey inRequest:request]) {
        return NO;
    }
    
    NSString *scheme = [[request URL] scheme];
    if ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
        [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame) {
        return YES;
    }
    
    return NO;
    
}
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}
/**
 * 开始请求
 */
- (void)startLoading {
    NSMutableURLRequest *request = [self.request mutableCopy];
    //把访问百度的request改为访问Google了
//    request.URL = [NSURL URLWithString:@"https://www.jianshu.com/"];

    [NSURLProtocol setProperty:@(YES) forKey:protocolKey inRequest:request];

    //使用NSURLSession继续把重定向的request发送出去
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:mainQueue];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];

    [task resume];
}

- (void)stopLoading{
//    [self.connection cancel];
//    self.connection = nil;
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    completionHandler(proposedResponse);
}

@end
