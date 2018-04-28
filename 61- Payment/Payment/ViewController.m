//
//  ViewController.m
//  Payment
//
//  Created by Jay on 2018/4/18.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "ViewController.h"

#import "TTZPay.h"
#import "TTZKeyChain.h"

#import <StoreKit/StoreKit.h>
#import <SVProgressHUD.h>
//#import "UIView+Loading.m"
#import "UIView+Loading.h"

@interface ViewController ()
@property (nonatomic, strong) NSDictionary *products;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.products = @{@"com.chinaradio.www_30":@"清峰子",@"com.chinaradio.www_30":@"周星星",@"com.chinaradio.www_06":@"请我吃鸡腿"};
    //    NSLog(@"%s---%@", __func__,[TTZKeyChain getDataForKey:@"22333"]);
    //    [TTZKeyChain saveData:@{@"name":@"cz"} forKey:@"info"];
    
    //    NSLog(@"%s--%@", __func__,[TTZPay paymentWithProductIdentifier:@"com.chinaradio.www_30"]);
    //    NSLog(@"%s--%@", __func__,[TTZPay paymentWithProductIdentifier:@"com.chinaradio.www_12"]);
    //    NSLog(@"%s--%@", __func__,[TTZPay paymentWithProductIdentifier:@"com.chinaradio.www_06"]);
    
    NSLog(@"%s-%ld", __func__,(long)[TTZPay PaymentStateWithProductIdentifier:@"com.chinaradio.www_30"]);
    NSLog(@"%s-%ld", __func__,(long)[TTZPay PaymentStateWithProductIdentifier:@"com.chinaradio.www_12"]);
    NSLog(@"%s-%ld", __func__,(long)[TTZPay PaymentStateWithProductIdentifier:@"com.chinaradio.www_06"]);
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view showLoading:@"loading..."];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.view hideLoading:@"购买成功"];
//    });
//}
//FIXME:  -  消耗型
- (IBAction)Action {
    NSLog(@"%s----点击鸡腿", __func__);
    
    
    [[TTZPay defaultPay] buyWithProductIdentifier:@"com.chinaradio.www_06"
                                      allProducts:self.products
                                       loadingBuy:^(NSString *message) {
                                           [self.view showLoading:message];
                                       }
                                      payComplete:^(NSString *message) {
                                          [self.view hideLoading:message];
                                      }];
}
//FIXME:  -  非消耗型
- (IBAction)qingFengZiAction {
    NSLog(@"%s----点击请疯子", __func__);
    [[TTZPay defaultPay] buyWithProductIdentifier:@"com.chinaradio.www_30"
                                      allProducts:self.products
                                       loadingBuy:^(NSString *message) {
                                           [self.view showLoading:message];
                                       }
                                      payComplete:^(NSString *message) {
                                          [self.view hideLoading:message];
                                      }];
    
    
}
//FIXME:  -  非消耗型
- (IBAction)buyAction {
    NSLog(@"%s----点击周星星", __func__);
    
//    [[TTZPay defaultPay] buyWithProductIdentifier:@"com.chinaradio.www_12"
//                                      allProducts:self.products
//                                       loadingBuy:^(NSString *message) {
//                                           [self.view showLoading:message];
//                                       }
//                                      payComplete:^(NSString *message) {
//                                          [self.view hideLoading:message];
//                                      }];
    
    [[TTZPay defaultPay] buyWithProductIdentifier:@"com.chinaradio.www_12" allProducts:self.products loadingBuy:^(NSString *message) {
                                                   [self.view showLoading:message];

    } statusBuy:^(NSString *message) {
        [self.view hideLoading:message];
    } paySuccess:^(NSString *message) {
        [self.view hideLoading:message];
        NSLog(@"%s", __func__);
    } verifySuccess:^(NSString *message) {
        [self.view hideLoading:message];
        NSLog(@"%s", __func__);
    }];
}
//FIXME:  -  恢复购买
- (IBAction)restoreBuyAction {
    NSLog(@"%s----点击恢复购买", __func__);
    [[TTZPay defaultPay] restoreBuyloading:^(NSString *message) {
        [self.view showLoading:message];
    }
                               allProducts:self.products
                               payComplete:^(NSString *message) {
                                   [self.view hideLoading:message];
                               }];
}


@end
