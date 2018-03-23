//
//  TVmodel.m
//  rmtpm3u8
//
//  Created by 何川 on 2018/3/20.
//  Copyright © 2018年 何川. All rights reserved.
//

#import "TVmodel.h"

@implementation TVmodel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"itemId":@"id"}];
}
@end
