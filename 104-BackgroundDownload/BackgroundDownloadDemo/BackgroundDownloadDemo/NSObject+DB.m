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
//        NSLog(@"关闭成功");
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
    NSArray <NSDictionary *> *infos = [self getProperties:class contains:YES isSqlType:YES];
    
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

+ (NSArray *)columnNames:(Class)class{
    NSString *tableName = NSStringFromClass(class);
    NSString* SQL = [NSString stringWithFormat:@"select * from %@ limit 0,1;",tableName];
    NSMutableArray* tempArrayM = [NSMutableArray array];
    sqlite3_stmt * pp_stmt = nil;
    if (sqlite3_prepare_v2(db, [SQL UTF8String], -1, &pp_stmt, nil) == SQLITE_OK) {
        int columnCount = sqlite3_column_count(pp_stmt);
        int columnIdx = 0;
        for (columnIdx = 0; columnIdx < columnCount; columnIdx++){
            [tempArrayM addObject:[NSString stringWithUTF8String:sqlite3_column_name(pp_stmt, columnIdx)]];
        }
        if (sqlite3_step(pp_stmt) != SQLITE_DONE) {
            sqlite3_finalize(pp_stmt);
        }
    }
    return tempArrayM.count?tempArrayM:nil;
}
//
//- (void)insertDatas:(NSArray <id>*)models{
//
//    [self openDB];
//    [self createTable:[models.firstObject class]];
//
//    NSString *tableName = NSStringFromClass([models.firstObject class]);
//
//
//    NSArray <NSDictionary *> *infos = [self getProperties:[models.firstObject class] contains:NO];
//
//    NSMutableDictionary *info = [NSMutableDictionary dictionary];
//    [infos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        info[obj.allKeys.firstObject] = obj.allValues.firstObject;
//    }];
//
//    NSMutableString *insertString = [NSMutableString stringWithFormat:@"insert into %@ (",tableName];
//
//    [insertString appendFormat:@"%@ )",[info.allKeys componentsJoinedByString:@","]];
//    [insertString appendString:@" values (?"];
//    for (NSInteger i = 0; i < info.allKeys.count - 1; i ++) {
//        [insertString appendString:@", ?"];
//    }
//    [insertString appendString:@")"];
//
//    Begin_Transcation
//    [models enumerateObjectsUsingBlock:^(id  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
//
//
//        // 插入数据的sql语句，数据不确定，所以在values里面使用？代替，之后向里面绑定
//        //NSString *insertString = @"insert into person (name, gender, age) values (?, ?, ?)";
//        // sqlite的伴随指针
//        sqlite3_stmt *stmt = nil;
//
//        // 预执行sql语句
//        // 第一个参数：数据库
//        // 第二个参数：sql语句
//        // 第三个参数：如果为正，例如 ： 1， 表示在取参数的时候，只取一个字节;使用负数表示取值取到碰到结束符号（'\000','u000'）。
//        // 第四个参数：伴随指针，会伴随着数据库的操作，获取值或绑定值
//        // 第五个参数：取值的时候如果取的不全，那么剩下的都存在这里。
//        int result = sqlite3_prepare(db, insertString.UTF8String, -1, &stmt, NULL);
//        // 如果预执行成功的话，那么就要往里面放数据了
//        if (result == SQLITE_OK) {
//            // 向预执行的sql语句里面插入参数 (取代‘？’的位置)
//            // 第一个参数：伴随指针
//            // 第二个参数：‘？’的位置，从1开始
//            // 第三个参数：插入的数据
//            // 第四个参数：和上面的－1是一样的
//            // 第五个参数：回调函数
//
//
//            for (int i = 0; i < info.allKeys.count; i ++) {
//
//                NSString *key = info.allKeys[i];
//                NSString *type = info.allValues[i];
//                if ([type isEqualToString:@"INTEGER"]) {
//                    sqlite3_bind_int64(stmt, i+1, [[model valueForKey:key] integerValue]);
//                }else if ([type isEqualToString:@"float"]) {
//                    sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] floatValue]);
//                }if ([type isEqualToString:@"double"]) {
//                    sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] doubleValue]);
//                }if ([type isEqualToString:@"TEXT"]) {
//                    sqlite3_bind_text(stmt, i+1, ((NSString *)[model valueForKey:key]).UTF8String, -1, NULL);
//                }
//            }
//
//            // sql语句已经全了
//            // 执行伴随指针，如果为SQLITE_DONE 代表执行成功，并且成功的插入数据。
//            if (sqlite3_step(stmt) == SQLITE_DONE) {
//                //NSLog(@"插入成功");
//            } else {
//                NSLog(@"插入失败");
//            }
//        } else {
//            NSLog(@"插入失败%d", result);
//        }
//
//        // 一定要记得释放掉伴随指针
//        sqlite3_finalize(stmt);
//    }];
//
//    Commit_Transcation
//
//
//    [self closeDB];
//}
//
//- (void)insertData:(id)model{
//
//    [self openDB];
//    [self createTable:[model class]];
//
//    NSString *tableName = NSStringFromClass([model class]);
//
//
//    NSArray <NSDictionary *> *infos = [self getProperties:[model class] contains:NO];
//
//    NSMutableDictionary *info = [NSMutableDictionary dictionary];
//    [infos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        info[obj.allKeys.firstObject] = obj.allValues.firstObject;
//    }];
//
//    NSMutableString *insertString = [NSMutableString stringWithFormat:@"insert into %@ (",tableName];
//
//    [insertString appendFormat:@"%@ )",[info.allKeys componentsJoinedByString:@","]];
//    [insertString appendString:@" values (?"];
//    for (NSInteger i = 0; i < info.allKeys.count - 1; i ++) {
//        [insertString appendString:@", ?"];
//    }
//    [insertString appendString:@")"];
//
//    // 插入数据的sql语句，数据不确定，所以在values里面使用？代替，之后向里面绑定
//    //NSString *insertString = @"insert into person (name, gender, age) values (?, ?, ?)";
//    // sqlite的伴随指针
//    sqlite3_stmt *stmt = nil;
//
//    // 预执行sql语句
//    // 第一个参数：数据库
//    // 第二个参数：sql语句
//    // 第三个参数：如果为正，例如 ： 1， 表示在取参数的时候，只取一个字节;使用负数表示取值取到碰到结束符号（'\000','u000'）。
//    // 第四个参数：伴随指针，会伴随着数据库的操作，获取值或绑定值
//    // 第五个参数：取值的时候如果取的不全，那么剩下的都存在这里。
//    int result = sqlite3_prepare(db, insertString.UTF8String, -1, &stmt, NULL);
//    // 如果预执行成功的话，那么就要往里面放数据了
//    if (result == SQLITE_OK) {
//        // 向预执行的sql语句里面插入参数 (取代‘？’的位置)
//        // 第一个参数：伴随指针
//        // 第二个参数：‘？’的位置，从1开始
//        // 第三个参数：插入的数据
//        // 第四个参数：和上面的－1是一样的
//        // 第五个参数：回调函数
//
//
//        for (int i = 0; i < info.allKeys.count; i ++) {
//
//            NSString *key = info.allKeys[i];
//            NSString *type = info.allValues[i];
//            if ([type isEqualToString:@"INTEGER"]) {
//                sqlite3_bind_int64(stmt, i+1, [[model valueForKey:key] integerValue]);
//            }else if ([type isEqualToString:@"float"]) {
//                sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] floatValue]);
//            }if ([type isEqualToString:@"double"]) {
//                sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] doubleValue]);
//            }if ([type isEqualToString:@"TEXT"]) {
//
//                id value = [model valueForKey:key];
//                if (![value isKindOfClass:[NSString class]]) {
//                    NSDictionary *obj = [self getObjectData:model];
//                    value = [obj valueForKey:key];
//                    value = [self objectToJson:value];
//                }
//                sqlite3_bind_text(stmt, i+1, ((NSString *)value).UTF8String, -1, NULL);
//            }
//        }
//
//        // sql语句已经全了
//        // 执行伴随指针，如果为SQLITE_DONE 代表执行成功，并且成功的插入数据。
//        if (sqlite3_step(stmt) == SQLITE_DONE) {
//            //NSLog(@"插入成功");
//        } else {
//            NSLog(@"插入失败");
//        }
//    } else {
//        NSLog(@"插入失败%d", result);
//    }
//
//    // 一定要记得释放掉伴随指针
//    sqlite3_finalize(stmt);
//
//    [self closeDB];
//}
////UPDATE table_name
////SET column1 = value1, column2 = value2...., columnN = valueN
////WHERE [condition];
//- (void)updateWithModel:(id)model where:(NSString *)condition{
//
//    NSString *tableName = NSStringFromClass([model class]);
//    NSArray <NSDictionary *> *infos = [self getProperties:[model class] contains:NO];
//
//    NSMutableString *updateString = [NSMutableString stringWithFormat:@"update %@ set ",tableName];
//    [infos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [updateString appendFormat:@"%@ = '%@',",obj.allKeys.firstObject,[model valueForKey:obj.allKeys.firstObject]];
//    }];
//
//
//    NSString * updateSQL = [NSString stringWithFormat:@"%@ %@",[updateString substringToIndex:updateString.length-1],condition];
//
//    // 伴随指针
//    sqlite3_stmt *stmt = nil;
//
//    int result = sqlite3_prepare(db, updateSQL.UTF8String, -1, &stmt, NULL);
//
//    if (result == SQLITE_OK) {
//
//        for (int i = 0; i < infos.count; i ++) {
//
//            NSString *key = infos[i].allKeys.firstObject;
//            NSString *type = infos[i].allValues.firstObject;
//            if ([type isEqualToString:@"INTEGER"]) {
//                sqlite3_bind_int64(stmt, i+1, [[model valueForKey:key] integerValue]);
//            }else if ([type isEqualToString:@"float"]) {
//                sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] floatValue]);
//            }if ([type isEqualToString:@"double"]) {
//                sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] doubleValue]);
//            }if ([type isEqualToString:@"TEXT"]) {
//                sqlite3_bind_text(stmt, i+1, ((NSString *)[model valueForKey:key]).UTF8String, -1, NULL);
//            }
//        }
//        if (sqlite3_step(stmt) == SQLITE_DONE) {
//            //NSLog(@"修改成功");
//        }
//    }else{
//        NSLog(@"更新失败%d", result);
//
//    }
//
//    sqlite3_finalize(stmt);
//}


//
//- (void)deleteWithModel:(Class)class where:(NSString *)condition{
//
//    NSString *tableName = NSStringFromClass(class);
//
//    NSString *deleteString = [NSString stringWithFormat:@"delete from %@ %@", tableName,condition];
//
//    BOOL result = [self execSql:deleteString];//sqlite3_exec(db, deleteString.UTF8String, NULL, NULL, NULL);
//
//    if (result) {
//        //NSLog(@"删除成功");
//    } else {
//        NSLog(@"删除失败");
//    }
//}
//
//- (NSArray <id>*)searchAllModel:(Class)class where:(NSString *)condition {
//
//    [self openDB];
//    NSString *tableName = NSStringFromClass(class);
//
//    NSString *searchString = [NSString stringWithFormat:@"select * from %@ %@", tableName,condition];
//
//    sqlite3_stmt *stmt = nil;
//
//    int result = sqlite3_prepare(db, searchString.UTF8String, -1, &stmt, NULL);
//    NSMutableArray *models = [NSMutableArray array];
//
//    if (result == SQLITE_OK) {
//
//        NSArray <NSDictionary *> *infos = [self getProperties:class contains:YES];
//
//
//        // 当sqlite3_step(stmt) == SQLITE_ROW 的时候，代表还有下一条数据
//        while (sqlite3_step(stmt) == SQLITE_ROW) {
//
//            id model = [class new];
//            for (int i = 0 ; i < infos.count; i++) {
//                NSString *type = infos[i].allValues.firstObject;
//                NSString *key = infos[i].allKeys.firstObject;
//
//                if ([type isEqualToString:@"INTEGER"]) {
//
//                    int uid = sqlite3_column_int(stmt, i);
//                    [model setValue:@(uid) forKey:key];
//
//                }else if ([type isEqualToString:@"float"]) {
//
//                    float uid = sqlite3_column_double(stmt, i);
//                    [model setValue:@(uid) forKey:key];
//
//                }if ([type isEqualToString:@"double"]) {
//
//                    double uid = sqlite3_column_double(stmt, i);
//                    [model setValue:@(uid) forKey:key];
//
//                }if ([type isEqualToString:@"TEXT"]) {
//                    NSString *name = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, i)];
//                    [model setValue:name forKey:key];
//
//                }
//
//            }
//            [models addObject:model];
//        }
//        NSLog(@"%s--%@", __func__,models);
//    }
//
//    sqlite3_finalize(stmt);
//    [self closeDB];
//    return models;
//}

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

-(NSArray <NSDictionary *>*)getProperties:(Class)cls contains:(BOOL)isc isSqlType:(BOOL)isS{
    
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
            
        }else if ([type isEqualToString:@"@\"NSDictionary\""]) {
            dict[name] = isS? @"TEXT":@"NSDictionary";
            
        }else if ([type isEqualToString:@"@\"NSArray\""]) {
            dict[name] = isS? @"TEXT":@"NSArray";

        }else if ([type isEqualToString:@"@\"NSMutableDictionary\""]) {
            dict[name] = isS? @"TEXT":@"NSMutableDictionary";

        }else if ([type isEqualToString:@"@\"NSMutableArray\""]) {
            dict[name] = isS?  @"TEXT":@"NSMutableArray";

        }else  if ([type containsString:@"@\""]) {
            dict[name] = isS? @"TEXT": type;
            
        }else
        {
            continue;
        }
        [array addObject:dict];
        
    }
    free(ivars);
    
    
    return array;
}

+(BOOL)dropTable:(Class)cla{
    [[DB sharedInstance] openDB];
    NSString* tableName = NSStringFromClass(cla);
    NSString* SQL = [NSString stringWithFormat:@"DROP TABLE %@;",tableName];
    BOOL result = [[DB sharedInstance] execSql:SQL];
    [[DB sharedInstance] closeDB];
   return result;
}

+(void)refresh:(Class)cla{
        //将就数据全部查询出来
        NSArray* objects = [cla findWhere:@""];
        [self dropTable:cla];//删除旧的数据库

        if (objects.count) {
            [cla saveArray:objects];
        }
}
/**
 判断类属性是否有改变,智能刷新.
 */
+(void)ifIvarChangeForClass:(Class)cla{
    NSMutableArray* newKeys = [NSMutableArray array];
    NSMutableArray* sqlKeys = [NSMutableArray array];
    NSArray* columNames = [self columnNames:cla];
    NSArray* propertyInfos = [[DB sharedInstance] getProperties:cla contains:YES isSqlType:YES];

    if (!columNames.count || !propertyInfos.count)return;
    
    NSMutableArray* propertyNames = [NSMutableArray array];
    
    
    for(NSDictionary * propertyInfo in propertyInfos){
        
        NSString *key = propertyInfo.allKeys.firstObject;
        if (![columNames containsObject:key]) {
            [newKeys addObject:@{key:propertyInfo.allValues.firstObject}];
        }
        [propertyNames addObject:key];
    }
    
    [columNames enumerateObjectsUsingBlock:^(NSString* _Nonnull columName, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![propertyNames containsObject:columName]){
            [sqlKeys addObject:columName];
        }
    }];
    
    NSString* tableName = NSStringFromClass(cla);
    if((sqlKeys.count==0) && (newKeys.count>0)){NSLog(@"添加新字段...");
        //此处只是增加了新的列.
        for(NSDictionary* keyValue in newKeys){
            //添加新字段
            NSString* SQL = [NSString stringWithFormat:@"alter table %@ add %@ %@;",tableName,keyValue.allKeys.firstObject,keyValue.allValues.firstObject];
            [[DB sharedInstance] execSql:SQL];
        }
    }else if (sqlKeys.count>0){NSLog(@"数据库刷新....");
        //字段发生改变,减少或名称变化,实行刷新数据库.
        [self refresh:cla];//进行刷新处理.
    }else;
}

@end


@implementation NSObject (DB)



- (NSData *)jsonData
{
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([self isKindOfClass:[NSData class]]) {
        return (NSData *)self;
    }
    
    return [NSJSONSerialization dataWithJSONObject:[self jsonObject] options:kNilOptions error:nil];
}
//FIXME:  -  json -> 字典/数组
- (id)jsonObject
{
    if ([self isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    } else if ([self isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:nil];
    }
    
    return self;
}
//FIXME:  -  字典/数组 -> json
- (NSString *)jsonString
{
    if (!self || [self isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    } else if ([self isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
    }
    
    return [[NSString alloc] initWithData:[self jsonData] encoding:NSUTF8StringEncoding];
}


//FIXME:  -  字典数组 -> 模型数组
+ (NSMutableArray *)objectArrayWithKeyValuesArray:(id)keyValuesArray{
    NSMutableArray *modes = [NSMutableArray array];
    [keyValuesArray enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [modes addObject:[self objectWithKeyValues:obj]];
    }];
    return modes;
}

//FIXME:  -  字典 -> 模型
+ (instancetype)objectWithKeyValues:(id)keyValues{
    if(![keyValues isKindOfClass:[NSDictionary class]]) return keyValues;
    id model = [[self alloc] init];
    unsigned int outCount;
    //获取类中的所有成员属性
    Ivar * ivars = class_copyIvarList(self, &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        const char * cName = ivar_getName(ivar);
        const char * cType = ivar_getTypeEncoding(ivar);
        NSString *propertyName = [[NSString stringWithCString:cName encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"_" withString:@""];
        NSString *propertyType = [NSString stringWithCString:cType encoding:NSUTF8StringEncoding];
        
        id propertyValue = [keyValues valueForKey:propertyName];
        
        if(propertyValue == nil || [propertyValue isKindOfClass:[NSNull class]]) continue;
        if ([propertyType isEqualToString:@"@\"NSMutableDictionary\""]
            || [propertyType isEqualToString:@"@\"NSDictionary\""]
            || [propertyType isEqualToString:@"B"]
            || [propertyType isEqualToString:@"@\"NSString\""]
            || [propertyType isEqualToString:@"q"]
            || [propertyType isEqualToString:@"d"]
            || [propertyType isEqualToString:@"i"]
            || [propertyType isEqualToString:@"f"]
            || [propertyType isEqualToString:@"Q"]
            
            ) {
            [model setValue:propertyValue forKey:propertyName];
        }else if ([propertyType isEqualToString:@"@\"NSMutableArray\""] || [propertyType isEqualToString:@"@\"NSArray\""]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSDictionary * objDict = [self performSelector:@selector(classInArray)];
            Class c = [objDict valueForKey:propertyName];
#pragma clang diagnostic pop
            //if(c) [self arrayToObjcs:propertyValue class:c];
            if(c) [c objectArrayWithKeyValuesArray:propertyValue];
            else [model setValue:propertyValue forKey:propertyName];
        }else{
            propertyType = [propertyType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            propertyType = [propertyType stringByReplacingOccurrencesOfString:@"@" withString:@""];
            [model setValue:[NSClassFromString(propertyType) objectWithKeyValues:propertyValue] forKey:propertyName];

            //[model setValue:[self dict:propertyValue toObjc:NSClassFromString(propertyType)] forKey:propertyName];
        }
    }
    
    free(ivars);
    
    return model;
}


//FIXME:  -  模型 -> 字典
- (NSMutableDictionary *)keyValues{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([self class], &propsCount);//获得属性列表
    for(int i = 0;i < propsCount; i++){
        
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        id value = [self valueForKey:propName];//kvc读值
        if(value == nil){
            value = [NSNull null];
        }
        else{
            value = [value object];//自定义处理数组，字典，其他类
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}
- (id)object{
    
    if([self isKindOfClass:[NSString class]]
       || [self isKindOfClass:[NSNumber class]]
       || [self isKindOfClass:[NSNull class]]){
        
        return self;
    }
    
    if([self isKindOfClass:[NSArray class]]){
        
        NSArray *objarr = (NSArray *)self;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++){
            //[arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];

            [arr setObject:[[objarr objectAtIndex:i] object] atIndexedSubscript:i];
        }
        
        return arr;
    }
    
    if([self isKindOfClass:[NSDictionary class]]){
        
        NSDictionary *objdic = (NSDictionary *)self;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys){
            
            [dic setObject:[[objdic objectForKey:key] object] forKey:key];
            
        }
        return dic;
    }
    
    return [self keyValues];//[self getObjectData:obj];
}

//FIXME:  -  插入一条记录
- (BOOL)save{
    
    BOOL isOk = NO;
    
    [[DB sharedInstance] openDB];
    [[DB sharedInstance] createTable:[self class]];
    
    NSString *tableName = NSStringFromClass([self class]);
    
    [DB ifIvarChangeForClass:[self class]];
    
    
    NSArray <NSDictionary *> *infos = [[DB sharedInstance] getProperties:[self class] contains:NO isSqlType:YES];
    
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
                id value = [self valueForKey:key];
                if (![value isKindOfClass:[NSString class]]) {
                    //NSDictionary *obj = [self getObjectData:self];
                    NSDictionary *obj = [self keyValues];

                    value = [obj valueForKey:key];
                    //value = [self objectToJson:value];
                    value = [value jsonString];
                }
                sqlite3_bind_text(stmt, i+1, ((NSString *)value).UTF8String, -1, NULL);
            }
        }
        
        // sql语句已经全了
        // 执行伴随指针，如果为SQLITE_DONE 代表执行成功，并且成功的插入数据。
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            NSLog(@"插入成功");
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

//FIXME:  -  插入一个集合的记录
+ (BOOL)saveArray:(NSArray <id>*)models{
    
    __block BOOL isOK = NO;
    
    [[DB sharedInstance] openDB];
    [[DB sharedInstance] createTable:[models.firstObject class]];
    
    NSString *tableName = NSStringFromClass([models.firstObject class]);
    
    
    NSArray <NSDictionary *> *infos = [[DB sharedInstance] getProperties:[models.firstObject class] contains:NO isSqlType:YES];
    
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
            
            
//            for (int i = 0; i < info.allKeys.count; i ++) {
//
//                NSString *key = info.allKeys[i];
//                NSString *type = info.allValues[i];
//                if ([type isEqualToString:@"INTEGER"]) {
//                    sqlite3_bind_int64(stmt, i+1, [[model valueForKey:key] integerValue]);
//                }else if ([type isEqualToString:@"float"]) {
//                    sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] floatValue]);
//                }if ([type isEqualToString:@"double"]) {
//                    sqlite3_bind_double(stmt, i+1, [[model valueForKey:key] doubleValue]);
//                }if ([type isEqualToString:@"TEXT"]) {
//                    sqlite3_bind_text(stmt, i+1, ((NSString *)[model valueForKey:key]).UTF8String, -1, NULL);
//                }
//            }
            
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
                    id value = [model valueForKey:key];
                    if (![value isKindOfClass:[NSString class]]) {
                        //NSDictionary *obj = [self getObjectData:model];
                        NSDictionary *obj = [model keyValues];

                        value = [obj valueForKey:key];
                        //value = [self objectToJson:value];
                        value = [value jsonString];

                    }
                    sqlite3_bind_text(stmt, i+1, ((NSString *)value).UTF8String, -1, NULL);
                }
            }

            
            // sql语句已经全了
            // 执行伴随指针，如果为SQLITE_DONE 代表执行成功，并且成功的插入数据。
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                NSLog(@"插入成功");
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


    
//FIXME:  -  查找记录
+ (NSMutableArray <id>*)findWhere:(NSString *)condition{
    
    [[DB sharedInstance] openDB];
    NSString *tableName = NSStringFromClass(self);
    
    NSString *searchString = [NSString stringWithFormat:@"select * from %@ %@",tableName,condition?condition:@""];
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare(db, searchString.UTF8String, -1, &stmt, NULL);
    NSMutableArray *models = [NSMutableArray array];
    
    if (result == SQLITE_OK) {
        
        NSArray <NSDictionary *> *infos = [[DB sharedInstance] getProperties:self contains:YES isSqlType:NO];
        
        
        // 当sqlite3_step(stmt) == SQLITE_ROW 的时候，代表还有下一条数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            id model = [self new];
            for (int i = 0 ; i < infos.count; i++) {
                NSString *type = infos[i].allValues.firstObject;
                NSString *key = infos[i].allKeys.firstObject;
                
                if ( [type isEqualToString:@"NSMutableDictionary"] || [type isEqualToString:@"NSDictionary"]) {
                    
                    Class  c = NSClassFromString(@"NSDictionary");
                    
                    const unsigned char *txt =  sqlite3_column_text(stmt, i);
                    
                    if (txt != NULL) {
                        
                        NSString *json = [NSString stringWithUTF8String:(const char *)txt];
                        //id value = [self jsonToObject:json];
                        id value = [json jsonObject];

                        if ([c isSubclassOfClass:[NSDictionary class]]) {
                            [model setValue:value forKey:key];
                        }else {
                            [model setValue:[c objectWithKeyValues:value] forKey:key];

                            //[model setValue:[self dict:value toObjc:c] forKey:key];
                        }
                    }
                    
                    
                }else if ([type isEqualToString:@"NSArray"] || [type isEqualToString:@"NSMutableArray"]) {
                    
                    Class  c = NSClassFromString(@"NSString");
                    if([self respondsToSelector:@selector(classInArray)]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        NSDictionary * objDict = [self performSelector:@selector(classInArray)];
                        c = [objDict valueForKey:key]? [objDict valueForKey:key] : c;
#pragma clang diagnostic pop
                    }
                    
                    const unsigned char *txt =  sqlite3_column_text(stmt, i);
                    
                    if (txt != NULL) {
                        
                        NSString *json = [NSString stringWithUTF8String:(const char *)txt];
                        //id value = [self jsonToObject:json];
                        id value = [json jsonObject];
                        if ([c isSubclassOfClass:[NSString class]]) {
                            [model setValue:value forKey:key];
                        }else {
                            [model setValue:[c objectArrayWithKeyValuesArray:value] forKey:key];
                            //[model setValue:[self arrayToObjcs:value class:c] forKey:key];

                        }
                    }
                    
                    
                }else if ([type isEqualToString:@"INTEGER"]) {
                    
                    int uid = sqlite3_column_int(stmt, i);
                    [model setValue:@(uid) forKey:key];
                    
                }else if ([type isEqualToString:@"float"]) {
                    
                    float uid = sqlite3_column_double(stmt, i);
                    [model setValue:@(uid) forKey:key];
                    
                }else if ([type isEqualToString:@"double"]) {
                    
                    double uid = sqlite3_column_double(stmt, i);
                    [model setValue:@(uid) forKey:key];
                    
                }else if ([type isEqualToString:@"TEXT"]) {
                    const unsigned char *txt =  sqlite3_column_text(stmt, i);
                    if (txt != NULL) {
                        NSString *name = [NSString stringWithUTF8String:(const char *)txt];
                        (!name)? : [model setValue:name forKey:key];
                    }

                }else if([type containsString:@"@\""]){
                    type = [type stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    type = [type stringByReplacingOccurrencesOfString:@"@" withString:@""];
                    
                    const unsigned char *txt =  sqlite3_column_text(stmt, i);
                    
                    if (txt != NULL) {
                        
                        NSString *json = [NSString stringWithUTF8String:(const char *)txt];
                        //id value = [self jsonToObject:json];
                        id value = [json jsonObject];

                        [model setValue:[NSClassFromString(type) objectWithKeyValues:value] forKey:key];
                        //[model setValue:[self dict:value toObjc:NSClassFromString(type)] forKey:key];
                        
                    }
                    

                }
            }
            [models addObject:model];
        }
    }
    
    sqlite3_finalize(stmt);
    [[DB sharedInstance] closeDB];
    return models;
}

//FIXME:  -  删除记录
+ (BOOL)deleteWhere:(NSString *)condition{
    [[DB sharedInstance] openDB];
    NSString *tableName = NSStringFromClass(self);
    
    NSString *deleteString = [NSString stringWithFormat:@"delete from %@ %@", tableName,condition];
    
    BOOL result = [[DB sharedInstance] execSql:deleteString];//sqlite3_exec(db, deleteString.UTF8String, NULL, NULL, NULL);
    
    if (result) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
    [[DB sharedInstance] closeDB];
    return result;
}


//UPDATE table_name
//SET column1 = value1, column2 = value2...., columnN = valueN
//WHERE [condition];
//FIXME:  -  更新记录
- (BOOL)update{
    BOOL isOK = NO;
        [[DB sharedInstance] openDB];
    NSString *tableName = NSStringFromClass([self class]);
    NSArray <NSDictionary *> *infos = [[DB sharedInstance] getProperties:[self class] contains:NO isSqlType:YES];
    //NSArray <NSDictionary *> *modelTypes = [[DB sharedInstance] getProperties:[self class] contains:NO isSqlType:NO];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    id primaryKeyType = [[DB sharedInstance] isRespondsToSelector:@selector(primaryKey) forClass:[self class]];
#pragma clang diagnostic pop
    
    id primaryKeyValue = [self valueForKey:primaryKeyType];
    
    NSDictionary *selfDict = [self object];
    
    NSMutableString *updateString = [NSMutableString stringWithFormat:@"update %@ set ",tableName];
    [infos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = obj.allKeys.firstObject;
        NSString *value = [selfDict valueForKey:key];
        //if([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) value =  [self objectToJson:value];
        if([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) value =  [value jsonString];

        [updateString appendFormat:@"%@ = '%@',",key,value];
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
                NSString *value = [selfDict valueForKey:key];
                //if([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) value =  [self objectToJson:value];
                if([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) value =  [value jsonString];

                sqlite3_bind_text(stmt, i+1, ((NSString *)value).UTF8String, -1, NULL);
            }
        }
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            NSLog(@"更新成功");
            isOK = YES;
        }
    }else{
        NSLog(@"更新失败:%d", result);
        isOK = NO;
    }
    
    sqlite3_finalize(stmt);
        [[DB sharedInstance] closeDB];
    return isOK;
}
//FIXME:  -  自动插入或更新
- (BOOL)saveOrUpdate{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    id primaryKeyType = [[DB sharedInstance] isRespondsToSelector:@selector(primaryKey) forClass:[self class]];
#pragma clang diagnostic pop
    
    id primaryKeyValue = [self valueForKey:primaryKeyType];

    NSArray *result = [[self class] findWhere:[NSString stringWithFormat:@"where %@ = %@",primaryKeyType,primaryKeyValue]];
    if (result.count) {
        return [self update];
    }
    return [self save];
}


@end
