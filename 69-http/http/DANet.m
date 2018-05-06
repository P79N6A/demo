
#import "DANet.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

static id instance = nil;


@interface DANet ()

@property(nonatomic, strong)AFHTTPSessionManager *manger;
@property (nonatomic, copy) NSString *userAgent;
@property (nonatomic, strong) NSArray *citys; //有值证明网络已经回来
@property (nonatomic, assign) BOOL appStatus; // 有值证明网络已经回来

@end



@implementation DANet


+ (instancetype)defaultNet{
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

- (AFHTTPSessionManager *)manger{
    if (_manger == nil) {
        _manger = [AFHTTPSessionManager manager];
        [_manger.requestSerializer setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
        [_manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manger.requestSerializer.timeoutInterval = 15.f;
        [_manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        _manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/x-javascript",nil];
        NSSet *set = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"image/png", nil];
        _manger.responseSerializer.acceptableContentTypes =[_manger.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:set];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [AFNetworkActivityIndicatorManager sharedManager].activationDelay = 0;
    }
    return _manger;
}
//FIXME:  -  网络监听
+ (void)load{
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"----------------------------------------------------------------------------------------");
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"网络不通：%@",@(status) );
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"网络通过WIFI连接：%@",@(status));
                
                if(![[DANet defaultNet] appIsOnline]) [[DANet defaultNet] updateAppStatusFromMyServer];//[[DANet defaultNet] appVersionForCheck];
                else [[DANet defaultNet]  appVersionForCheck];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"网络通过无线连接：%@",@(status) );
                if(![[DANet defaultNet] appIsOnline]) [[DANet defaultNet] updateAppStatusFromMyServer];//[[DANet defaultNet] appVersionForCheck];
                break;
            }
            default:
                break;
        }
        

        NSLog(@"网络状态数字返回：%@",@(status));
        NSLog(@"网络状态返回: %@", AFStringFromNetworkReachabilityStatus(status));
        
        NSLog(@"isReachable: %@",@([AFNetworkReachabilityManager sharedManager].isReachable));
        NSLog(@"isReachableViaWWAN: %@",@([AFNetworkReachabilityManager sharedManager].isReachableViaWWAN));
        NSLog(@"isReachableViaWiFi: %@",@([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi));
        NSLog(@"是否上线：%d   是否已经评分了：%d",[DANet defaultNet].appIsOnline,[DANet defaultNet].appIsUnlocked);
        NSLog(@"----------------------------------------------------------------------------------------");

        
    }];
    
    [reachabilityManager startMonitoring];  //开启网络监视器；
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationBecomeActive)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
}

//FIXME:  -  是否已经跳去评分了
+ (void)applicationBecomeActive{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:
                               [DANet defaultNet].beginTime?[DANet defaultNet].beginTime:[NSDate date]];
    if (interval >= 8.0) {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"isunlocked"];
    }
}

//FIXME:  -  HTTP (GET/POST) 请求
- (void)getRequest :(NSString *)urlString
         parameters:(id)parameters
            success:(void(^)(id respones))success
            failure:(void(^)(NSError *error))failure{
    
    if (![self appIsOnline]) {
        //[self appVersionForCheck];
        [self updateAppStatusFromMyServer];
    }
    
    if(self.isProtocolService) {
        !(failure)? : failure([NSError errorWithDomain:@"服务器受到攻击，请稍候再试" code:9999 userInfo:nil]);
        return;
    }

    [self.manger GET:urlString
          parameters:parameters
            progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@", error);
                !(failure)? : failure(error);
            }];
}

- (void)postRequest:(NSString *)urlString
         parameters:(id)parameters
            success:(void(^)(id respones))success
            failure:(void(^)(NSError *error))failure{

    if (![self appIsOnline]) {
        //[self appVersionForCheck];
        [self updateAppStatusFromMyServer];
    }
    
    if(self.isProtocolService) {
        !(failure)? : failure([NSError errorWithDomain:@"服务器受到攻击，请稍候再试" code:9999 userInfo:nil]);
        return;
    }

    [self.manger POST:urlString
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  if (success) {
                      success(responseObject);
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"%@", error);
                  !(failure)? : failure(error);
              }];
}





//FIXME:  -  更新App上线状态
- (void)updateAppStatusFromMyServer{
    
    if(self.appIsOnline) return;
    
    if(self.isProtocolService) return;

    //1）获取设置的语言
    
    //NSString *nsLang  = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    
    //传说中获取语言设置最准确的方法：
    
    NSString *nsLang = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]  objectAtIndex:0];
    
    //2）获取设置的国家
    
    NSString *nsCount  = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    
    //if(![nsCount isEqualToString:@"CN"] || ![nsLang isEqualToString:@"zh-Hans-CN"]){
    if(![nsCount containsString:@"CN"] || ![nsLang containsString:@"CN"]){
        // 不是 中国 简体中文 都是审核模式

        return;
    }
    
    [self getCity];
    
    NSString *url = [NSString stringWithFormat:@"%@?r=%d&t=%f&d=%f",APP_STATUS_URL,rand(),[[NSDate date] timeIntervalSince1970],[[NSDate date] timeIntervalSince1970]*[[NSDate date] timeIntervalSince1970]];
    
    [self.manger GET:url
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable obj) {
                 
                 if(![obj isKindOfClass:[NSDictionary class]]) return ;
                 
                 BOOL online = [[obj valueForKey:@"aaa"] length] > 3;//是否已经上线
                 BOOL isunlocked = [[obj valueForKey:@"bbb"] length] > 3; // 是否已经解锁
                 
                 if(!online) return;
                 
                 self.appStatus = YES;// 接口已经上线
                 [[NSUserDefaults standardUserDefaults] setObject:@(isunlocked) forKey:@"isunlocked"];

                 if(self.appIsOnline) return;
                 
                 if(!self.isReachable) return;
                 
                 if(!self.citys.count) return;
                 
                 
                 NSString *country = self.citys[0];
                 //NSString *region = self.citys[1];
                 NSString *city = self.citys[2];
                 
                 if (![country isEqualToString:@"中国"]) {
                     return;
                 }
                 
                 if ([city isEqualToString:@"北京"] || [city isEqualToString:@"上海"]) {
                     return;
                 }
                 

                 [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"onlinKey"];
                 !(_callBack)? : _callBack();
                 _callBack = nil;
                 
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 if (([error.localizedDescription containsString:@"404"] ||
                      [error.localizedDescription containsString:@"not found"])) {
                     
                     self.appStatus = YES;
                     [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"isunlocked"];

                     if([self appIsOnline]) return;
                     
                     if(!self.isReachable) return;
                     
                     if(!self.citys.count) return;
                     
                     
                     NSString *country = self.citys[0];
                     //NSString *region = self.citys[1];
                     NSString *city = self.citys[2];
                     
                     if (![country isEqualToString:@"中国"]) {
                         return;
                     }
                     
                     if ([city isEqualToString:@"北京"] || [city isEqualToString:@"上海"]) {
                         return;
                     }
                     
                     [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"onlinKey"];
                     !(_callBack)? : _callBack();
                     _callBack = nil;
                 }
                 
             }];
    
    
}
//FIXME:  -  获取定位
- (void)getCity{
    //http://ip.taobao.com/service/getIpInfo2.php?ip=myip
    
    
    NSURL *url = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo2.php?ip=myip"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    // 由于要先对request先行处理,我们通过request初始化task
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            
                                            if (error) {
                                                return ;
                                            }
                                            
                                            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                                            
                                            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                            
                                            NSString *country = obj[@"data"][@"country"];
                                            NSString *region = obj[@"data"][@"region"];
                                            NSString *city = obj[@"data"][@"city"];
                                            self.citys = @[country,region,city];
                                            
                                            if (![country isEqualToString:@"中国"]) {
                                                return;
                                            }
                                            
                                            if ([city isEqualToString:@"北京"] || [city isEqualToString:@"上海"]) {
                                                return;
                                            }
                                            
                                            if(self.appStatus){
                                                [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"onlinKey"];
                                                !(_callBack)? : _callBack();
                                                _callBack = nil;
                                            }
                                        }];
    [task resume];
    
}


//FIXME:  -  是否已经上线了
- (BOOL)appIsOnline
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"onlinKey"];
}
//FIXME:  -  是否有网络
- (BOOL)isReachable{
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

//FIXME:  -  是否已经解锁了,解锁了就不需要评论
- (BOOL)appIsUnlocked
{
    if (!self.appIsOnline) {
        return YES;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isunlocked"];
}


//FIXME:  -  Apple 的数据接口
- (void)appVersionForCheck{
    
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    
    NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?bundleId=%@&rand=%d&t=%f",[[NSBundle mainBundle] bundleIdentifier],rand(),time];
    
    [self.manger GET:url
          parameters:nil progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 //具体实现为
                 NSArray *results = [responseObject objectForKey:@"results"];
                 if (results.count < 1) {
                     return;
                 }
                 
                 NSDictionary *result = [results firstObject];
                 NSString *versionStr = [result objectForKey:@"version"];
                 NSString *trackViewUrl = [result objectForKey:@"trackViewUrl"];
                 NSString *releaseNotes = [result objectForKey:@"releaseNotes"];//更新日志
                 //NSString *artistId = [result objectForKey:@"artistId"];
                 
                 //NSString* buile = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString*) kCFBundleVersionKey];//build号
                 NSString* thisVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                 
                 if ([self upDateAppFormAppStore:versionStr WithAppVersion:thisVersion]) {
                     
                     UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"发现新版本:%@",versionStr] message:releaseNotes preferredStyle:UIAlertControllerStyleAlert];
                     //UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                     //    NSLog(@"点击了取消");
                     //}];
                     
                     UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                         NSLog(@"点击了知道了");
                         NSURL * url = [NSURL URLWithString:trackViewUrl];//itunesURL = trackViewUrl的内容
                         [[UIApplication sharedApplication] openURL:url];
                         
                     }];
                     //[alertVC addAction:cancelAction];
                     [alertVC addAction:OKAction];
                     [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
                 }
                 
                 
//                 if([self appIsOnline]) return;
//                 if([self onlineAppFormAppStore:versionStr WithAppVersion:thisVersion]){
//                     
//                     [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"onlinKey"];
//                     !(_callBack)? : _callBack();
//                     _callBack = nil;
//                 }
                 
             } failure:nil];
}

//FIXME:  - 上线判断
//比较版本的方法，在这里我用的是Version来比较的
- (BOOL)onlineAppFormAppStore:(NSString*)AppStoreVersion
               WithAppVersion:(NSString*)AppVersion{
    NSMutableString *online = (NSMutableString *)[AppStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSMutableString *new = (NSMutableString *)[AppVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    while (online.length < new.length) { [online appendString:@"0"]; }
    while (new.length < online.length) { [new appendString:@"0"]; }
    return [online integerValue] >= [new integerValue]; // >= 表示 上线
    //return [online integerValue] > [new integerValue]; // > 表示 app 需要更新
}
//FIXME:  - 更新判断
- (BOOL)upDateAppFormAppStore:(NSString*)AppStoreVersion
               WithAppVersion:(NSString*)AppVersion{
    NSMutableString *online = (NSMutableString *)[AppStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSMutableString *new = (NSMutableString *)[AppVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    while (online.length < new.length) { [online appendString:@"0"]; }
    while (new.length < online.length) { [new appendString:@"0"]; }
    return [online integerValue] > [new integerValue]; // > 表示 app 需要更新
}

//FIXME:  -  防代理服务器
- (BOOL)isProtocolService{
    
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



- (NSString *)userAgent{
    
    if (!_userAgent) {
        NSArray *userAgents = @[
          @"Mozilla/5.0 (Linux; Android 4.4.4; HTC D820u Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.89 Mobile Safari/537.36",
          @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-cn; HTC_D820u Build/KTU84P) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30",
          @"Mozilla/5.0 (Linux; Android 4.4.4; HTC D820u Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari/537.36 ACHEETAHI/2100501044",
          @"Mozilla/5.0 (Linux; Android 4.4.4; HTC D820u Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari/537.36 bdbrowser_i18n/4.6.0.7",
          @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-CN; HTC D820u Build/KTU84P) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 UCBrowser/10.1.0.527 U3/0.8.0 Mobile Safari/534.30",
          @"Mozilla/5.0 (Android; Mobile; rv:35.0) Gecko/35.0 Firefox/35.0",
          @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-cn; HTC D820u Build/KTU84P) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30 SogouMSE,SogouMobileBrowser/3.5.1",
          @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-CN; HTC D820u Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Oupeng/10.2.3.88150 Mobile Safari/537.36",
          @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-cn; HTC D820u Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko)Version/4.0 MQQBrowser/5.6 Mobile Safari/537.36",
          @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-cn; HTC D820u Build/KTU84P) AppleWebKit/534.24 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.24 T5/2.0 baidubrowser/5.3.4.0 (Baidu; P1 4.4.4)",
          @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-cn; HTC D820u Build/KTU84P) AppleWebKit/535.19 (KHTML, like Gecko) Version/4.0 LieBaoFast/2.28.1 Mobile Safari/535.19",
          @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12A365 Safari/600.1.4",
          @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X; zh-CN) AppleWebKit/537.51.1 (KHTML, like Gecko) Mobile/12A365 UCBrowser/10.2.5.551 Mobile",
          @"Mozilla/5.0 (iPhone 5SGLOBAL; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/6.0 MQQBrowser/5.6 Mobile/12A365 Safari/8536.25",
          @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/7.0 Mobile/12A365 Safari/9537.53",
          @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4.9 (KHTML, like Gecko) Version/6.0 Mobile/10A523 Safari/8536.25",
          @"Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_4 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Mercury/8.9.4 Mobile/11B554a Safari/9537.53",
          @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12A365 SogouMobileBrowser/3.5.1",
          @"Mozilla/5.0 (iPhone; CPU iPhone OS 7_1 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D167 Safari/9537.53",
          @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Coast/4.01.88243 Mobile/12A365 Safari/7534.48.3",
          @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) CriOS/40.0.2214.69 Mobile/12A365 Safari/600.1.4",
          @"Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_2 like Mac OS X) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.0 Mobile/14F89 Safari/602.1",
          @"Mozilla/5.0 (iPhone; CPU iPhone OS 11_1_1 like Mac OS X) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.0 Mobile/15F89 Safari/602.1",
          ];
        
        NSInteger index = arc4random() % userAgents.count;
        _userAgent = userAgents[index];

    }
    return _userAgent;
}



@end
