//
//  HHHttpTool.m
//

#import "HLHttpTool.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "NSError+Message.h"

static id instance = nil;


@interface HLHttpTool ()
@property(nonatomic, strong)AFHTTPSessionManager *manger;
@end



@implementation HLHttpTool


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

- (AFHTTPSessionManager *)manger{
    if (_manger == nil) {
        _manger = [AFHTTPSessionManager manager];
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


/**
 *  get请求
 *
 *  @param urlString  请求url
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (void)getRequest :(NSString *)urlString parameters:(id)parameters success:(void(^)(id respones))success failure:(void(^)(NSError *error))failure{
    [self.manger GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject == nil || ![responseObject isKindOfClass:[NSDictionary class]]) {
            NSError *error = [NSError errorWithDomain:@"数据非法，请稍候再试" code:9999 userInfo:nil];
            !(failure)? : failure(error);
            return ;
        }
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //!(failure)? : failure([self getError:error]);
        !(failure)? : failure([error getError:error]);

    }];
}


/**
 *  post请求
 *
 *  @param urlString  请求url
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (void)postRequest :(NSString *)urlString parameters:(id)parameters success:(void(^)(id respones))success failure:(void(^)(NSError *error))failure{
    
    
    [self.manger POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        

        
        if (responseObject == nil || ![responseObject isKindOfClass:[NSDictionary class]]) {
            NSError *error = [NSError errorWithDomain:@"数据非法，请稍候再试" code:9999 userInfo:nil];
            !(failure)? : failure(error);
            return ;
        }
        
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
        
        //!(failure)? : failure([self getError:error]);
        !(failure)? : failure([error getError:error]);

    }];
}

/**
 *  上传请求
 *
 *  @param urlString     请求url
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */

- (void)upLoadRequest:(NSString *)urlString
           parameters:( id)parameters
        bodyWithBlock:( void (^)(id <AFMultipartFormData> formData))block
             progress:( void (^)(CGFloat uploadProgress)) progress
              success:( void (^)(id _Nullable responseObject))success
              failure:( void (^)(NSError *error))failure{
    
    [self.manger POST:urlString parameters:parameters constructingBodyWithBlock:block  progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount * 1.0 / uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject == nil || ![responseObject isKindOfClass:[NSDictionary class]]) {
            NSError *error = [NSError errorWithDomain:@"数据非法，请稍候再试" code:9999 userInfo:nil];
            !(failure)? : failure(error);
            return ;
        }
        
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
        //!(failure)? : failure([self getError:error]);
        !(failure)? : failure([error getError:error]);
        
    }];
    
}


+(void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    //2.发送Get请求
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //!(failure)? : failure([[self sharedInstance] getError:error]);
        !(failure)? : failure([error getError:error]);
    }];
}

+(NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    NSURLSessionDataTask *dataTask = [mgr POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //!(failure)? : failure([[self sharedInstance] getError:error]);
        !(failure)? : failure([error getError:error]);
    }];
    
    return dataTask;
}


//- (NSError *)getError:(NSError *)error
//{
//    switch (error.code) {
//        case NSURLErrorDownloadDecodingFailedMidStream:
//            return [NSError errorWithDomain:@"下载解码失败" code:NSURLErrorDownloadDecodingFailedMidStream userInfo:nil];
//            break;
//        case NSURLErrorBackgroundSessionWasDisconnected:
//            return [NSError errorWithDomain:@"后台会话已断开连接" code:NSURLErrorBackgroundSessionWasDisconnected userInfo:nil];
//            break;
//        case NSURLErrorBackgroundSessionInUseByAnotherProcess:
//            return [NSError errorWithDomain:@"后台会话被另一个进程使用" code:NSURLErrorBackgroundSessionInUseByAnotherProcess userInfo:nil];
//            break;
//            
//        case NSURLErrorBackgroundSessionRequiresSharedContainer:
//            return [NSError errorWithDomain:@"后台会话需要共享容器" code:NSURLErrorBackgroundSessionRequiresSharedContainer userInfo:nil];
//            break;
//        case NSURLErrorRequestBodyStreamExhausted:
//            return [NSError errorWithDomain:@"请求体耗尽" code:NSURLErrorRequestBodyStreamExhausted userInfo:nil];
//            break;
//            
//        case NSURLErrorDataNotAllowed:
//            return [NSError errorWithDomain:@"数据不允许" code:NSURLErrorDataNotAllowed userInfo:nil];
//            break;
//        case NSURLErrorCallIsActive:
//            return [NSError errorWithDomain:@"正在通话" code:NSURLErrorCallIsActive userInfo:nil];
//            break;
//            
//        case NSURLErrorInternationalRoamingOff:
//            return [NSError errorWithDomain:@"国际漫游关" code:NSURLErrorInternationalRoamingOff userInfo:nil];
//            break;
//        case NSURLErrorDownloadDecodingFailedToComplete:
//            return [NSError errorWithDomain:@"下载解码无法完成" code:NSURLErrorDownloadDecodingFailedToComplete userInfo:nil];
//            break;
//            ///
//        case NSURLErrorSecureConnectionFailed:
//            return [NSError errorWithDomain:@"安全连接失败" code:NSURLErrorSecureConnectionFailed userInfo:nil];
//            break;
//        case NSURLErrorServerCertificateHasBadDate:
//            return [NSError errorWithDomain:@"服务器证书失效" code:NSURLErrorServerCertificateHasBadDate userInfo:nil];
//            break;
//            
//        case NSURLErrorCannotCreateFile:
//            return [NSError errorWithDomain:@"不能创建文件" code:NSURLErrorCannotCreateFile userInfo:nil];
//            break;
//        case NSURLErrorCannotOpenFile:
//            return [NSError errorWithDomain:@"不能打开文件" code:NSURLErrorCannotOpenFile userInfo:nil];
//            break;
//            
//        case NSURLErrorCannotCloseFile:
//            return [NSError errorWithDomain:@"不能关闭文件" code:NSURLErrorCannotCloseFile userInfo:nil];
//            break;
//        case NSURLErrorCannotWriteToFile:
//            return [NSError errorWithDomain:@"不能写文件" code:NSURLErrorCannotWriteToFile userInfo:nil];
//            break;
//        case NSURLErrorCannotRemoveFile:
//            return [NSError errorWithDomain:@"不能删除文件" code:NSURLErrorCannotRemoveFile userInfo:nil];
//            break;
//        case NSURLErrorCannotMoveFile:
//            return [NSError errorWithDomain:@"不能移动文件" code:NSURLErrorCannotMoveFile userInfo:nil];
//            break;
//            ///
//        case NSURLErrorZeroByteResource:
//            return [NSError errorWithDomain:@"响应内容为空" code:NSURLErrorZeroByteResource userInfo:nil];
//            break;
//        case NSURLErrorCannotDecodeRawData:
//            return [NSError errorWithDomain:@"无法解码原始数据" code:NSURLErrorCannotDecodeRawData userInfo:nil];
//            break;
//        case NSURLErrorCannotLoadFromNetwork:
//            return [NSError errorWithDomain:@"无法从网络加载" code:NSURLErrorCannotLoadFromNetwork userInfo:nil];
//            break;
//        case NSURLErrorClientCertificateRequired:
//            return [NSError errorWithDomain:@"需要客户端证书" code:NSURLErrorClientCertificateRequired userInfo:nil];
//            break;
//        case NSURLErrorClientCertificateRejected:
//            return [NSError errorWithDomain:@"服务器证书拒接" code:NSURLErrorClientCertificateRejected userInfo:nil];
//            break;
//        case NSURLErrorServerCertificateNotYetValid:
//            return [NSError errorWithDomain:@"服务器证书尚未生效" code:NSURLErrorServerCertificateNotYetValid userInfo:nil];
//            break;
//        case NSURLErrorServerCertificateHasUnknownRoot:
//            return [NSError errorWithDomain:@"服务器证书具有未知根" code:NSURLErrorServerCertificateHasUnknownRoot userInfo:nil];
//            break;
//        case NSURLErrorServerCertificateUntrusted:
//            return [NSError errorWithDomain:@"服务器证书不受信任" code:NSURLErrorServerCertificateUntrusted userInfo:nil];
//            break;
//            ///
//        case NSURLErrorFileOutsideSafeArea:
//            return [NSError errorWithDomain:@"文件外部安全区域" code:NSURLErrorFileOutsideSafeArea userInfo:nil];
//            break;
//        case NSURLErrorDataLengthExceedsMaximum:
//            return [NSError errorWithDomain:@"数据长度超过最大值" code:NSURLErrorDataLengthExceedsMaximum userInfo:nil];
//            break;
//        case NSURLErrorNoPermissionsToReadFile:
//            return [NSError errorWithDomain:@"无权限读取文件" code:NSURLErrorNoPermissionsToReadFile userInfo:nil];
//            break;
//        case NSURLErrorFileIsDirectory:
//            return [NSError errorWithDomain:@"文件是目录" code:NSURLErrorFileIsDirectory userInfo:nil];
//            break;
//        case NSURLErrorFileDoesNotExist:
//            return [NSError errorWithDomain:@"文件不存在" code:NSURLErrorFileDoesNotExist userInfo:nil];
//            break;
//        case NSURLErrorAppTransportSecurityRequiresSecureConnection:
//            return [NSError errorWithDomain:@"应用程序传输安全性需要安全连接" code:NSURLErrorAppTransportSecurityRequiresSecureConnection userInfo:nil];
//            break;
//        case NSURLErrorCannotParseResponse:
//            return [NSError errorWithDomain:@"无法解析响应" code:NSURLErrorCannotParseResponse userInfo:nil];
//            break;
//        case NSURLErrorCannotDecodeContentData:
//            return [NSError errorWithDomain:@"无法解析数据" code:NSURLErrorCannotDecodeContentData userInfo:nil];
//            break;
//            ///
//        case NSURLErrorUnknown:
//            return [NSError errorWithDomain:@"未知错误" code:NSURLErrorUnknown userInfo:nil];
//            break;
//        case NSURLErrorCancelled:
//            return [NSError errorWithDomain:@"请求取消" code:NSURLErrorCancelled userInfo:nil];
//            break;
//        case NSURLErrorBadURL:
//            return [NSError errorWithDomain:@"错误的地址" code:NSURLErrorBadURL userInfo:nil];
//            break;
//        case NSURLErrorTimedOut:
//            return [NSError errorWithDomain:@"请求超时" code:NSURLErrorTimedOut userInfo:nil];
//            break;
//        case NSURLErrorUnsupportedURL:
//            return [NSError errorWithDomain:@"请求地址不支持" code:NSURLErrorUnsupportedURL userInfo:nil];
//            break;
//        case NSURLErrorCannotFindHost:
//            return [NSError errorWithDomain:@"找不到服务器" code:NSURLErrorCannotFindHost userInfo:nil];
//            break;
//        case NSURLErrorCannotConnectToHost:
//            return [NSError errorWithDomain:@"无法连接服务器" code:NSURLErrorCannotConnectToHost userInfo:nil];
//            break;
//        case NSURLErrorNetworkConnectionLost:
//            return [NSError errorWithDomain:@"网络连接失败" code:NSURLErrorNetworkConnectionLost userInfo:nil];
//            break;
//            
//            ///
//        case NSURLErrorDNSLookupFailed:
//            return [NSError errorWithDomain:@"DNS查找失败" code:NSURLErrorDNSLookupFailed userInfo:nil];
//            break;
//        case NSURLErrorHTTPTooManyRedirects:
//            return [NSError errorWithDomain:@"HTTP太多重定向" code:NSURLErrorHTTPTooManyRedirects userInfo:nil];
//            break;
//        case NSURLErrorResourceUnavailable:
//            return [NSError errorWithDomain:@"资源不可用" code:NSURLErrorResourceUnavailable userInfo:nil];
//            break;
//        case NSURLErrorNotConnectedToInternet:
//            return [NSError errorWithDomain:@"未连接到互联网" code:NSURLErrorNotConnectedToInternet userInfo:nil];
//            break;
//        case NSURLErrorRedirectToNonExistentLocation:
//            return [NSError errorWithDomain:@"重定向到不存在的位置" code:NSURLErrorRedirectToNonExistentLocation userInfo:nil];
//            break;
//        case NSURLErrorBadServerResponse:
//            return [NSError errorWithDomain:@"服务器出错" code:NSURLErrorBadServerResponse userInfo:nil];
//            break;
//        case NSURLErrorUserCancelledAuthentication:
//            return [NSError errorWithDomain:@"用户取消了验证" code:NSURLErrorUserCancelledAuthentication userInfo:nil];
//            break;
//        case NSURLErrorUserAuthenticationRequired:
//            return [NSError errorWithDomain:@"需要用户验证" code:NSURLErrorUserAuthenticationRequired userInfo:nil];
//            break;
//        default:
//            return [NSError errorWithDomain:@"未知错误" code:999 userInfo:nil];
//            //return error;
//            break;
//    }
//    
//}

@end
