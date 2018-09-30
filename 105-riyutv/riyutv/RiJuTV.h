
#import <Foundation/Foundation.h>

@interface RiJuTV : NSObject

+ (void)tvlist;

+ (void)searchRiJu:(NSString *)kw
             pageNo:(NSInteger)page
          completed:(void(^)(NSArray <NSDictionary *>*objs,BOOL hasMore))block;

+ (void)riJuPlayList:(NSString *)urlStr
        completed:(void(^)(NSArray *objs))block;

+ (void)riJuHls:(NSString *)urlStr
       completed: (void(^)(NSString *obj))block;

+ (void)riJuList:(NSInteger)page
       completed:(void(^)(NSArray <NSDictionary *>*objs))block;

+ (void)riJuDetail:(NSString *)urlStr
             completed:(void(^)(NSDictionary *obj))block;


+ (void)getJianShuObj:(NSString *)urlStr
            completed: (void(^)(id obj))block;
@end
