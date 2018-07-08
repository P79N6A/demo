
#import <Foundation/Foundation.h>

@interface JJHtml : NSObject

//+(void)kkBaseDataBlock: (void(^)(NSArray <NSDictionary *>*))block;
//+(NSArray *)kkBaseDataBlock: (void(^)(NSArray <NSDictionary *>*))block;
//+(void)kkBaseDataUrl:(NSString *)baseUrl Block: (void(^)(NSString *))block;


+ (void)search:(NSString *)kw
          page:(NSInteger)page
         block: (void(^)(NSArray <NSDictionary *>*,BOOL))block;
+ (void)getTVM3u8:(NSString *)urlStr block: (void(^)(NSArray *))block;
+ (void)getTVM3u8:(NSString *)urlStr title:(NSString *)title block: (void(^)(NSArray *))block;
+ (void)getTVDetail:(NSString *)urlStr block: (void(^)(NSDictionary *))block;
+ (void)getHKTVPage:(NSInteger)page
             urlStr:(NSString *)urlStr
              block: (void(^)(NSArray <NSDictionary *>*))block;
@end
