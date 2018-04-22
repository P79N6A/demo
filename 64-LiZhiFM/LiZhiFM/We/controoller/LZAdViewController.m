//
//  LZAdViewController.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/22.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZAdViewController.h"

#import "UIView+Loading.h"

@interface LZAdViewController ()

@property (weak, nonatomic) IBOutlet UIView *adView1;
@property (weak, nonatomic) IBOutlet UIView *adView2;
@property (weak, nonatomic) IBOutlet UIView *adView3;
@property (weak, nonatomic) IBOutlet UIButton *pay30;
@property (weak, nonatomic) IBOutlet UIButton *pay6;
@property (weak, nonatomic) IBOutlet UIButton *pay12;

@end

@implementation LZAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    [self.view showLoading:@"loading..."];
}
- (IBAction)pay12Action:(UIButton *)sender {
}
- (IBAction)pay30Action:(UIButton *)sender {
}

- (void)reset{
    
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
