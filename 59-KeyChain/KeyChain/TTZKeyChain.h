//
//  TTZKeyChain.h
//  KeyChain
//
//  Created by Jay on 2018/4/11.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTZKeyChain : NSObject

+ (BOOL)removeObjForKey:(NSString *)key
            withService:(NSString *)service;

+ (NSString *)objforKey:(NSString *)key
      withService:(NSString *)service;

+ (BOOL)setObj:(NSString *)obj
        forKey:(NSString *)key
   withService:(NSString *)service;
@end
