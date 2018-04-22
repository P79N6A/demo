//
//  Tool.m
//  FM
//
//  Created by ICHILD on 2017/10/13.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "Tool.h"

@implementation Tool
+ (void)removeDirectoryPath:(NSString *)directoryPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL isExist = [manager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    if (!isExist || !isDirectory) {
        
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"路劲不符合" userInfo:nil];
        [excp raise];
        
    }
    
    
    NSArray *cachesArr = [manager contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *cachesP in cachesArr) {
        
        NSString *fillPath = [directoryPath stringByAppendingPathComponent:cachesP];
        
        [ manager removeItemAtPath:fillPath error:nil];
    }
    
    
}





+ (void)calculateCache:(NSString *)directoryPath completion:(void(^)(NSInteger))completion
{
    
    
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    NSArray *subPaths = [manager subpathsAtPath:directoryPath];
    
    __block NSInteger fillSize = 0;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (int i = 0; i < subPaths.count; i++) {
            NSString *subPath = subPaths[i];
            
            NSString * fillPath = [directoryPath stringByAppendingPathComponent:subPath];
            
            if ([fillPath containsString:@".DS"]) continue;
            
            BOOL isDirectory;
            
            BOOL isExist = [manager fileExistsAtPath:fillPath isDirectory:&isDirectory];
            
            if (isDirectory || !isExist) {
                continue;
            }
            
            NSDictionary *dict = [manager attributesOfItemAtPath:fillPath error:nil];
            
            NSInteger size = [dict fileSize];
            
            fillSize +=size;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(fillSize);
            };
        });
        
    });
    
}

@end
