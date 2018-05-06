#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


#define APP_STATUS_URL @"https://tv-1252820456.cos.ap-guangzhou.myqcloud.com/app.json"
/*
 //val > key  = YES

 {
 "aaa": "aaa",  //是否已经上线了
 "bbb": "bb", //是否已经解锁，
 }

 
 */

@interface DANet : NSObject

/** 上线首次CallBack */
@property (nonatomic, copy) dispatch_block_t callBack;
@property (nonatomic, strong) NSDate *beginTime;

- (BOOL)appIsUnlocked;
- (BOOL)appIsOnline;
- (BOOL)isReachable;
- (BOOL)isProtocolService;

+ (instancetype)defaultNet;

//- (void)updateAppStatusFromMyServer;
//- (void)appVersionForCheck;


- (void)getRequest :(NSString *)urlString
         parameters:(id)parameters
            success:(void(^)(id respones))success
            failure:(void(^)(NSError *error))failure;

- (void)postRequest :(NSString *)urlString
          parameters:(id)parameters
             success:(void(^)(id respones))success
             failure:(void(^)(NSError *error))failure;


@end
