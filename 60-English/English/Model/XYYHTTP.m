
#import "XYYHTTP.h"

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

static id instance = nil;

@interface XYYHTTP ()

@property(nonatomic, strong)AFHTTPSessionManager *manger;

@property(nonatomic, assign) BOOL NotReachable;

@end

@implementation XYYHTTP

- (AFHTTPSessionManager *)manger{
    if (_manger == nil) {
        _manger = [AFHTTPSessionManager manager];
        
        NSString  *userAgent = [NSString stringWithFormat:@"dian shi ju da quan/1.3 (%@; iOS %@; Scale/%0.2f)", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
      
        [_manger.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];

        [_manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        
        _manger.requestSerializer.timeoutInterval = 15.f;
        
        [_manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
                
        _manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html", @"application/x-javascript",nil];
        
        NSSet *set = [NSSet setWithObjects:@"text/plain",@"application/json", @"text/json", @"text/javascript", @"text/html", @"image/png", nil];
        
        _manger.responseSerializer.acceptableContentTypes =[_manger.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:set];

        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        [AFNetworkActivityIndicatorManager sharedManager].activationDelay = 0;
    }
    
    return _manger;
}


+ (void)startNetworkMonitoring{
   
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    
        if (!KBOOLLINE) {[[XYYHTTP sharedInstance] appStatus];}
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"GG"];
        
        [XYYHTTP sharedInstance].NotReachable = NO;
        
        switch (status) {
        
            case AFNetworkReachabilityStatusUnknown:
                break;
            
            case AFNetworkReachabilityStatusNotReachable:
               
                [XYYHTTP sharedInstance].NotReachable = YES;
                break;
            
            case AFNetworkReachabilityStatusReachableViaWWAN:
            
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GG"];
                break;
          
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
            default:
                break;
        }
    }];
    
    [manager startMonitoring];
}

- (void)getRequest :(NSString *)urlString

         parameters:(id)parameters

            success:(void(^)(id respones))success

            failure:(void(^)(NSError *error))failure{
    
    if(XYYHTTP.isProtocolService) return;
   
    [self.manger GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        if (success) {success(responseObject);}
    
    } failure:nil];
}

- (BOOL)appLine {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"onlinKey"];
}



- (void)appStatus{
    
    if(XYYHTTP.isProtocolService) return;

    NSString *url = [NSString stringWithFormat:@"http://p049oo2ps.bkt.clouddn.com/xyy.json?r=%d&t=%f&d=%f",rand(),[[NSDate date] timeIntervalSince1970],[[NSDate date] timeIntervalSince1970]*[[NSDate date] timeIntervalSince1970]];
    
    [self.manger GET:url
     
          parameters:nil progress:nil
     
             success:nil failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 if (([error.localizedDescription containsString:@"404"] || [error.localizedDescription containsString:@"not found"])) {
                     
                     if([self appLine]) return;
                     
                     if ([XYYHTTP sharedInstance].NotReachable) return;
                     
                     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"onlinKey"];
                     
                     !(_onLinebBlock)? : _onLinebBlock();
                 }
             }];
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}


+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        
        [self startNetworkMonitoring];
    });
    
    return instance;
}

+ (BOOL)isProtocolService{
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSLog(@"\n%@",proxies);
    
    NSDictionary *settings = proxies[0];
    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        NSLog(@"没代理");
        return NO;
    }
    else
    {
        NSLog(@"设置了代理");
        return YES;
    }
}

@end
