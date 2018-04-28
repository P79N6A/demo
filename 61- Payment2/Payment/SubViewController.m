//
//  SubViewController.m
//  Payment
//
//  Created by Jay on 26/4/18.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "SubViewController.h"
#import "UIView+Loading.h"
#import <StoreKit/StoreKit.h>

@interface SubViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (nonatomic, copy) NSString *identifier;
@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.identifier = @"com.photoedit.www_19";
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//    [self completeTransaction:nil];
    
}

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
}


//FIXME:  -  消耗型
- (IBAction)Action {
//    NSLog(@"%s----点击鸡腿----一周", __func__);
//    self.identifier = @"com.photoedit.www_19";
    [self buy];
    
}
//FIXME:  -  非消耗型
- (IBAction)qingFengZiAction {
//    NSLog(@"%s----点击请疯子---一个月", __func__);
//    self.identifier = @"com.photoedit.www_60";
    [self buy];
}
//FIXME:  -  非消耗型
- (IBAction)buyAction {
//    NSLog(@"%s----点击周星星", __func__);
    
}
//FIXME:  -  恢复购买
- (IBAction)restoreBuyAction {
    NSLog(@"%s----点击恢复购买", __func__);
}

- (IBAction)comphotoeditwww_18:(id)sender {
    NSLog(@"%s----一个月去广告-非续期订阅", __func__);
        self.identifier = @"com.photoedit.www_18";
    [self buy];


}
- (IBAction)comphotoeditwww_12:(id)sender {
    NSLog(@"%s----去广告专业版-非消耗型项目", __func__);
    self.identifier = @"com.photoedit.www_12";
    [self buy];


}
- (IBAction)comphotoeditwww_06:(id)sender {
    NSLog(@"%s----请我吃鸡腿-消耗型项目", __func__);
    self.identifier = @"com.photoedit.www_06";
    [self buy];

}

- (IBAction)comphotoeditwww_19:(id)sender {
    NSLog(@"%s----连续一周会员-自动续期订阅", __func__);
    self.identifier = @"com.photoedit.www_19";
    [self buy];

    
}
- (IBAction)comphotoeditwww_01:(id)sender {
    NSLog(@"%s----连续一周去广告-自动续期订阅", __func__);
    self.identifier = @"com.photoedit.www_01";
    [self buy];

}
- (IBAction)comphotoeditwww_60:(id)sender {
    NSLog(@"%s----连续一月会员-自动续期订阅", __func__);
    self.identifier = @"com.photoedit.www_60";
    [self buy];

}


- (void)buy{
   
    if ([SKPaymentQueue canMakePayments]) {
        //允许应用内付费购买
        
        NSArray *productIdentifiers = @[self.identifier];
        NSSet * set = [NSSet setWithArray:productIdentifiers];
        SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
        request.delegate = self;
        [request start];
        

        
    }else {
        //用户禁止应用内付费购买.
        [self.view hideLoading:@"用户禁止应用内付费购买"];
    }

}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response NS_AVAILABLE_IOS(3_0);
{
    
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"--------------2.0 没有商品");
        return;
    }
    
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"-------------2.0 本地标题：%@，本地描述：%@，价格：%@，ID：%@",[pro localizedTitle],[pro localizedDescription],[pro price],[pro productIdentifier]);
        if([pro.productIdentifier isEqualToString:self.identifier]){
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    NSLog(@"-------------4.0 购买中");

}

- (void)requestDidFinish:(SKRequest *)request {
    
    if([request isKindOfClass:[SKReceiptRefreshRequest class]])
    {
        //处理回调
        [self completeTransaction:nil];
        return;
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
NSLog(@"%s---%@", __func__,error);
}

#pragma mark  -  SKPaymentTransactionObserver
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        
        NSLog(@"-------------5.0 正在监听：%@", tran.payment.productIdentifier);
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"-------------5.0 支付成功");
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"-------------5.0 商品添加进列表");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"-------------5.0 恢复购买");
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                NSLog(@"-------------5.0 支付失败：%@",tran.error.localizedDescription);
                break;
            default:
                break;
        }
    }
}


- (NSString *)iapReceipt
{
    NSString *receiptString = nil;
    NSURL *rereceiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[rereceiptURL path]]) {
        NSData *receiptData = [NSData dataWithContentsOfURL:rereceiptURL];
        receiptString = [receiptData base64EncodedStringWithOptions:0];
    }
    
    return receiptString;
}



//FIXME:  -  本地验证订单
//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    
   if(transaction) [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

    //交易验证
    NSString *receipt = [self iapReceipt];
    
    if(!receipt){
        SKReceiptRefreshRequest *refreshReceiptRequest = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:@{}];
        refreshReceiptRequest.delegate = self;
        [refreshReceiptRequest start];
        return;
    }
    
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": receipt,
                                      @"password":@"8ec5c2ae169b48a0902b0e2ab4c293d9",
                                      @"exclude-old-transactions": @(YES)
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    
    if (!requestData) { /* ... Handle error ... */ }
    
    

    [self verifyReceiptData:requestData isSandbox:YES];
    
}

//FIXME:  -  本地验证订单
- (void)verifyReceiptData:(NSData *)requestData
                isSandbox:(BOOL)flag{
    
    NSLog(@"-------------6.0 验证中...");
    
    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt
    // Create a POST request with the receipt data.
    
    // 发送网络POST请求，对购买凭据进行验证
    NSString *verifyUrlString = @"https://buy.itunes.apple.com/verifyReceipt";
    if (flag) {
        verifyUrlString = @"https://sandbox.itunes.apple.com/verifyReceipt";
    }
    
    NSURL *storeURL = [NSURL URLWithString:verifyUrlString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:25.0];
    
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:storeRequest
                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                         
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             
                                             if (error) {
                                                 NSLog(@"-------------6.0 请求失败:%@",error.localizedDescription);
                                                 
                                             } else {
                                                 NSError *error;
                                                 NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                 if (!jsonResponse) {
                                                     NSLog(@"-------------6.0 验证失败:%@",error.localizedDescription);
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
                                                     
                                                     if (status == 21008) {
                                                         [self verifyReceiptData:requestData isSandbox:NO];
                                                         return;
                                                     }
                                                     NSLog(@"-------------6.0 验证出错:%ld",(long)status);
                                                     return;
                                                 }
                                                 [self checkIsValidSubscribeWithResponse:jsonResponse];
                                                NSLog(@"-------------6.0 验证成功");
                                      
                                                 
                                             }
                                         });
                                         
                                     }] resume];
}


//FIXME:  -  订阅产品需要验证订阅是否过期
- (BOOL)checkIsValidSubscribeWithResponse:(NSDictionary *)response
{
    long long expirationTime = [self expirationDateFromResponse:response productId:self.identifier];
    BOOL isCurrentInfoValid = [self checkIsCurrentInfoValid:response productId:self.identifier];
    BOOL isRenewInfoValid = [self checkIsRenewInfoValid:response productId:self.identifier];
    //NSDate *expireDate = [NSDate dateWithTimeIntervalSince1970:expirationTime/1000];
    //NSTimeInterval timeInterval = [expireDate timeIntervalSinceDate:date];

    long long nowTime = [self nowDateFromResponse:response productId:self.identifier];
    NSTimeInterval timeInterval = expirationTime - nowTime;
    
    BOOL isValidSubscribed = NO;
    if (timeInterval > 0 && isCurrentInfoValid) {
        //有效
        isValidSubscribed = YES;
    } else if (isRenewInfoValid) {
        isValidSubscribed = YES;
    }
    
    NSLog(@"%s------99.订阅状态：%d", __func__,isValidSubscribed);
    
    return isValidSubscribed;
}

//FIXME:  -  (过期时间戳) expires_date_ms
- (long long)expirationDateFromResponse:(NSDictionary *)jsonResponse
                              productId:(NSString *)productId {
    
    NSArray *receiptInfos = jsonResponse[@"latest_receipt_info"];
    if (receiptInfos && receiptInfos.count > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"product_id = %@", productId];
        NSArray *array = [receiptInfos filteredArrayUsingPredicate:predicate];
        
        if (array && array.count > 0) {
            NSDictionary *lastReceipt = array.lastObject;
            NSNumber *expiresMs = lastReceipt[@"expires_date_ms"];
            
            return expiresMs.longLongValue;
        }
    }
    
    return 0;
}

//FIXME:  -  (请求时间戳-现在) request_date_ms
- (long long)nowDateFromResponse:(NSDictionary *)jsonResponse
                              productId:(NSString *)productId {
    
    NSDictionary *receipt = [jsonResponse valueForKey:@"receipt"];
    
    long long nowMs = [[receipt valueForKey:@"request_date_ms"] longLongValue];
    
    return nowMs? nowMs : [[NSDate date] timeIntervalSince1970]*1000;
    
}


- (BOOL)checkIsRenewInfoValid:(NSDictionary *)jsonResponse
                    productId:(NSString *)productId {
    NSArray *renewalInfos = jsonResponse[@"pending_renewal_info"];
    if (renewalInfos && renewalInfos.count > 0) {
        for (NSDictionary *renewalInfo in renewalInfos) {
            NSString *curProductId = renewalInfo[@"product_id"];
            NSString *renewProductId = renewalInfo[@"auto_renew_product_id"];
            NSNumber *status = renewalInfo[@"auto_renew_status"];
            
            if ([renewProductId isEqualToString:productId] && ![curProductId isEqualToString:renewProductId]) {
                if (status.intValue == 1) {
                    /*
                     * 当前订阅状态为 正常（status为 1）
                     * 订阅存在续费订单（renewProductId），且和当前订单（curProductId）不是同一商品
                     * 则认为renewProductId是降级后的续费产品，为有效预订产品，视为已购买
                     */
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

- (BOOL)checkIsCurrentInfoValid:(NSDictionary *)jsonResponse
                      productId:(NSString *)productId {
    NSArray *renewalInfos = jsonResponse[@"pending_renewal_info"];
    if (renewalInfos && renewalInfos.count > 0) {
        for (NSDictionary *renewalInfo in renewalInfos) {
            NSString *curProductId = renewalInfo[@"product_id"];
            if ([curProductId isEqualToString:productId]) {
                //校验状态
                NSNumber *status = renewalInfo[@"auto_renew_status"];
                NSNumber *expiration_intent = renewalInfo[@"expiration_intent"];
                //                NSNumber *is_in_billing_retry_period = renewalInfo[@"is_in_billing_retry_period"];
                
                if (status.intValue == 0 && expiration_intent) {
                } else {
                    /*
                     * 当前订阅状态为 已停止续费 （status为 0）
                     * 当前订阅续费存在停止原因 （expiration_intent）
                     * 则当前订阅已过期
                     */
                    return YES;
                }
                
                break;
            }
        }
    }
    
    return NO;
}


@end
