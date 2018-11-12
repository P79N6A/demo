

#import <Foundation/Foundation.h>

@interface MeiJuApi : NSObject


+ (void)MeiJuSearch:(NSString *)kw
             pageNo:(NSInteger)page
          completed:(void(^)(NSArray <NSDictionary *>*objs,BOOL hasMore))block;

+ (void)MeiJuGetM3u8:(NSString *)urlStr
        completed:(void(^)(NSArray *objs))block;

+ (void)MeiJuListPageNo:(NSInteger)page
             completed:(void(^)(NSArray <NSDictionary *>*objs))block;

+ (void)MeiJuGetDetail:(NSString *)urlStr
             completed:(void(^)(NSDictionary *obj))block;
@end
