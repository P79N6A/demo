
#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>

#define KBOOLLINE [[XYYHTTP sharedInstance] APPLINE]

@interface XYYHTTP : NSObject

@property (nonatomic, copy) void (^onLinebBlock)(void);

@property (nonatomic, strong) NSDate *beginTime;

+ (instancetype)sharedInstance;

- (BOOL)APPLINE;

- (void)appStatus;

- (void)getRequest :(NSString *)urlString

         parameters:(id)parameters

            success:(void(^)(id respones))success

            failure:(void(^)(NSError *error))failure;
@end
