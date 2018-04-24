//
//  LZliveChannelModel.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/21.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZliveChannelModel.h"
#import "LZData.h"
@implementation LZStreamModel
@end


@implementation LZliveChannelModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"streams" : [LZStreamModel class]};
}

- (void)setName:(NSString *)name{

    //__block NSString *key;
    _name = name;

    NSArray *keys = [LZData descDict].allKeys;
    
    if([keys containsObject:name]){
        _key = name;
        return;
    }
    
    for (NSInteger i = 0; i < keys.count; i ++) {

        NSString *local = keys[i];
        NSString *key = [self matchLongestSubstrings:name with:local].firstObject;
        NSString *min = (name.length > local.length)? local : name;

        if (key) {
            if ((key.length * 1.0 / min.length) > 0.66) {
                _key = local;
                return;
            }
        }
    }

//    [[LZData descDict].allKeys enumerateObjectsUsingBlock:^(NSString *  obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj = @"CNR中国之声";
//        key = [self isCommonA:name B:obj];
//        if (key) {
//            *stop = YES;
//        }
//    }];

    _key = name;

}


//- (NSString *)key{
//
//        NSArray *keys = [LZData descDict].allKeys;
//        for (NSInteger i = 0; i < keys.count; i ++) {
//
//            NSString *local = keys[i];
//            NSString *key = [self matchLongestSubstrings:_name with:local].firstObject;
//            NSString *min = (_name.length > local.length)? local : _name;
//
//            if (key) {
//                if ((key.length * 1.0 / min.length) > 0.75) {
//                    _key = local;
//                    break;
//                }
//                return;
//            }
//        }
//
//
//        _key = name;
//
//}


-(NSArray *)matchLongestSubstrings:(NSString *)str1 with:(NSString *)str2 {
    // 所有重复的字符串
    NSArray<NSString *> *matchingStrArr = [NSArray array];
    for (NSUInteger i = 0; i < str1.length; i++) {
        unichar c = [str1 characterAtIndex:i];
        NSString *s = [NSString stringWithFormat:@"%C", c];
        matchingStrArr = [matchingStrArr arrayByAddingObjectsFromArray:[self compareStr1:str1 toStr2:str2 withCharacterString:s indexInStr1:i]];
    }
    // 去掉重复的数据
    NSSet<NSString *> *matchingStrSet = [NSSet setWithArray:matchingStrArr];
    matchingStrArr = [matchingStrSet allObjects];
    // 数组内字符串按length降序排列
    matchingStrArr = [matchingStrArr sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return ((NSString*)obj1).length<((NSString*)obj2).length;
    }];
    NSInteger longestLength = matchingStrArr.firstObject.length;
    __block NSArray *longestStrArr = [NSArray array];
    [matchingStrArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.length == longestLength) {
            longestStrArr = [longestStrArr arrayByAddingObject:obj];
        }
        else{
            *stop = YES;
        }
    }];
    return longestStrArr;
}
-(NSArray *)compareStr1:(NSString *)str1 toStr2:(NSString *)str2 withCharacterString:(NSString *)s indexInStr1:(NSUInteger)i{
    if (![str2 containsString:s]){
        return nil;
    }
    NSRange rangeOfStr2 = [str2 rangeOfString:s];
    NSMutableArray *longestStrArr = [NSMutableArray array];
    
    for (NSUInteger j = rangeOfStr2.location, ii = i; j < str2.length && ii < str1.length; j++, ii++) {
        if ([[str1 substringWithRange:NSMakeRange(ii, 1)] isEqualToString:[str2 substringWithRange:NSMakeRange(j, 1)]] ) {
            if (j == str2.length - 1 || ii == str1.length - 1) {//匹配到字符串最后一个字符
                NSString *sameStr = [str1 substringWithRange:NSMakeRange(i, ii+1 - i)];
                [longestStrArr addObject:sameStr];
            }
        }
        else{
            NSString *sameStr = [str1 substringWithRange:NSMakeRange(i, ii - i)];
            [longestStrArr addObject:sameStr];
            break;
        }
    }
    if (str2.length <=1) {
        return nil;// str2只剩1个字符,结束递归调用
    }
    str2 = [str2 substringFromIndex:1];
    if (str2.length>1) {
        [longestStrArr addObjectsFromArray:[self compareStr1:str1 toStr2:str2 withCharacterString:s indexInStr1:i]];
    }
    return longestStrArr;
}


@end
