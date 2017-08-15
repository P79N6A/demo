#import "NetAPIClient.h"
#import "NSString+Hash.h"
#import "AFNetworkActivityIndicatorManager.h"

#define BASE_API @"http://ishare.bthost.top/api/"

@interface NetAPIClient ()
@property (nonatomic, assign) NSTimeInterval baseDate; // 服务器时间
@property(nonatomic, strong)  NSMutableDictionary *urlLists;
@end

@implementation NetAPIClient


+ (NetAPIClient *)sharedClient {
    static NetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_API]];
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    _urlLists = [NSMutableDictionary dictionary];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html",nil];
    //    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //    self.securityPolicy.allowInvalidCertificates = YES;
    [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.requestSerializer.timeoutInterval = 15.f ;
    [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return self;
}



+ (void)requestJsonDataWithParams:(NSDictionary*)param
                       MethodType:(NetworkMethod)NetworkMethod
                    ResponseBlock:(void (^)(id responseObject, NSError *error))block{
    
    NSMutableDictionary *params = [param mutableCopy];
    params[@"sign"] = [self sign];
//    params[@"debug"] = @(88);
    
    //发起请求
    switch (NetworkMethod) {
        case NetworkMethodGET:{
            [[self sharedClient] GET:@"" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self baseDateWithResponseObject:responseObject params:params response:block];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                block(nil, error);
                
            }];
            
            break;
        }
        case NetworkMethodPOST:{
            [[self sharedClient] POST:@"" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self baseDateWithResponseObject:responseObject params:params response:block];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                block(nil, error);
                
            }];
            break;
        }
        case NetworkMethodPUT:{
            [[self sharedClient] PUT:@"" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                block(responseObject, nil);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                block(nil, error);
                
            }];
            break;
            
        }
        case NetworkMethodDELETE:{
            [[self sharedClient] DELETE:@"" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                block(responseObject, nil);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                block(nil, error);
                
            }];
            break;
        }
        default:
            break;
    }
}


+ (void)baseDateWithResponseObject:(id )obj
                               params:(NSDictionary *)params
                             response:(void (^)(id, NSError *))block{
    if ([obj[@"code"] integerValue] == 200)
    {
        NSTimeInterval timestamp = [obj[@"data"][@"timestamp"] integerValue] - 10;
        
        NSTimeInterval phoneTime = [[NSDate date] timeIntervalSince1970];
        
        NetAPIClient *api = [self sharedClient];
        api.baseDate = timestamp - phoneTime;
        
        [self requestJsonDataWithParams:params MethodType:NetworkMethodPOST ResponseBlock:block];
        return;
    }
    block(obj,nil);
}

+ (NSString *)sign
{
    NetAPIClient *api = [self sharedClient];

    NSTimeInterval baseTime = api.baseDate? api.baseDate : 0;
    
    NSDate *date = [[NSDate date] initWithTimeIntervalSinceNow:baseTime];// 然后把差的时间加上,就是当前系统准确的时间

    NSString *string = [NetAPIClient sharedClient].requestSerializer.HTTPRequestHeaders[@"User-Agent"];
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    form.dateFormat = @"mm";
    NSInteger mTime = [[form stringFromDate:date] integerValue] * 60;
    form.dateFormat = @"ss";
    NSInteger time = [[form stringFromDate:date] integerValue] + mTime;
    
    NSString *token = [[NSString stringWithFormat:@"%@-%ld",string,(long)time/10] md5String];
    
    return token;
}


+ (void)saveCookieData{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        // Here I see the correct rails session cookie
        NSLog(@"\nSave cookie: \n====================\n%@", cookie);
    }
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: @"Code_CookieData"];
    [defaults synchronize];
}
+ (void)removeCookieData{
    NSURL *url = [NSURL URLWithString:BASE_API];
    if (url) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        for (int i = 0; i < [cookies count]; i++) {
            NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            NSLog(@"\nDelete cookie: \n====================\n%@", cookie);
        }
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"Code_CookieData"];
    [defaults synchronize];
}

@end
