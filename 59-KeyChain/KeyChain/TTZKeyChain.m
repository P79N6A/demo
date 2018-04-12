//
//  TTZKeyChain.m
//  KeyChain
//
//  Created by Jay on 2018/4/11.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZKeyChain.h"

@implementation TTZKeyChain
/** 增/改 */
//- (IBAction)insertAndUpdate:(id)sender {
//
//    /**
//     说明：当添加的时候我们一般需要判断一下当前钥匙串里面是否已经存在我们要添加的钥匙。如果已经存在我们就更新好了，不存在再添加，所以这两个操作一般写成一个函数搞定吧。
//
//     过程关键：1.检查是否已经存在 构建的查询用的操作字典：kSecAttrService，kSecAttrAccount，kSecClass（标明存储的数据是什么类型，值为kSecClassGenericPassword 就代表一般的密码）
//
//     　　　2.添加用的操作字典：　kSecAttrService，kSecAttrAccount，kSecClass，kSecValueData
//
//     　　　3.更新用的操作字典1（用于定位需要更改的钥匙）：kSecAttrService，kSecAttrAccount，kSecClass
//
//     　　　　　　　　操作字典2（新信息）kSecAttrService，kSecAttrAccount，kSecClass ,kSecValueData
//     */
//
//    NSLog(@"插入 : %d",  [self addItemWithService:@"com.tencent" account:@"李雷" password:@"911"]);
//}

+ (BOOL)setObj:(NSString *)obj
        forKey:(NSString *)key
   withService:(NSString *)service{
    
    //先查查是否已经存在
    //构造一个操作字典用于查询
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    
    [queryDic setObject:service forKey:(__bridge id)kSecAttrService];                         //标签service
    [queryDic setObject:key forKey:(__bridge id)kSecAttrAccount];                         //标签account
    [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];//表明存储的是一个密码
    
    OSStatus status = -1;
    CFTypeRef result = NULL;
    
    status = SecItemCopyMatching((__bridge CFDictionaryRef)queryDic, &result);
    
    if (status == errSecItemNotFound) {                                              //没有找到则添加
        
        NSData *passwordData = [obj dataUsingEncoding:NSUTF8StringEncoding];    //把password 转换为 NSData
        
        [queryDic setObject:passwordData forKey:(__bridge id)kSecValueData];       //添加密码
        
        status = SecItemAdd((__bridge CFDictionaryRef)queryDic, NULL);             //!!!!!关键的添加API
        
    }else if (status == errSecSuccess){                                              //成功找到，说明钥匙已经存在则进行更新
        
        NSData *passwordData = [obj dataUsingEncoding:NSUTF8StringEncoding];    //把password 转换为 NSData
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:queryDic];
        
        [dict setObject:passwordData forKey:(__bridge id)kSecValueData];             //添加密码
        
        status = SecItemUpdate((__bridge CFDictionaryRef)queryDic, (__bridge CFDictionaryRef)dict);//!!!!关键的更新API
        
    }
    
    return (status == errSecSuccess);
}


/** 查 */
//- (IBAction)select:(id)sender {
//
//    /**
//     过程：
//     1.(关键)先配置一个操作字典内容有:
//     kSecAttrService(属性),kSecAttrAccount(属性) 这些属性or标签是查找的依据
//     kSecReturnData(值为@YES 表明返回类型为data),kSecClass(值为kSecClassGenericPassword 表示重要数据为“一般密码”类型) 这些限制条件是返回结果类型的依据
//
//     2.然后用查找的API 得到查找状态和返回数据（密码）
//
//     3.最后如果状态成功那么将数据（密码）转换成string 返回
//     */
//
//    NSLog(@"%@", [self passwordForService:@"com.tencent" account:@"李雷"]);
//
//}

//用原生的API 实现查询密码
+ (NSString *)objforKey:(NSString *)key
      withService:(NSString *)service{
    
    //生成一个查询用的 可变字典
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    
    //首先添加获取密码所需的搜索键和类属性：
    [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass]; //表明为一般密码可能是证书或者其他东西
    [queryDic setObject:(__bridge id)kCFBooleanTrue  forKey:(__bridge id)kSecReturnData];     //返回Data
    
    [queryDic setObject:service forKey:(__bridge id)kSecAttrService];    //输入service
    [queryDic setObject:key forKey:(__bridge id)kSecAttrAccount];  //输入account
    
    //查询
    OSStatus status = -1;
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)queryDic,&result);//核心API 查找是否匹配 和返回密码！
    if (status != errSecSuccess) { //判断状态
        
        return nil;
    }
    //返回数据
    //    NSString *password = [[NSString alloc] initWithData:(__bridge_transfer NSData *)result encoding:NSUTF8StringEncoding];//转换成string
    
    //删除kSecReturnData键; 我们不需要它了：
    [queryDic removeObjectForKey:(__bridge id)kSecReturnData];
    //将密码转换为NSString并将其添加到返回字典：
    NSString *password = [[NSString alloc] initWithBytes:[(__bridge_transfer NSData *)result bytes] length:[(__bridge NSData *)result length] encoding:NSUTF8StringEncoding];
    
    [queryDic setObject:password forKey:(__bridge id)kSecValueData];
    
    NSLog(@"查询 : %@", queryDic);
    
    
    return password;
}


/** 删 */
//- (IBAction)delete:(id)sender {
//
//    NSLog(@"删除 : %d", [self deleteItemWithService:@"com.tencent" account:@"李雷"]);
//}


+ (BOOL)removeObjForKey:(NSString *)key
            withService:(NSString *)service{
//+ (BOOL)deleteItemWithService:(NSString *)service
//                      account:(NSString *)account{
    
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    
    [queryDic setObject:service forKey:(__bridge id)kSecAttrService];                         //标签service
    [queryDic setObject:key forKey:(__bridge id)kSecAttrAccount];                         //标签account
    [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];//表明存储的是一个密码
    
    
    OSStatus status = SecItemDelete((CFDictionaryRef)queryDic);
    
    return (status == errSecSuccess);
}


@end
