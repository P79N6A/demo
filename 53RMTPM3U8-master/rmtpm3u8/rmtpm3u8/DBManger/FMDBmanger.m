//
//  FMDBmanger.m
//  rmtpm3u8
//
//  Created by 何川 on 2018/3/21.
//  Copyright © 2018年 何川. All rights reserved.
//

#import "FMDBmanger.h"
#import "FMDB.h"
@interface FMDBmanger()

@property(nonatomic,copy) NSString *dbPath;

@end;

@implementation FMDBmanger

+(instancetype)shareManger{
    static FMDBmanger *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self makeDatabase];
    }
    return self;
}

-(void)makeDatabase{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _dbPath = [path stringByAppendingString:@"/TValist.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
        NSString * sql = @"CREATE TABLE 'availableTV' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'title' VARCHAR(30), 'urlString' VARCHAR(30))";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"succ to creating db table");
        }
        [db close];
    }else{
        NSLog(@"error when open db");
    }
}

-(void)insertTVmodelData:(TVmodel*)model{
//    if (model.itemId == nil) {
    
    
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
//    if ([db open]) {
//        NSString * sqlpre = [NSString stringWithFormat:@"select * from availableTV where urlString = '%@'",model.urlString];
//        FMResultSet * rs = [db executeQuery:sqlpre];
//        if (rs == nil) {
//            NSString * sql = @"insert into availableTV (title, urlString) values(?, ?) ";
//            BOOL res = [db executeUpdate:sql, model.title,model.urlString];
//            if (!res) {
//                NSLog(@"error to insert data");
//            } else {
//                NSLog(@"succ to insert data");
//                [SVProgressHUD showSuccessWithStatus:@"插入成功"];
//            }
//        }
//        [db close];
//    }
    
        if ([db open]) {
            NSString * sql = @"insert into availableTV (title, urlString) values(?, ?) ";
            BOOL res = [db executeUpdate:sql, model.title,model.urlString];
            if (!res) {
                NSLog(@"error to insert data");
            } else {
                NSLog(@"succ to insert data");
                [SVProgressHUD showSuccessWithStatus:@"插入成功"];
            }
            [db close];
        }

}
-(NSArray*)getAllTvModels{
    NSMutableArray *temparray = [NSMutableArray array];
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = @"select * from availableTV";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            int userId = [rs intForColumn:@"id"];
            NSString * title = [rs stringForColumn:@"title"];
            NSString * urlstring = [rs stringForColumn:@"urlString"];
            TVmodel *model = [[TVmodel alloc] init];
            model.title = title;
            model.urlString = urlstring;
            model.itemId = [NSNumber numberWithInt:userId];
            [temparray addObject:model];
        }
        [db close];
    }
    return [temparray copy];

}
-(BOOL)deleateTvModel:(TVmodel*)model{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql =[NSString stringWithFormat: @"delete from availableTV where urlString = '%@'",model.urlString];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error to delete db line");

        } else {
            NSLog(@"succ to deleta db line");
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];

        }
        [db close];
        
        return res;
    }
    
    return NO;
}

@end
