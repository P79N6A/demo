//
//  HHHttpTool.h
//网络请求工具类，负责整个项目中所有的Http网络请求

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@interface HLHttpTool : NSObject



+ (instancetype)sharedInstance;

- (void)getRequest :(NSString *)urlString
         parameters:(id)parameters
            success:(void(^)(id respones))success
            failure:(void(^)(NSError *error))failure;

- (void)postRequest :(NSString *)urlString
          parameters:(id)parameters
             success:(void(^)(id respones))success
             failure:(void(^)(NSError *error))failure;

- (void)upLoadRequest:(NSString *)urlString
           parameters:( id)parameters
        bodyWithBlock:( void (^)(id <AFMultipartFormData> formData))block
             progress:(void (^)(CGFloat uploadProgress)) progress
              success:(void(^)(id respones))success
              failure:(void(^)(NSError *error))failure;

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;
@end
