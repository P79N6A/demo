//
//  LZAdViewController.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/22.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZAdViewController.h"

#import "UIView+Loading.h"
#import "TTZPay.h"

@interface LZAdViewController ()

@property (weak, nonatomic) IBOutlet UIView *adView1;
@property (weak, nonatomic) IBOutlet UIView *adView2;
@property (weak, nonatomic) IBOutlet UIView *adView3;
@property (weak, nonatomic) IBOutlet UIButton *pay30;
@property (weak, nonatomic) IBOutlet UIButton *pay6;
@property (weak, nonatomic) IBOutlet UIButton *pay12;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation LZAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.top.constant += kStatusBarAndNavigationBarHeight;
    kViewRadius(self.adView1, 5);
    kViewRadius(self.adView2, 5);
    kViewRadius(self.adView3, 5);
    
    kViewBorderRadius(self.pay6, 5, 1, [UIColor whiteColor]);
    kViewBorderRadius(self.pay12, 5, 1, [UIColor whiteColor]);
    kViewBorderRadius(self.pay30, 5, 1, [UIColor whiteColor]);
    self.title = @"关于广告";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"恢复购买" style:UIBarButtonItemStyleDone target:self action:@selector(reset)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pay6Action:(UIButton *)sender {
    NSDictionary *product = @{@"com.chinaradio.www_30":@"清峰子",@"com.chinaradio.www_12":@"周星星",@"com.chinaradio.www_06":@"请我吃鸡腿"};
    [[TTZPay defaultPay] buyWithProductIdentifier:@"com.chinaradio.www_06"
                                      allProducts:product
                                       loadingBuy:^(NSString *message) {
                                           [self.view showLoading:message];
                                       } payComplete:^(NSString *message) {
                                           [self.view hideLoading:message];
                                       }];
    
}
- (IBAction)pay12Action:(UIButton *)sender {
    NSDictionary *product = @{@"com.chinaradio.www_30":@"清峰子",@"com.chinaradio.www_12":@"周星星",@"com.chinaradio.www_06":@"请我吃鸡腿"};
    [[TTZPay defaultPay] buyWithProductIdentifier:@"com.chinaradio.www_12"
                                      allProducts:product
                                       loadingBuy:^(NSString *message) {
                                           [self.view showLoading:message];
                                       } payComplete:^(NSString *message) {
                                           [self.view hideLoading:message];
                                       }];
    
}
- (IBAction)pay30Action:(UIButton *)sender {
    NSDictionary *product = @{@"com.chinaradio.www_30":@"清峰子",@"com.chinaradio.www_12":@"周星星",@"com.chinaradio.www_06":@"请我吃鸡腿"};
    [[TTZPay defaultPay] buyWithProductIdentifier:@"com.chinaradio.www_30"
                                      allProducts:product
                                       loadingBuy:^(NSString *message) {
                                           [self.view showLoading:message];
                                       } payComplete:^(NSString *message) {
                                           [self.view hideLoading:message];
                                       }];
    
}

- (void)reset{
    NSDictionary *product = @{@"com.chinaradio.www_30":@"清峰子",@"com.chinaradio.www_12":@"周星星",@"com.chinaradio.www_06":@"请我吃鸡腿"};
    [[TTZPay defaultPay] restoreBuyloading:^(NSString *message) {
        [self.view showLoading:message];
        
    }
                               allProducts:product
                               payComplete:^(NSString *message) {
                                   [self.view hideLoading:message];
                               }];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
