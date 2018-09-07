//
//  DataBase.h
//  sqlite
//
//  Created by FEIWU888 on 2017/11/17.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBase : NSObject
+ (instancetype)sharedInstance;
//- (BOOL)openDB;
//- (BOOL)closeDB;
//- (BOOL)createTable:(Class)class;
- (void)insertData:(id)model;
- (void)insertDatas:(NSArray <id>*)models;
- (void)deleteWithModel:(Class)class where:(NSString *)condition;
- (NSArray <id>*)searchAllModel:(Class)class where:(NSString *)condition;

@end
