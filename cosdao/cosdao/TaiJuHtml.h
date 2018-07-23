//
//  HJManger.h
//  HJManger
//
//  Created by xin on 2018/7/2.
//  Copyright © 2018年 sdl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaiJuHtml : NSObject


+ (void)taiJuSearch:(NSString *)kw
             pageNo:(NSInteger)page
          completed:(void(^)(NSArray <NSDictionary *>*objs,BOOL hasMore))block;

+ (void)taiJuM3u8:(NSString *)urlStr
        completed:(void(^)(NSArray *objs))block;

+ (void)getTaiJuPageNo:(NSInteger)page
             completed:(void(^)(NSArray <NSDictionary *>*objs))block;

+ (void)getTaiJuDetail:(NSString *)urlStr
             completed:(void(^)(NSDictionary *obj))block;
@end
