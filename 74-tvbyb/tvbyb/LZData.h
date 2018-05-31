//
//  LZData.h
//  LiZhiFM
//
//  Created by czljcb on 2018/4/16.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZData : NSObject
+ (NSDictionary *)homeDict;
+ (NSDictionary *)descDict;
+ (NSArray *)tvlists;

//+(void)kkBaseDataBlock: (void(^)(NSArray <NSDictionary *>*))block;
+(NSArray *)kkBaseDataBlock: (void(^)(NSArray <NSDictionary *>*))block;
+(void)kkBaseDataUrl:(NSString *)baseUrl Block: (void(^)(NSString *))block;


+ (void)search:(NSString *)kw
          page:(NSInteger)page
         block: (void(^)(NSArray <NSDictionary *>*,BOOL))block;
+ (void)getTVM3u8:(NSString *)urlStr block: (void(^)(NSArray *))block;
+ (void)getTVM3u8:(NSString *)urlStr title:(NSString *)title block: (void(^)(NSArray *))block;
+ (void)getTVDetail:(NSString *)urlStr block: (void(^)(NSDictionary *))block;
+ (void)getHKTVPage:(NSInteger)page
             urlStr:(NSString *)urlStr
              block: (void(^)(NSArray <NSDictionary *>*))block;


+ (void)getTVBYBPage:(NSInteger)page
            //urlStr:(NSString *)urlStr
               block: (void(^)(NSArray <NSDictionary *>*))block;

+ (void)getTVBYBDetail:(NSString *)urlStr
                 block: (void(^)(NSDictionary *))block;
+ (void)getTVBYBM3u8:(NSString *)urlStr
               block: (void(^)(NSArray *))block;
@end
