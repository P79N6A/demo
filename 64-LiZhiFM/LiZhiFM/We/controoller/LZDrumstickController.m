//
//  LZDrumstickController.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/22.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZDrumstickController.h"

#import "LZCommon.h"
#import "TTZPay.h"

@interface LZDrumstickController ()
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation LZDrumstickController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.view.backgroundColor = kBackgroundColor;
    self.top.constant += kStatusBarAndNavigationBarHeight;

    kViewRadius(self.payBtn, 5);
    self.title = @"鸡腿";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)payAction:(UIButton *)sender {
    NSDictionary *product = @{@"com.chinaradio.www_30":@"清峰子",@"com.chinaradio.www_12":@"周星星",@"com.chinaradio.www_06":@"请我吃鸡腿"};
    [[TTZPay defaultPay] buyWithProductIdentifier:@"com.chinaradio.www_06"
                                      allProducts:product
                                       loadingBuy:^(NSString *message) {
                                           [self.view showLoading:message];
                                       } payComplete:^(NSString *message) {
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
