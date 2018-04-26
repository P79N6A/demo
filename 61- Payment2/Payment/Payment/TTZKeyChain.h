//
//  TTZKeyChain.h
//  Payment
//
//  Created by Jay on 2018/4/18.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTZKeyChain : NSObject

+(void)saveData:(id)data
         forKey:(NSString*)key;

+(id)getDataForKey:(NSString*)key;

+(void)removeDataForkey:(NSString*)key;

@end
