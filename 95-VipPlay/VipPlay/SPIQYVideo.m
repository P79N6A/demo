//
//  SPIQYVideo.m
//  VipPlay
//
//  Created by Jay on 27/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPIQYVideo.h"
#import <WebKit/WebKit.h>
#import <MediaPlayer/MediaPlayer.h>

static SPIQYVideo *instance = nil;

@interface SPIQYVideo()
@property (nonatomic, strong)  WKWebView*webView;
@end

@implementation SPIQYVideo

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [super allocWithZone:zone];
        
    });
    
    return instance;
}


+ (instancetype)sharedVideo{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        [NSURLProtocol wk_registerScheme:@"http"];
        [NSURLProtocol wk_registerScheme:@"https"];
    });
    
    return instance;
}

- (void)playWithURL:(NSString *)urlString
           completion:(void(^)(NSString *url))completed{
    [[UIApplication sharedApplication].keyWindow addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (WKWebView *)webView{
    if (!_webView) {
        // 1.创建webview，并设置大小，"20"为状态栏高度
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0,100,100)];
        
        // 2.创建请求
        
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.cnblogs.com/mddblog/"]];
        
        // 3.加载网页
        
        [webView loadRequest:request];
        
        
        
        //最后将webView添加到界面
        
        //[self.view addSubview:webView];
        
        _webView = webView;
    }
    
    return _webView;
}

@end








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
           //       ||[requestUrl.pathExtension hasPrefix:@"mp4"]
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
                if([[self topViewController] isKindOfClass:[MPMoviePlayerViewController class]]) return ;
                
                MPMoviePlayerViewController *playVC = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:[urlArray lastObject]]];
                playVC.view.frame = CGRectMake(0, 100, 414, 300);
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playVC animated:YES completion:nil];
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

//FIXME:  -  自定义方法
+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
        
    }
    return resultVC;
}
+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
//FOUNDATION_STATIC_INLINE 属于属于runtime范畴，你的.m文件需要频繁调用一个函数,可以用static inline来声明。从SDWebImage从get到的。
FOUNDATION_STATIC_INLINE Class ContextControllerClass() {
    static Class cls;
    if (!cls) {
        cls = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
    }
    return cls;
}

FOUNDATION_STATIC_INLINE SEL RegisterSchemeSelector() {
    return NSSelectorFromString(@"registerSchemeForCustomProtocol:");
}

FOUNDATION_STATIC_INLINE SEL UnregisterSchemeSelector() {
    return NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
}

@implementation NSURLProtocol (WebKitSupport)

+ (void)wk_registerScheme:(NSString *)scheme {
    Class cls = ContextControllerClass();
    SEL sel = RegisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
        // 放弃编辑器警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

+ (void)wk_unregisterScheme:(NSString *)scheme {
    Class cls = ContextControllerClass();
    SEL sel = UnregisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
        // 放弃编辑器警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

@end
