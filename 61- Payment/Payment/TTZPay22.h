//
//  TTZPayKit.h
//  Payment
//
//  Created by Jay on 2018/4/18.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TTZPaymentState) {
    TTZPaymentStateNotPurchased = 0,//未购买
    TTZPaymentStateUnverifiedPurchased = 1,//已支付，未验证
    TTZPaymentStatePurchased = 2//购买
};

@interface TTZPay : NSObject

// 苹果内购是否为沙盒测试账号,打开就代表为沙盒测试账号,注意上线时注释掉！！
#define APPSTORE_ASK_TO_BUY_IN_SANDBOX 1

//typedef void(^payCompleteBlock)(NSDictionary *resultDic,  NSString *errorMsg);
typedef void(^payCompleteBlock)(NSString *message);
typedef void(^loadingBuyBlock)(NSString *message);


+ (instancetype)defaultPay;

/// 苹果内购
- (void)buyWithProductIdentifier:(NSString *)productId
                     allProducts:(NSDictionary *)products
                      loadingBuy:(loadingBuyBlock)loadingBlock
                     payComplete:(payCompleteBlock)completionBlock;


/// 恢复购买
- (void)restoreBuyloading:(loadingBuyBlock)loadingBlock
              allProducts:(NSDictionary *)products// @{@"productId",@"title"}
              payComplete:(payCompleteBlock)completionBlock;


+ (TTZPaymentState)PaymentStateWithProductIdentifier:(NSString *)productId;

@end
