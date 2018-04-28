//
//  TTZPayKit.m
//  Payment
//
//  Created by Jay on 2018/4/18.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "TTZPay.h"
#import "TTZKeyChain.h"
#import "UIDevice+Pay.h"

#import <StoreKit/StoreKit.h>
//#import <SVProgressHUD.h>

@interface TTZPay() <SKPaymentTransactionObserver, SKProductsRequestDelegate>

// 苹果内购
@property (nonatomic, copy) NSString *productID;
@property (nonatomic, copy) payCompleteBlock payComplete;
@property (nonatomic, copy) loadingBuyBlock loadingBuy;
@property (nonatomic, strong) NSDictionary *products;

@end

@implementation TTZPay

+ (instancetype)defaultPay{
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


#pragma mark -- 结束上次未完成的交易 防止串单
-(void)removeAllUncompleteTransaction{
    
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count > 0) {
        //检测是否有未完成的交易
        SKPaymentTransaction* transaction = [transactions firstObject];
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            return;
        }
    }
}

#pragma mark  -  恢复购买
- (void)restoreBuyloading:(loadingBuyBlock)loadingBlock
              allProducts:(NSDictionary *)products
              payComplete:(payCompleteBlock)completionBlock{
    self.payComplete = completionBlock;
    self.loadingBuy = loadingBlock;
    self.products = products;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    !(loadingBlock)? : loadingBlock(@"恢复中...");
}

#pragma mark  -  购买
//请求商品
- (void)buyWithProductIdentifier:(NSString *)productId
                     allProducts:(NSDictionary *)products
                      loadingBuy:(loadingBuyBlock)loadingBlock
                     payComplete:(payCompleteBlock)completionBlock{
    
    if(![SKPaymentQueue canMakePayments]) {
        NSLog(@"-------------0.0 不允许程序内付费");
        !(completionBlock)? : completionBlock(@"设备不能或不允许购买");
        return;
    }
    
    if ([UIDevice currentDevice].isJailbroken) {
        NSLog(@"-------------0.0 不允许越狱设备付费");
        !(completionBlock)? : completionBlock(@"越狱设备不允许购买");
        return;
    }
    
    [self removeAllUncompleteTransaction];
    
    
    self.payComplete = completionBlock;
    self.loadingBuy = loadingBlock;
    self.productID = productId;
    self.products = products;
    
    NSArray *product = [[NSArray alloc] initWithObjects:productId, nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    !(loadingBlock)? : loadingBlock(@"加载中...");
    NSLog(@"-------------1.0 加载中对应的产品信息");
    
}

#pragma mark  -  SKProductsRequestDelegate
//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"--------------2.0 没有商品");
        !(_payComplete)? : _payComplete(@"没有项目可购买");
        return;
    }
    
    //NSLog(@"productID:%@,产品付费数量:%lu", response.invalidProductIdentifiers,(unsigned long)[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"-------------2.0 本地标题：%@，本地描述：%@，价格：%@，ID：%@",[pro localizedTitle],[pro localizedDescription],[pro price],[pro productIdentifier]);
        if([pro.productIdentifier isEqualToString:self.productID]){
            p = pro;
        }
    }
    
    !(_payComplete)? : _payComplete(nil);
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    NSLog(@"-------------4.0 购买中");
    !(_loadingBuy)? : _loadingBuy(@"购买中...");
    //    });
    
}

#pragma mark  -  SKRequestDelegate
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"-------------2.0 请求产品错误:%@", error);
    !(_payComplete)? : _payComplete(error.localizedDescription);
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"-------------3.0 请求产品完成");
}

#pragma mark  -  SKPaymentTransactionObserver
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        
        NSLog(@"-------------5.0 正在监听：%@", tran.payment.productIdentifier);
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"-------------5.0 支付成功");
                !(_payComplete)? : _payComplete(@"支付成功");
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"-------------5.0 商品添加进列表");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"-------------5.0 恢复购买");
                !(_payComplete)? : _payComplete(@"恢复购买");
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                NSLog(@"-------------5.0 支付失败：%@",tran.error.localizedDescription);
                !(_payComplete)? : _payComplete([NSString stringWithFormat:@"支付失败:%@",tran.error.localizedDescription]);
                break;
            default:
                break;
        }
    }
}


//解决方法很简单，增加一个Restore按钮，并调用[[SKPaymentQueue defaultQueue] restoreCompletedTransactions]，接下来的流程是
// 1. init 的时候注册回调
//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
// 2. dealloc 的时候删除回调
//[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
// 3. 点击恢复购买的时候调用
//[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
// 4. updatedTransactions中实现 SKPaymentTransactionStateRestored 状态
//- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
//5.实现paymentQueueRestoreCompletedTransactionsFinished回调(恢复成功时先调用4，后调用5，)
//- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
//6.实现 restoreCompletedTransactionsFailedWithError（恢复错误调用）
//- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
//按照网上文章的说法
//1. 注册回调后
//2. 点击恢复按钮，弹出账号输入界面 （实测ok)
//3. 点击取消迪调用 restoreCompletedTransactionsFailedWithError (实测ok)
//4. 点击确定先调用 updatedTransactions 在updatedTransactions 中处理恢复程序逻辑(加金币等)
//5. 后调用 paymentQueueRestoreCompletedTransactionsFinished
//

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    NSLog(@"-------------4.0 恢复失败:%@",error.localizedDescription);
    !(_payComplete)? : _payComplete([NSString stringWithFormat:@"恢复失败:%@",error.localizedDescription]);
}
// 恢复购买
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"-------------5.0 恢复购买队列数:%lu",(unsigned long)queue.transactions.count);
    if(!queue.transactions.count) !(_payComplete)? : _payComplete(@"没有已购买项目");

    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        NSLog(@"-------------5.0 恢复购买产品ID:%@",productID);
    }
    
}



//FIXME:  -  本地验证订单
//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    
    
    //交易验证
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    
    if(!receipt){
        
    }
    
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    
    if (!requestData) { /* ... Handle error ... */ }
    
    
    
    [TTZKeyChain saveData:requestData forKey:transaction.payment.productIdentifier];
    
    [self verifyReceiptData:requestData];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

//FIXME:  -  本地验证订单
- (void)verifyReceiptData:(NSData *)requestData{
    
    NSLog(@"-------------6.0 验证中...");
    !(_loadingBuy)? : _loadingBuy(@"验证中...");
    
    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt
    // Create a POST request with the receipt data.
    
    // 发送网络POST请求，对购买凭据进行验证
    NSString *verifyUrlString;
#if (defined(APPSTORE_ASK_TO_BUY_IN_SANDBOX) && defined(DEBUG))
    verifyUrlString = @"https://sandbox.itunes.apple.com/verifyReceipt";
#else
    verifyUrlString = @"https://buy.itunes.apple.com/verifyReceipt";
#endif
    
    NSURL *storeURL = [NSURL URLWithString:verifyUrlString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:25.0];
    
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:storeRequest
                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                         
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             
                                             if (error) {
                                                 NSLog(@"-------------6.0 请求失败:%@",error.localizedDescription);
                                                 !(_payComplete)? : _payComplete([NSString stringWithFormat:@"请求失败:%@",error.localizedDescription]);
                                                 
                                             } else {
                                                 NSError *error;
                                                 NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                 if (!jsonResponse) {
                                                     NSLog(@"-------------6.0 验证失败:%@",error.localizedDescription);
                                                     !(_payComplete)? : _payComplete([NSString stringWithFormat:@"验证失败:%@",error.localizedDescription]);
                                                     
                                                     return ;
                                                 }
                                                 
                                                 // 比对 jsonResponse 中以下信息基本上可以保证数据安全
                                                 /*
                                                  bundle_id
                                                  application_version
                                                  product_id
                                                  transaction_id
                                                  */
                                                 //                                   21000 App Store无法读取你提供的JSON数据
                                                 //                                   21002 收据数据不符合格式
                                                 //                                   21003 收据无法被验证
                                                 //                                   21004 你提供的共享密钥和账户的共享密钥不一致
                                                 //                                   21005 收据服务器当前不可用
                                                 //                                   21006 收据是有效的，但订阅服务已经过期。当收到这个信息时，解码后的收据信息也包含在返回内容中
                                                 //                                   21007 收据信息是测试用（sandbox），但却被发送到产品环境中验证
                                                 //                                   21008 收据信息是产品环境中使用，但却被发送到测试环境中验证
                                                 //
                                                 
                                                 
                                                 NSInteger status = [[jsonResponse valueForKey:@"status"] integerValue];
                                                 if(status){
                                                     NSLog(@"-------------6.0 验证出错:%ld",(long)status);
                                                     !(_payComplete)? : _payComplete([NSString stringWithFormat:@"\n验证出错:%ld\n",(long)status]);
                                                     return;
                                                 }
                                                 //NSString *environment = [jsonResponse valueForKey:@"environment"];
                                                 NSDictionary *receipt = [jsonResponse valueForKey:@"receipt"];
                                                 NSString  *bundle_id = [receipt valueForKey:@"bundle_id"];
                                                 //NSString  *application_version = [receipt valueForKey:@"application_version"];
                                                 NSArray *in_apps = [receipt valueForKey:@"in_app"];
                                                 
                                                 NSMutableString *msg = [NSMutableString string];
                                                 
                                                 [in_apps enumerateObjectsUsingBlock:^(NSDictionary * in_app, NSUInteger idx, BOOL * _Nonnull stop) {
                                                     
                                                     NSString  *product_id = [in_app valueForKey:@"product_id"];
                                                     NSMutableDictionary *inAppData = jsonResponse.mutableCopy;
                                                     NSMutableDictionary *receiptM = receipt.mutableCopy;
                                                     receiptM[@"in_app"] = in_app;
                                                     inAppData[@"receipt"] = receiptM;
                                                     NSString *title = self.products? self.products[product_id] : product_id;
                                                     
                                                     if (!status && [bundle_id isEqualToString:[[NSBundle mainBundle] bundleIdentifier]])
                                                     {
                                                         
                                                         [TTZKeyChain saveData:inAppData forKey:product_id];
                                                         NSString *ok = [NSString stringWithFormat:@"\n验证成功[%@]\n",title];
                                                         [msg appendString:ok];
                                                         
                                                     }else if (status){
                                                         NSString *error = [NSString stringWithFormat:@"\n验证出错[%@]:%ld\n",title,(long)status];
                                                         [msg appendString:error];
                                                         
                                                     }else{
                                                         NSString *nor = [NSString stringWithFormat:@"\nAppID异常[%@]:%@\n",title,bundle_id];
                                                         [msg appendString:nor];
                                                         
                                                     }
                                                 }];
                                                 NSLog(@"-------------6.0 验证成功:%@",msg);
                                                 !(_payComplete)? : _payComplete(msg);
                                                 
                                                 //NSString  *transaction_id = [in_app valueForKey:@"transaction_id"];
                                                 
                                                 //[SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"验证成功:%@",product_id]];
                                                 //!(_payComplete)? : _payComplete(nil,[NSString stringWithFormat:@"验证成功:%@",product_id]);
                                                 
                                                 
                                                 //                                             [[SKPaymentQueue defaultQueue].transactions enumerateObjectsUsingBlock:^(SKPaymentTransaction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                 //                                                 if(obj.transactionState != SKPaymentTransactionStatePurchasing) [[SKPaymentQueue defaultQueue] finishTransaction:obj];
                                                 //                                             }];
                                                 
                                             }
                                         });
                                         
                                     }] resume];
}


//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//
////FIXME:  - alert
//+ (void)showAlert:(NSString *)msg{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                    message:msg
//                                                   delegate:nil
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles: nil];
//    [alert show];
//
//    [self performSelector:@selector(dimissAlert:)withObject:alert afterDelay:1.5];
//}
//
//+ (void)dimissAlert:(UIAlertView *)alert {
//
//    if(alert){
//        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
//    }
//}
//
//#pragma clang diagnostic pop


+ (id)paymentWithProductIdentifier:(NSString *)productId{
    return [TTZKeyChain getDataForKey:productId];
}

+ (TTZPaymentState)PaymentStateWithProductIdentifier:(NSString *)productId{
    
    NSDictionary *jsonResponse = [self paymentWithProductIdentifier:productId];
    
    if ([jsonResponse isKindOfClass:[NSData class]]) {
        //交易验证
        NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
        NSData *requestData;
        if(receipt){
            NSError *error;
            NSDictionary *requestContents = @{
                                              @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                              };
            requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
        }else{
            requestData = (NSData *)jsonResponse;
        }
        //要验证支付
        [[TTZPay defaultPay] verifyReceiptData:requestData];
        NSLog(@"0----%@----已支付，未验证", productId);
        return TTZPaymentStateUnverifiedPurchased;
    }
    
    
    if (!jsonResponse ||  ![jsonResponse isKindOfClass:[NSDictionary class]] ) {
        NSLog(@"0----%@----未购买", productId);
        return TTZPaymentStateNotPurchased;
    }
    
    
    NSInteger status = [[jsonResponse valueForKey:@"status"] integerValue];
    NSDictionary *receipt = [jsonResponse valueForKey:@"receipt"];
    NSString  *bundle_id = [receipt valueForKey:@"bundle_id"];
    NSDictionary *in_app = [receipt valueForKey:@"in_app"];
    NSString  *product_id = [in_app valueForKey:@"product_id"];
    
    if (!status && [productId isEqualToString:product_id]
        && [bundle_id isEqualToString:[[NSBundle mainBundle] bundleIdentifier]]) {
        
        NSLog(@"0----%@----已购买", productId);
        return TTZPaymentStatePurchased;
    }
    
    NSLog(@"0----%@----未购买", productId);
    return TTZPaymentStateNotPurchased;
}


@end
