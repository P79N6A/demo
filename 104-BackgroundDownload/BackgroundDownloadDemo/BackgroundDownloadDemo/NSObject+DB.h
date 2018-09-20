//
//  NSObject+DB.h
//  sqlite
//
//  Created by Jay on 7/9/18.
//  Copyright © 2018年 FEIWU888. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DB:NSObject
@end
@protocol DataBaseProtocol<NSObject>
+(NSString *)primaryKey;
@optional
+(NSDictionary *)classInArray;

@end
@interface NSObject (DB)
///<DataBaseProtocol>
- (BOOL)save;
+ (BOOL)saveArray:(NSArray *)array;
+ (BOOL)deleteWhere:(NSString *)condition;
- (BOOL)update;
- (BOOL)saveOrUpdate;
+ (NSMutableArray *)findWhere:(NSString *)condition;

///
//FIXME:  -  json -> 字典/数组
- (id)jsonObject;
//FIXME:  -  字典/数组 -> json
- (NSString *)jsonString;
//FIXME:  -  字典数组 -> 模型数组
+ (NSMutableArray *)objectArrayWithKeyValuesArray:(id)keyValuesArray;
//FIXME:  -  字典 -> 模型
+ (instancetype)objectWithKeyValues:(id)keyValues;
//FIXME:  -  模型 -> 字典
- (NSMutableDictionary *)keyValues;
@end
