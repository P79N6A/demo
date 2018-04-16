//
//  AnimalModel.m
//  Dog
//
//  Created by czljcb on 2018/4/6.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "AnimalModel.h"

@implementation AnimalModel

+ (NSMutableArray <AnimalModel *>*)modelFormArray:(NSArray <NSDictionary *>*)objs{
    
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:objs.count];
    [objs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AnimalModel *model = [AnimalModel new];
        [model setValuesForKeysWithDictionary:obj];
        [datas addObject:model];
        
    }];
    
    return datas;
}

@end
