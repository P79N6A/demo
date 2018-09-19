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
+(NSDictionary *)classInArray;
@optional

@end
@interface NSObject (DB)
///<DataBaseProtocol>
- (BOOL)insert;
+ (BOOL)insertDatas:(NSArray <id>*)models;
+ (BOOL)deleteDataWhere:(NSString *)condition;
- (BOOL)upDate;
- (BOOL)insertOrUpDate;
+ (NSArray <id>*)searchDataWhere:(NSString *)condition;

@end
