
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#define isOnLine [[LZHTTP sharedInstance] appLine]

@interface LZHTTP : NSObject

@property (nonatomic, copy) void (^onLinebBlock)(void);

@property (nonatomic, strong) NSDate *beginTime;

+ (instancetype)sharedInstance;

//- (BOOL)appLine;

//- (void)appStatus;

- (void)getRequest:(NSString *)urlString
        parameters:(id)parameters
           success:(void(^)(id respones))success
            failure:(void(^)(NSError *error))failure;

+ (BOOL)isProtocolService;
@end
