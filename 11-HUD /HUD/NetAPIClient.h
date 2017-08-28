
#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef NS_ENUM(NSInteger, NetworkMethod) {
    NetworkMethodGET,
    NetworkMethodPOST,
    NetworkMethodPUT,
    NetworkMethodDELETE
};

@interface NetAPIClient : AFHTTPSessionManager


+ (instancetype)sharedClient;

+ (void)requestJsonDataWithParams:(NSDictionary*)params
                       MethodType:(NetworkMethod)NetworkMethod
                    ResponseBlock:(void (^)(id responseObject, NSError *error))block;

@end
