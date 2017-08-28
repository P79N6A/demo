//
//  NSString+xx.m
//  chatRoom
//
//  Created by pkss on 2017/4/24.
//  Copyright © 2017年 J. All rights reserved.
//

#import "NSString+xx.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (xx)

- (NSMutableString *)md5String {
    // 1.由于md5加密是通过C语言函数来计算,所以需要将NSString对象转化成为C语言的字符串.
    const char *cStr = [self UTF8String];
    // 2.创建一个C语言的字符数组,用来接收加密计数后的字符.
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    // 3.md5计算(加密过程)
    /*
     参数1为需要加密的字符串
     参数2为需要加密的字符串的长度
     参数3为加密完成之后的字符串存储的地方
     */
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    // 4.将加密完成的字符拼接起来使用(16进制的)
    // 声明一个可变字符串类型,用来拼接转换好的字符
    NSMutableString *resultStr = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH];
    // 遍历result数组,取出所有字符来拼接
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        // 此处格式控制符为x则为小写字母,X则为大写字母
        [resultStr appendFormat:@"%02X",result[i]];
    }
    NSLog(@"%@",resultStr);
    return resultStr;
}
-(NSString*)base64Encode{
    //1.将需要加密的数据转成二进制,因为Base64的编码和解码都是针对二进制的
    NSData*data = [self dataUsingEncoding:NSUTF8StringEncoding];
    //2.把二进制数据编码之后,直接转成字符串
    NSString*encodeStr = [data base64EncodedStringWithOptions:0];
    // 3.返回结果returnencodeStr;
    return encodeStr;
}

@end
