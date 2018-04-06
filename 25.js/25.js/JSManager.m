//
//  JSManager.m
//  25.js
//
//  Created by czljcb on 2017/12/7.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "JSManager.h"

static id instance = nil;

@interface JSManager ()
@property (nonatomic, strong) UIWebView *webView;
@end


@implementation JSManager

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}


#pragma mark  -  get/set 方法
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    return _webView;
}

@end
