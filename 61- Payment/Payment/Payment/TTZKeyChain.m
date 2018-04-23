//
//  TTZKeyChain.m
//  Payment
//
//  Created by Jay on 2018/4/18.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "TTZKeyChain.h"

@implementation TTZKeyChain

#pragma mark ----public method

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)key {
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword,(id)kSecClass,
            key, (id)kSecAttrService,
            key, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
    
}

#pragma mark ----写入
// 说明: 该封装 添加与更新 为同一方法, 不进行判断, 直接先删除后添加
+(void)saveData:(id)data
         forKey:(NSString*)key{
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    SecItemDelete((CFDictionaryRef)keychainQuery);
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

#pragma mark ----读取
+(id)getDataForKey:(NSString*)key{
    
    id data = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            data = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", key, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return data;
}

#pragma mark ----删除
+(void)removeDataForkey:(NSString*)key{
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    SecItemDelete((CFDictionaryRef)keychainQuery);
}



@end
