//
//  ZZYueYuTV.h
//  ZZCategory_Example
//
//  Created by Jay on 2018/2/26.
//  Copyright © 2018年 czljcb@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZYueYuTV : NSObject
+ (void)getHKTVPage:(NSInteger)page
              block: (void(^)(NSArray <NSDictionary *>*))block;
+ (void)getTVDetail:(NSString *)urlStr
              block: (void(^)(NSDictionary *))block;

+ (void)getTVM3u8:(NSString *)urlStr
            block: (void(^)(NSArray *))block;
+ (void)getTVM3u8:(NSString *)urlStr
            title:(NSString *)title
            block: (void(^)(NSArray *))block;
+ (void)search:(NSString *)kw
          page:(NSInteger)page
         block: (void(^)(NSArray <NSDictionary *>*,BOOL hasMore))block;
@end
