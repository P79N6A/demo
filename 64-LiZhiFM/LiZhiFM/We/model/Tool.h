//
//  Tool.h
//  FM
//
//  Created by ICHILD on 2017/10/13.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject

+ (void)calculateCache:(NSString *)directoryPath completion:(void(^)(NSInteger))completion;

+ (void)removeDirectoryPath:(NSString *)directoryPath;

@end
