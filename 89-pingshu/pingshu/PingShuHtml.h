

#import <Foundation/Foundation.h>

@interface PingShuHtml : NSObject


+ (void)test;

+ (void)searchPingShuKeyWord:(NSString *)kw
                     completed: (void(^)(NSArray <NSDictionary *>*objs))block;

+ (void)pingShuMp3:(NSString *)urlStr
        completed:(void(^)(NSString *obj))block;


+ (void)getLongPingShuPageNo:(NSInteger)page
               classId:(NSString *)class
             completed:(void(^)(NSArray <NSDictionary *>*objs))block;

+ (void)getPingShuPageNo:(NSInteger)page
             completed:(void(^)(NSArray <NSDictionary *>*objs))block;


+ (void)getMingRenTangCompleted: (void(^)(NSArray <NSDictionary *>*objs))block;
+ (void)getPingShuURL:(NSString *)str
              completed: (void(^)(NSArray <NSDictionary *>*objs))block;


+ (void)getPingShuDetail:(NSString *)urlStr
             completed:(void(^)(NSDictionary *obj))block;
@end
