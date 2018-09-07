//
//  NSObject+DB.m
//  sqlite
//
//  Created by Jay on 7/9/18.
//  Copyright © 2018年 FEIWU888. All rights reserved.
//

#import "NSObject+DB.h"
#import <sqlite3.h>
#import <objc/runtime.h>// 导入运行时文件

/**
 开始事务.
 */

#define Begin_Transcation \
if(![DB sharedInstance].inTransaction){\
[DB sharedInstance].inTransaction = [[DB sharedInstance] execSql:@"begin transaction"];\
}

/**
 提交事务.
 */
#define Commit_Transcation \
if([DB sharedInstance].inTransaction){\
[[DB sharedInstance] execSql:@"commit transaction"];\
[DB sharedInstance].inTransaction = NO;\
}
/**
 回滚事务.
 */
#define Rollback_Transcation \
if([DB sharedInstance].inTransaction){\
[[DB sharedInstance] execSql:@"rollback transaction"];\
[DB sharedInstance].inTransaction=NO;\
}


static DB * instance = nil;
static sqlite3 *db = nil;


@interface DB()
@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic, assign) BOOL inTransaction;//事务标志

@end


@implementation DB
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
        instance.dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"data.db"];
    });
    return instance;
}

- (BOOL)openDB{
    
    int result = sqlite3_open(self.dbPath.UTF8String, &db);
    
    if (result == SQLITE_OK) {
        //NSLog(@"打开成功");
        return YES;
    } else {
        NSLog(@"打开失败");
        return NO;
    }
}

- (BOOL)closeDB{
    // 打开数据库的函数
    // 在数据库里面 所有的字符串都要变成utf－8的编码格式
    int result = sqlite3_close(db);
    if (result == SQLITE_OK) {
        //NSLog(@"关闭成功");
        return YES;
    } else {
        NSLog(@"关闭失败");
        return NO;
    }
}

- (BOOL)execSql:(NSString *)sql {
    char *errmsg = nil;
    BOOL result = sqlite3_exec(db, [sql UTF8String], nil, nil, &errmsg) == SQLITE_OK;
    if (!result) {
        if (errmsg) {
            NSString* sqlError = [NSString stringWithFormat:@"SQL语句执行错误: %s", errmsg];
            NSLog(@"%s--%@", __func__,sqlError);
            sqlite3_free(errmsg);
        }
    }
    return result;
}

- (BOOL)createTable:(Class)class{
    
    NSString *tableName = NSStringFromClass(class);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    id primaryKey = [self isRespondsToSelector:@selector(primaryKey) forClass:class];
#pragma clang diagnostic pop
    NSArray <NSDictionary *> *infos = [self getProperties:class contains:YES];
    
    NSMutableArray *info = [NSMutableArray array];
    [infos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([primaryKey isEqualToString:obj.allKeys.firstObject]) {
            [info addObject:[NSString stringWithFormat:@"%@ INTEGER primary key autoincrement not null",obj.allKeys.firstObject]];
        }else
        {
            [info addObject:[NSString stringWithFormat:@"%@ %@",obj.allKeys.firstObject,obj.allValues.firstObject]];
        }
    }];
    
    
    NSMutableString *createString = [NSMutableString stringWithFormat:@"create table if not exists %@ (",tableName];
    
    [createString appendString:[info componentsJoinedByString:@","]];
    
    
    
    [createString appendString:@")"];
    // 创建一个person表， 要求字段：UID integer 主键，自增 name text， gender text， age integer
    // 创建表的sql语句
    // NSString *createString = @"create table if not exists dog (uid integer primary key autoincrement not null, name text, gender text, age integer)";
    
    // 第一个参数：数据库
    // 第二个参数：sql语句，要用utf－8的格式
    // 第三个参数：结果的回调函数
    // 第四个参数：回调函数的参数
    // 第五个参数：错误信息
    BOOL result = [self execSql:createString];//sqlite3_exec(db, createString.UTF8String, NULL, NULL, NULL);
    // 打印数据库的地址
    NSLog(@"_dbPath ==== %@", _dbPath);
    // 判断是否创建成功
    if (result) {
        //NSLog(@"创建表成功");
        return YES;
    } else {
        NSLog(@"创建表失败 %d", result);
        return NO;
    }
    
    
}

- (void)insertDatas:(NSArray <id>*)models{
    
    [self openDB];
    [self createTable:[models.firstObject class]];
    
    NSString *tableName = NSStringFromClass([models.firstObject class]);
    
    
    NSArray <NSDictionary *> *infos = [self getProperties:[models.firstObject class] contains:NO];
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [infos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        info[obj.allKeys.firstObject] = obj.allValues.firstObject;
    }];
    
    NSMutableString *insertString = [NSMutableString stringWithFormat:@"insert into %@ (",tableName];
    
    [insertString appendFormat:@"%@ )",[info.allKeys componentsJoinedByString:@","]];
    [insertString appendString:@" values (?"];
    for (NSInteger i = 0; i < info.allKeys.count - 1; i ++) {
        [insertString appendString:@", ?"];
    }
    [insertString appendString:@")"];
    
    Begin_Transcation
    [models enumerateObjectsUsingBlock:^(id  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        // 插入数据的sql语句，数据不确定，所以在values里面使用？代替，之后向里面绑定
        //NSString *insertString = @"insert into person (name, gender, age) values (?, ?, ?)";
        // sqlite的伴随指针
        sqlite3_stmt *stmt = nil;
        
        // 预执行sql语句
        // 第一个参数：数据库
        // 第二个参数：sql语句
        // 第三个参数：如果为正，例如 ： 1， 表示在取参数的时候，只取一个字节;使用负数表示取值取到碰到结束符号（'\000','u000'）。
        // 第四个参数：伴随指针，会伴随着数据库的操作，获取值或绑定值
        // 第五个参数：取值的时候如果取的不全，那么剩下的都存在这里。
        int result = sqlite3_prepare(db, insertString.UTF8String, -1, &stmt, NULL);
        // 如果预执行成功的话，那么就要往里面放数据了
        if (result == SQLITE_OK) {
            // 向预执行的sql语句里面插入参数 (取代‘？’的位置)
            // 第一个参数：伴随指针
            // 第二个参数：‘？’的位置，从1开始
            // 第三个参数：插入的数据
            // 第四个参数：和上面的－1是一样的
            // 第五个参数：回调函数
            
            
            for (int i = 0; i < info.allKeys.count; i ++) {
                
                NSString *key = info.allKeys[i];
                NSString *type = info.allValues[i];
                if ([type isEqualToString:@"INTEGER"]) {
                    sqlite3_bind_int64(stmt, i+1, [[model valueForKey:key] integerValue]);
                }else if ([type isEqualToString:@"float"]) {
                    sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] floatValue]);
                }if ([type isEqualToString:@"double"]) {
                    sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] doubleValue]);
                }if ([type isEqualToString:@"TEXT"]) {
                    sqlite3_bind_text(stmt, i+1, ((NSString *)[model valueForKey:key]).UTF8String, -1, NULL);
                }
            }
            
            // sql语句已经全了
            // 执行伴随指针，如果为SQLITE_DONE 代表执行成功，并且成功的插入数据。
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                //NSLog(@"插入成功");
            } else {
                NSLog(@"插入失败");
            }
        } else {
            NSLog(@"插入失败%d", result);
        }
        
        // 一定要记得释放掉伴随指针
        sqlite3_finalize(stmt);
    }];
    
    Commit_Transcation
    
    
    [self closeDB];
}

- (void)insertData:(id)model{
    
    [self openDB];
    [self createTable:[model class]];
    
    NSString *tableName = NSStringFromClass([model class]);
    
    
    NSArray <NSDictionary *> *infos = [self getProperties:[model class] contains:NO];
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [infos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        info[obj.allKeys.firstObject] = obj.allValues.firstObject;
    }];
    
    NSMutableString *insertString = [NSMutableString stringWithFormat:@"insert into %@ (",tableName];
    
    [insertString appendFormat:@"%@ )",[info.allKeys componentsJoinedByString:@","]];
    [insertString appendString:@" values (?"];
    for (NSInteger i = 0; i < info.allKeys.count - 1; i ++) {
        [insertString appendString:@", ?"];
    }
    [insertString appendString:@")"];
    
    // 插入数据的sql语句，数据不确定，所以在values里面使用？代替，之后向里面绑定
    //NSString *insertString = @"insert into person (name, gender, age) values (?, ?, ?)";
    // sqlite的伴随指针
    sqlite3_stmt *stmt = nil;
    
    // 预执行sql语句
    // 第一个参数：数据库
    // 第二个参数：sql语句
    // 第三个参数：如果为正，例如 ： 1， 表示在取参数的时候，只取一个字节;使用负数表示取值取到碰到结束符号（'\000','u000'）。
    // 第四个参数：伴随指针，会伴随着数据库的操作，获取值或绑定值
    // 第五个参数：取值的时候如果取的不全，那么剩下的都存在这里。
    int result = sqlite3_prepare(db, insertString.UTF8String, -1, &stmt, NULL);
    // 如果预执行成功的话，那么就要往里面放数据了
    if (result == SQLITE_OK) {
        // 向预执行的sql语句里面插入参数 (取代‘？’的位置)
        // 第一个参数：伴随指针
        // 第二个参数：‘？’的位置，从1开始
        // 第三个参数：插入的数据
        // 第四个参数：和上面的－1是一样的
        // 第五个参数：回调函数
        
        
        for (int i = 0; i < info.allKeys.count; i ++) {
            
            NSString *key = info.allKeys[i];
            NSString *type = info.allValues[i];
            if ([type isEqualToString:@"INTEGER"]) {
                sqlite3_bind_int64(stmt, i+1, [[model valueForKey:key] integerValue]);
            }else if ([type isEqualToString:@"float"]) {
                sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] floatValue]);
            }if ([type isEqualToString:@"double"]) {
                sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] doubleValue]);
            }if ([type isEqualToString:@"TEXT"]) {
                sqlite3_bind_text(stmt, i+1, ((NSString *)[model valueForKey:key]).UTF8String, -1, NULL);
            }
        }
        
        // sql语句已经全了
        // 执行伴随指针，如果为SQLITE_DONE 代表执行成功，并且成功的插入数据。
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            //NSLog(@"插入成功");
        } else {
            NSLog(@"插入失败");
        }
    } else {
        NSLog(@"插入失败%d", result);
    }
    
    // 一定要记得释放掉伴随指针
    sqlite3_finalize(stmt);
    
    [self closeDB];
}
//UPDATE table_name
//SET column1 = value1, column2 = value2...., columnN = valueN
//WHERE [condition];
- (void)updateWithModel:(id)model where:(NSString *)condition{
    
    NSString *tableName = NSStringFromClass([model class]);
    NSArray <NSDictionary *> *infos = [self getProperties:[model class] contains:NO];
    
    NSMutableString *updateString = [NSMutableString stringWithFormat:@"update %@ set ",tableName];
    [infos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [updateString appendFormat:@"%@ = '%@',",obj.allKeys.firstObject,[model valueForKey:obj.allKeys.firstObject]];
    }];
    
    
    NSString * updateSQL = [NSString stringWithFormat:@"%@ %@",[updateString substringToIndex:updateString.length-1],condition];
    
    // 伴随指针
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare(db, updateSQL.UTF8String, -1, &stmt, NULL);
    
    if (result == SQLITE_OK) {
        
        for (int i = 0; i < infos.count; i ++) {
            
            NSString *key = infos[i].allKeys.firstObject;
            NSString *type = infos[i].allValues.firstObject;
            if ([type isEqualToString:@"INTEGER"]) {
                sqlite3_bind_int64(stmt, i+1, [[model valueForKey:key] integerValue]);
            }else if ([type isEqualToString:@"float"]) {
                sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] floatValue]);
            }if ([type isEqualToString:@"double"]) {
                sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] doubleValue]);
            }if ([type isEqualToString:@"TEXT"]) {
                sqlite3_bind_text(stmt, i+1, ((NSString *)[model valueForKey:key]).UTF8String, -1, NULL);
            }
        }
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            //NSLog(@"修改成功");
        }
    }else{
        NSLog(@"更新失败%d", result);
        
    }
    
    sqlite3_finalize(stmt);
}



- (void)deleteWithModel:(Class)class where:(NSString *)condition{
    
    NSString *tableName = NSStringFromClass(class);
    
    NSString *deleteString = [NSString stringWithFormat:@"delete from %@ %@", tableName,condition];
    
    BOOL result = [self execSql:deleteString];//sqlite3_exec(db, deleteString.UTF8String, NULL, NULL, NULL);
    
    if (result) {
        //NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

- (NSArray <id>*)searchAllModel:(Class)class where:(NSString *)condition {
    
    [self openDB];
    NSString *tableName = NSStringFromClass(class);
    
    NSString *searchString = [NSString stringWithFormat:@"select * from %@ %@", tableName,condition];
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare(db, searchString.UTF8String, -1, &stmt, NULL);
    NSMutableArray *models = [NSMutableArray array];
    
    if (result == SQLITE_OK) {
        
        NSArray <NSDictionary *> *infos = [self getProperties:class contains:YES];
        
        
        // 当sqlite3_step(stmt) == SQLITE_ROW 的时候，代表还有下一条数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            id model = [class new];
            for (int i = 0 ; i < infos.count; i++) {
                NSString *type = infos[i].allValues.firstObject;
                NSString *key = infos[i].allKeys.firstObject;
                
                if ([type isEqualToString:@"INTEGER"]) {
                    
                    int uid = sqlite3_column_int(stmt, i);
                    [model setValue:@(uid) forKey:key];
                    
                }else if ([type isEqualToString:@"float"]) {
                    
                    float uid = sqlite3_column_double(stmt, i);
                    [model setValue:@(uid) forKey:key];
                    
                }if ([type isEqualToString:@"double"]) {
                    
                    double uid = sqlite3_column_double(stmt, i);
                    [model setValue:@(uid) forKey:key];
                    
                }if ([type isEqualToString:@"TEXT"]) {
                    NSString *name = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, i)];
                    [model setValue:name forKey:key];
                    
                }
                
            }
            [models addObject:model];
        }
        NSLog(@"%s--%@", __func__,models);
    }
    
    sqlite3_finalize(stmt);
    [self closeDB];
    return models;
}

-(id)isRespondsToSelector:(SEL)selector forClass:(Class)cla{
    id obj = nil;
    if([cla respondsToSelector:selector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        obj = [cla performSelector:selector];
#pragma clang diagnostic pop
    }else{
        //抛出异常
        NSException *exc = [NSException exceptionWithName:@"请在保存的模型中实现 +(NSString *)primaryKey" reason:@"请在保存的模型中实现 +(NSString *)primaryKey" userInfo:nil];
        //抛出异常
        [exc raise];
    }
    return obj;
}

-(NSArray <NSDictionary *>*)getProperties:(Class)cls contains:(BOOL)isc{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    NSString * primaryKey = [self isRespondsToSelector:@selector(primaryKey) forClass:cls];
#pragma clang diagnostic pop
    unsigned int outCount = 0;
    
    NSMutableArray *array = [NSMutableArray array];
    
    Ivar * ivars = class_copyIvarList([cls class], &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        const char * cName = ivar_getName(ivar);
        const char * cType = ivar_getTypeEncoding(ivar);
        NSString *name = [[NSString stringWithCString:cName encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"_" withString:@""];
        NSString *type = [NSString stringWithCString:cType encoding:NSUTF8StringEncoding];
        //NSLog(@"类型为 %@ 的 %@ ",type, name);
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        if([name isEqualToString:primaryKey] && !isc) continue;
        
        if ([type isEqualToString:@"B"]) {
            dict[name] = @"INTEGER";
            
        }else if ([type isEqualToString:@"@\"NSString\""]) {
            dict[name] = @"TEXT";
            
            
        }else if ([type isEqualToString:@"q"]) {
            dict[name] = @"INTEGER";
            
            
        }else if ([type isEqualToString:@"d"]) {
            dict[name] = @"double";
            
        }else if ([type isEqualToString:@"i"]) {
            dict[name] = @"INTEGER";
            
        }else if ([type isEqualToString:@"f"]) {
            dict[name] = @"float";
            
        }else if ([type isEqualToString:@"Q"]) {
            dict[name] = @"INTEGER";
            
        }else
        {
            continue;
        }
        [array addObject:dict];
        
    }
    free(ivars);
    
    
    return array;
}


@end


@implementation NSObject (DB)

- (BOOL)insert{
    
    BOOL isOk = NO;
    
    [[DB sharedInstance] openDB];
    [[DB sharedInstance] createTable:[self class]];
    
    NSString *tableName = NSStringFromClass([self class]);
    
    
    NSArray <NSDictionary *> *infos = [[DB sharedInstance] getProperties:[self class] contains:NO];
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [infos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        info[obj.allKeys.firstObject] = obj.allValues.firstObject;
    }];
    
    NSMutableString *insertString = [NSMutableString stringWithFormat:@"insert into %@ (",tableName];
    
    [insertString appendFormat:@"%@ )",[info.allKeys componentsJoinedByString:@","]];
    [insertString appendString:@" values (?"];
    for (NSInteger i = 0; i < info.allKeys.count - 1; i ++) {
        [insertString appendString:@", ?"];
    }
    [insertString appendString:@")"];
    
    // 插入数据的sql语句，数据不确定，所以在values里面使用？代替，之后向里面绑定
    //NSString *insertString = @"insert into person (name, gender, age) values (?, ?, ?)";
    // sqlite的伴随指针
    sqlite3_stmt *stmt = nil;
    
    // 预执行sql语句
    // 第一个参数：数据库
    // 第二个参数：sql语句
    // 第三个参数：如果为正，例如 ： 1， 表示在取参数的时候，只取一个字节;使用负数表示取值取到碰到结束符号（'\000','u000'）。
    // 第四个参数：伴随指针，会伴随着数据库的操作，获取值或绑定值
    // 第五个参数：取值的时候如果取的不全，那么剩下的都存在这里。
    int result = sqlite3_prepare(db, insertString.UTF8String, -1, &stmt, NULL);
    // 如果预执行成功的话，那么就要往里面放数据了
    if (result == SQLITE_OK) {
        // 向预执行的sql语句里面插入参数 (取代‘？’的位置)
        // 第一个参数：伴随指针
        // 第二个参数：‘？’的位置，从1开始
        // 第三个参数：插入的数据
        // 第四个参数：和上面的－1是一样的
        // 第五个参数：回调函数
        
        
        for (int i = 0; i < info.allKeys.count; i ++) {
            
            NSString *key = info.allKeys[i];
            NSString *type = info.allValues[i];
            if ([type isEqualToString:@"INTEGER"]) {
                sqlite3_bind_int64(stmt, i+1, [[self valueForKey:key] integerValue]);
            }else if ([type isEqualToString:@"float"]) {
                sqlite3_bind_double(stmt, i+1, [[self valueForKey:key] floatValue]);
            }if ([type isEqualToString:@"double"]) {
                sqlite3_bind_double(stmt, i+1, [[self valueForKey:key] doubleValue]);
            }if ([type isEqualToString:@"TEXT"]) {
                sqlite3_bind_text(stmt, i+1, ((NSString *)[self valueForKey:key]).UTF8String, -1, NULL);
            }
        }
        
        // sql语句已经全了
        // 执行伴随指针，如果为SQLITE_DONE 代表执行成功，并且成功的插入数据。
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            //NSLog(@"插入成功");
            isOk = YES;
        } else {
            NSLog(@"插入失败");
            isOk = NO;
        }
    } else {
        NSLog(@"插入失败%d", result);
        isOk = NO;
    }
    
    // 一定要记得释放掉伴随指针
    sqlite3_finalize(stmt);
    
    [[DB sharedInstance] closeDB];
    return isOk;
}


+ (BOOL)insertDatas:(NSArray <id>*)models{
    
    __block BOOL isOK = NO;
    
    [[DB sharedInstance] openDB];
    [[DB sharedInstance] createTable:[models.firstObject class]];
    
    NSString *tableName = NSStringFromClass([models.firstObject class]);
    
    
    NSArray <NSDictionary *> *infos = [[DB sharedInstance] getProperties:[models.firstObject class] contains:NO];
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [infos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        info[obj.allKeys.firstObject] = obj.allValues.firstObject;
    }];
    
    NSMutableString *insertString = [NSMutableString stringWithFormat:@"insert into %@ (",tableName];
    
    [insertString appendFormat:@"%@ )",[info.allKeys componentsJoinedByString:@","]];
    [insertString appendString:@" values (?"];
    for (NSInteger i = 0; i < info.allKeys.count - 1; i ++) {
        [insertString appendString:@", ?"];
    }
    [insertString appendString:@")"];
    
    Begin_Transcation
    [models enumerateObjectsUsingBlock:^(id  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        // 插入数据的sql语句，数据不确定，所以在values里面使用？代替，之后向里面绑定
        //NSString *insertString = @"insert into person (name, gender, age) values (?, ?, ?)";
        // sqlite的伴随指针
        sqlite3_stmt *stmt = nil;
        
        // 预执行sql语句
        // 第一个参数：数据库
        // 第二个参数：sql语句
        // 第三个参数：如果为正，例如 ： 1， 表示在取参数的时候，只取一个字节;使用负数表示取值取到碰到结束符号（'\000','u000'）。
        // 第四个参数：伴随指针，会伴随着数据库的操作，获取值或绑定值
        // 第五个参数：取值的时候如果取的不全，那么剩下的都存在这里。
        int result = sqlite3_prepare(db, insertString.UTF8String, -1, &stmt, NULL);
        // 如果预执行成功的话，那么就要往里面放数据了
        if (result == SQLITE_OK) {
            // 向预执行的sql语句里面插入参数 (取代‘？’的位置)
            // 第一个参数：伴随指针
            // 第二个参数：‘？’的位置，从1开始
            // 第三个参数：插入的数据
            // 第四个参数：和上面的－1是一样的
            // 第五个参数：回调函数
            
            
            for (int i = 0; i < info.allKeys.count; i ++) {
                
                NSString *key = info.allKeys[i];
                NSString *type = info.allValues[i];
                if ([type isEqualToString:@"INTEGER"]) {
                    sqlite3_bind_int64(stmt, i+1, [[model valueForKey:key] integerValue]);
                }else if ([type isEqualToString:@"float"]) {
                    sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] floatValue]);
                }if ([type isEqualToString:@"double"]) {
                    sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] doubleValue]);
                }if ([type isEqualToString:@"TEXT"]) {
                    sqlite3_bind_text(stmt, i+1, ((NSString *)[model valueForKey:key]).UTF8String, -1, NULL);
                }
            }
            
            // sql语句已经全了
            // 执行伴随指针，如果为SQLITE_DONE 代表执行成功，并且成功的插入数据。
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                //NSLog(@"插入成功");
                isOK = YES;
            } else {
                NSLog(@"插入失败");
                isOK = NO;
            }
        } else {
            NSLog(@"插入失败%d", result);
              isOK = NO;
        }
        
        // 一定要记得释放掉伴随指针
        sqlite3_finalize(stmt);
    }];
    
    Commit_Transcation
    
    
    [[DB sharedInstance] closeDB];
    
    return isOK;
}


+ (NSArray <id>*)searchDataWhere:(NSString *)condition{
    
    [[DB sharedInstance] openDB];
    NSString *tableName = NSStringFromClass(self);
    
    NSString *searchString = [NSString stringWithFormat:@"select * from %@ %@", tableName,condition];
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare(db, searchString.UTF8String, -1, &stmt, NULL);
    NSMutableArray *models = [NSMutableArray array];
    
    if (result == SQLITE_OK) {
        
        NSArray <NSDictionary *> *infos = [[DB sharedInstance] getProperties:self contains:YES];
        
        
        // 当sqlite3_step(stmt) == SQLITE_ROW 的时候，代表还有下一条数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            id model = [self new];
            for (int i = 0 ; i < infos.count; i++) {
                NSString *type = infos[i].allValues.firstObject;
                NSString *key = infos[i].allKeys.firstObject;
                
                if ([type isEqualToString:@"INTEGER"]) {
                    
                    int uid = sqlite3_column_int(stmt, i);
                    [model setValue:@(uid) forKey:key];
                    
                }else if ([type isEqualToString:@"float"]) {
                    
                    float uid = sqlite3_column_double(stmt, i);
                    [model setValue:@(uid) forKey:key];
                    
                }if ([type isEqualToString:@"double"]) {
                    
                    double uid = sqlite3_column_double(stmt, i);
                    [model setValue:@(uid) forKey:key];
                    
                }if ([type isEqualToString:@"TEXT"]) {
                    NSString *name = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, i)];
                    [model setValue:name forKey:key];
                    
                }
                
            }
            [models addObject:model];
        }
        NSLog(@"%s--%@", __func__,models);
    }
    
    sqlite3_finalize(stmt);
    [[DB sharedInstance] closeDB];
    return models;
}


+ (BOOL)deleteDataWhere:(NSString *)condition{
    [[DB sharedInstance] openDB];
    NSString *tableName = NSStringFromClass(self);
    
    NSString *deleteString = [NSString stringWithFormat:@"delete from %@ %@", tableName,condition];
    
    BOOL result = [[DB sharedInstance] execSql:deleteString];//sqlite3_exec(db, deleteString.UTF8String, NULL, NULL, NULL);
    
    if (result) {
        //NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
    [[DB sharedInstance] closeDB];
    return result;
}


//UPDATE table_name
//SET column1 = value1, column2 = value2...., columnN = valueN
//WHERE [condition];
- (BOOL)update{
    BOOL isOK = NO;
        [[DB sharedInstance] openDB];
    NSString *tableName = NSStringFromClass([self class]);
    NSArray <NSDictionary *> *infos = [[DB sharedInstance] getProperties:[self class] contains:NO];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    id primaryKeyType = [[DB sharedInstance] isRespondsToSelector:@selector(primaryKey) forClass:[self class]];
#pragma clang diagnostic pop
    
    id primaryKeyValue = [self valueForKey:primaryKeyType];
    
    NSMutableString *updateString = [NSMutableString stringWithFormat:@"update %@ set ",tableName];
    [infos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [updateString appendFormat:@"%@ = '%@',",obj.allKeys.firstObject,[self valueForKey:obj.allKeys.firstObject]];
    }];
    
    
    NSString * updateSQL = [NSString stringWithFormat:@"%@ where %@ = %@",[updateString substringToIndex:updateString.length-1],primaryKeyType,primaryKeyValue];
    
    // 伴随指针
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare(db, updateSQL.UTF8String, -1, &stmt, NULL);
    
    if (result == SQLITE_OK) {
        
        for (int i = 0; i < infos.count; i ++) {
            
            NSString *key = infos[i].allKeys.firstObject;
            NSString *type = infos[i].allValues.firstObject;
            if ([type isEqualToString:@"INTEGER"]) {
                sqlite3_bind_int64(stmt, i+1, [[self valueForKey:key] integerValue]);
            }else if ([type isEqualToString:@"float"]) {
                sqlite3_bind_double(stmt, i+1, [[self valueForKey:key] floatValue]);
            }if ([type isEqualToString:@"double"]) {
                sqlite3_bind_double(stmt, i+1, [[self valueForKey:key] doubleValue]);
            }if ([type isEqualToString:@"TEXT"]) {
                sqlite3_bind_text(stmt, i+1, ((NSString *)[self valueForKey:key]).UTF8String, -1, NULL);
            }
        }
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            //NSLog(@"修改成功");
            isOK = YES;
        }
    }else{
        NSLog(@"更新失败%d", result);
        isOK = NO;
    }
    
    sqlite3_finalize(stmt);
        [[DB sharedInstance] closeDB];
    return isOK;
}



@end
