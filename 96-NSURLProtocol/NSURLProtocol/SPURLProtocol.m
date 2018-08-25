//
//  SPURLProtocol.m
//  NSURLProtocol
//
//  Created by Jay on 24/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPURLProtocol.h"

static NSString * const hasInitKey = @"LLMarkerProtocolKey";

@implementation SPURLProtocol

//+(BOOL)canInitWithRequest:(NSURLRequest *)request{
//    if ([NSURLProtocol propertyForKey:hasInitKey inRequest:request]) {
//        return NO;
//    }
//    return YES;
//}
//+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
//    return request;
//}
//
//-(void)startLoading{
//    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
//    //做下标记，防止递归调用
//    [NSURLProtocol setProperty:@YES forKey:hasInitKey inRequest:mutableReqeust];
//    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
//}
//
//-(void)stopLoading{
//    [self.connection cancel];
//}
//
//#pragma mark - NSURLConnectionDelegate
//
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//    [self.client URLProtocol:self didFailWithError:error];
//}
//#pragma mark - NSURLConnectionDataDelegate
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    self.responseData = [[NSMutableData alloc] init];
//    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    [self.responseData appendData:data];
//    [self.client URLProtocol:self didLoadData:data];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    [self.client URLProtocolDidFinishLoading:self];
//}


@end
