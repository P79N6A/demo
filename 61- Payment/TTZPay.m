//
//  TTZPayManager.m
//  Payment
//
//  Created by czljcb on 2018/3/4.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "TTZPay.h"
#import <StoreKit/StoreKit.h>

@interface TTZPay() <SKPaymentTransactionObserver, SKProductsRequestDelegate>

// 苹果内购
@property (nonatomic, copy) NSString *appleProductIdentifier;
@property (nonatomic, copy) payCompleteBlock payComplete;

@property (nonatomic, assign) BOOL startBuyAppleProduct;

@end

@implementation TTZPay

+ (instancetype)sharedPayManager {
    static TTZPay *payManager;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        payManager = [[TTZPay alloc] init];
        // 注册苹果内购
        [[SKPaymentQueue defaultQueue] addTransactionObserver:payManager];
        
    });
    return payManager;
}

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - 苹果支付充值
//请求商品
- (void)requestAppleStoreProductDataWithString:(NSString *)productIdentifier 
                                   payComplete:(payCompleteBlock)payCompletionBlock {
    if(![SKPaymentQueue canMakePayments]) {
        NSLog(@"不允许程序内付费");
        //        [APPCONTEXT.hudHelper showHudOnWindow:@"不允许程序内付费" image:nil acitivity:NO autoHideTime:DEFAULTTIME];
        !(payCompletionBlock)? : payCompletionBlock(nil,@"不允许程序内付费");
        return;
    }
    
    NSLog(@"-------------请求对应的产品信息----------------");
    self.startBuyAppleProduct = YES;
    self.payComplete = payCompletionBlock;
    self.appleProductIdentifier = productIdentifier;
    
    NSLog(@"生成产品信息");
    NSArray *product = [[NSArray alloc] initWithObjects:productIdentifier, nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}

//FIXME:  -  SKRequestDelegate
//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *products = response.products;
    if([products count] == 0){
        NSLog(@"--------------没有商品------------------");
        !(_payComplete)? : _payComplete(nil,@"没有商品");
        return;
    }
    
    NSLog(@"productID:%@,产品付费数量:%lu", response.invalidProductIdentifiers,(unsigned long)[products count]);
    
    SKProduct *product = nil;
    for (SKProduct *pro in products) {
        
        NSLog(@"描述：%@，本地标题：%@，本地描述：%@，价格：%@，ID：%@", [pro description],[pro localizedTitle],[pro localizedDescription],[pro price],[pro productIdentifier]);

        if([pro.productIdentifier isEqualToString:self.appleProductIdentifier]){
            product = pro;
            break;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
    !(_payComplete)? : _payComplete(nil,error.localizedDescription);

}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
}

//FIXME:  -  SKPaymentTransactionObserver
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction {
    for(SKPaymentTransaction *paymentTransactionp in transaction){
        
        switch (paymentTransactionp.transactionState) {
            case SKPaymentTransactionStatePurchased:
            {
                NSLog(@"交易完成");
                /* your code */
                [self buyAppleStoreProductSucceedWithPaymentTransactionp:paymentTransactionp];
                
                [self completeTransaction:paymentTransactionp];
            }
                
                break;
                
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                [self completeTransaction:paymentTransactionp];
                break;
                
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"交易失败");
                /* your code */
                [self completeTransaction:paymentTransactionp];
            }
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"还没有做出选择");
                break;
        }
    }
}

// 苹果内购支付成功
- (void)buyAppleStoreProductSucceedWithPaymentTransactionp:(SKPaymentTransaction *)paymentTransactionp {
    
    /* 获取相应的凭据，并做 base64 编码处理 */
    NSString *base64Str = [paymentTransactionp.transactionReceipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSLog(@"苹果内购凭据号\n\n\n\n\n\n%@\n\n\n\n\n\n",base64Str);
    
    [self checkAppStorePayResultWithBase64String:base64Str];
}


- (void)checkAppStorePayResultWithBase64String:(NSString *)base64String {
    
    /* 生成订单参数，注意沙盒测试账号与线上正式苹果账号的验证途径不一样，要给后台标明 */
    NSNumber *sandbox;
#if (defined(APPSTORE_ASK_TO_BUY_IN_SANDBOX) && defined(DEBUG))
    sandbox = @(0);
#else
    sandbox = @(1);
#endif
    
    NSMutableDictionary *prgam = [[NSMutableDictionary alloc] init];;
    [prgam setValue:sandbox forKey:@"sandbox"];
    [prgam setValue:base64String forKey:@"reciept"];
    
    /*
     请求后台接口，服务器处验证是否支付成功，依据返回结果做相应逻辑处理
     */
    
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

@end

