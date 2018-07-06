//
//  HJManger.h
//  HJManger
//
//  Created by xin on 2018/7/2.
//  Copyright © 2018年 sdl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJManger : NSObject


+ (void)search:(NSString *)kw
          page:(NSInteger)page
         block: (void(^)(NSArray <NSDictionary *>*,BOOL))block;

+ (void)getTVM3u8:(NSString *)urlStr title:(NSString *)title block: (void(^)(NSArray *))block;


+ (void)getTaiJuTVPage:(NSInteger)page
                 block: (void(^)(NSArray <NSDictionary *>*))block;
+ (void)getTaiYuTVDetail:(NSString *)urlStr
           completeBlock: (void(^)(NSDictionary *))block;
@end
