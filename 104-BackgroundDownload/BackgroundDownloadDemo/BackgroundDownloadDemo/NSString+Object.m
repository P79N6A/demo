//
//  NSString+Object.m
//  PingShu
//
//  Created by xin on 2018/9/1.
//  Copyright © 2018年 Jayson. All rights reserved.
//

#import "NSString+Object.h"

@implementation NSString (Object)
- (id)toJSONObject{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
}
@end
