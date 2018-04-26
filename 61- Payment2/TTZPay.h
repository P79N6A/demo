//
//  TTZPayManager.h
//  Payment
//
//  Created by czljcb on 2018/3/4.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import <Foundation/Foundation.h>

// 苹果内购是否为沙盒测试账号,打开就代表为沙盒测试账号,注意上线时注释掉！！
#define APPSTORE_ASK_TO_BUY_IN_SANDBOX 1

//typedef void(^payCompleteBlock)(NSDictionary *resultDic, BOOL isSuccess);
typedef void(^payCompleteBlock)(NSDictionary *resultDic,  NSString *errorMsg);

@interface TTZPay : NSObject

+ (instancetype)sharedPayManager;

/// 苹果内购
- (void)requestAppleStoreProductDataWithString:(NSString *)productIdentifier
                                   payComplete:(payCompleteBlock)payCompletionBlock;
/// 验证苹果支付订单凭证
- (void)checkAppStorePayResultWithBase64String:(NSString *)base64String;

@end
