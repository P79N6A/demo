//
//  ViewController.m
//  Payment
//
//  Created by czljcb on 2018/3/4.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "test.h"

#import <StoreKit/StoreKit.h>
#import <SVProgressHUD.h>

#import "TTZPayKit.h"


@interface test()
//<SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (copy, nonatomic)  NSString *productID;

@end

@implementation test

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    return;
    // Do any additional setup after loading the view, typically from a nib.
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    // 苹果内购是否为沙盒测试账号,打开就代表为沙盒测试账号,注意上线时注释掉
#define APPSTORE_ASK_TO_BUY_IN_SANDBOX 1
    // 生成订单参数，注意沙盒测试账号与线上正式苹果账号的验证途径不一样，要给后台标明
    NSNumber *sandbox;
#if (defined(APPSTORE_ASK_TO_BUY_IN_SANDBOX) && defined(DEBUG))
    sandbox = @(0);
#else
    sandbox = @(1);
#endif
    
}
- (IBAction)Action {
    
    
    [[TTZPayKit defaultPay] requestProductDataWithString:@"com.chinaradio.www_06" payComplete:^(NSDictionary *resultDic, NSString *errorMsg) {
        
    }];
    
    return;
    self.productID = @"com.chinaradio.www_06";
    [self purchaseFunc];
}
- (IBAction)qingFengZiAction {
    
    [[TTZPayKit defaultPay] requestProductDataWithString:@"com.chinaradio.www_30" payComplete:^(NSDictionary *resultDic, NSString *errorMsg) {
        
    }];

    return;
    self.productID = @"com.chinaradio.www_30";
    [self purchaseFunc];
}

- (IBAction)buyAction {
    
    [[TTZPayKit defaultPay] restoreBuy];
    return;
    self.productID = @"com.chinaradio.www_12";
    [self purchaseFunc];
}
- (IBAction)restoreBuyAction {
    
    [[TTZPayKit defaultPay] restoreBuy];

    return;
    [self restoreBuy];
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
- (void)restoreBuy{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
#pragma mark  -  购买
- (void)purchaseFunc {
    [self removeAllUncompleteTransaction];
    NSString *product = self.productID;
    if([SKPaymentQueue canMakePayments]){
        [self requestProductData:product];
    }else{
        NSLog(@"不允许程序内付费");
        [SVProgressHUD showErrorWithStatus:@"不允许程序内付费"];
    }
}

#pragma mark  -  请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息（%@）----------------",type);
    NSArray *product = [[NSArray alloc] initWithObjects:type, nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}
#pragma mark  -  SKProductsRequestDelegate
//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"--------------没有商品------------------");
        [SVProgressHUD showErrorWithStatus:@"没有商品"];
        return;
    }
    
    NSLog(@"productID:%@,产品付费数量:%lu", response.invalidProductIdentifiers,(unsigned long)[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"描述：%@，本地标题：%@，本地描述：%@，价格：%@，ID：%@", [pro description],[pro localizedTitle],[pro localizedDescription],[pro price],[pro productIdentifier]);        
        if([pro.productIdentifier isEqualToString:self.productID]){
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [SVProgressHUD showWithStatus:@"购买中..."];
}

#pragma mark  -  SKRequestDelegate
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];

}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
}
//123456abcABC caozhi@ttz.com


#pragma mark  -  SKPaymentTransactionObserver
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        
        NSLog(@"正在监听 ------ %@", tran.payment.productIdentifier);
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                [self completeTransaction:tran];
                [SVProgressHUD showSuccessWithStatus:@"交易完成"];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                [self completeTransaction:tran];
                [SVProgressHUD showSuccessWithStatus:@"已经购买过商品"];

                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败--%@",tran.error.localizedDescription);
                [SVProgressHUD showErrorWithStatus:tran.error.localizedDescription];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];

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
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"恢复购买失败:%@",error.localizedDescription]];
}
// 恢复购买
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        NSLog(@"%@",productID);
    }
}



//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
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
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    
    // Make a connection to the iTunes Store on a background queue.
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"链接失败");
                                   [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"链接失败:%@",connectionError.localizedDescription]];
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (!jsonResponse) {
                                       NSLog(@"验证失败");
                                       [SVProgressHUD showErrorWithStatus:@"验证失败"];
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
                                   NSLog(@"验证成功");//10319159
                                   
                                   
                                   NSInteger status = [[jsonResponse valueForKey:@"status"] integerValue];
                                   NSString *environment = [jsonResponse valueForKey:@"environment"];
                                   NSDictionary *receipt = [jsonResponse valueForKey:@"receipt"];

                                   NSString  *bundle_id = [receipt valueForKey:@"bundle_id"];
                                   NSString  *application_version = [receipt valueForKey:@"application_version"];
                                   
                                   NSDictionary *in_app = [receipt valueForKey:@"in_app"];

                                   NSString  *product_id = [in_app valueForKey:@"product_id"];
                                   NSString  *transaction_id = [in_app valueForKey:@"transaction_id"];

                                   [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"验证成功:%@",product_id]];
                                   
                                   [[SKPaymentQueue defaultQueue].transactions enumerateObjectsUsingBlock:^(SKPaymentTransaction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                       [[SKPaymentQueue defaultQueue] finishTransaction:obj];
                                   }];

                               }
                           }];
    
    
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
