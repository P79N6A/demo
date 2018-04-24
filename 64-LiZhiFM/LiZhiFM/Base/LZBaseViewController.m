//
//  LZBaseViewController.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/16.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZBaseViewController.h"


@interface LZBaseViewController ()

@end

@implementation LZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view showLoading:@"加载中..."];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.view hideLoading:@"贯文化自信的中国"];
//    });
//}

#pragma mark  -  自定义方法
- (void)initUI{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bg.image = [UIImage imageNamed:@"Snip20180418_3"];
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bar.barStyle = UIBarStyleBlack;

    [bg addSubview:bar];
//    [bg setImageToBlur:[UIImage imageNamed:@"Snip20180418_3"]
//                        blurRadius:kLBBlurredImageDefaultBlurRadius
//                   completionBlock:^(){
//                       NSLog(@"The blurred image has been set");
//                   }];
    [self.view insertSubview:bg atIndex:0];
}

@end
