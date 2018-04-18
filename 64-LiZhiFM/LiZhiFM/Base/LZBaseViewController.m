//
//  LZBaseViewController.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/16.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZBaseViewController.h"

#import "UIImageView+LBBlurredImage.h"
#import "UIView+Loading.h"

@interface LZBaseViewController ()

@end

@implementation LZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view hideLoading:@"贯文化自信的中国让"];
}

#pragma mark  -  自定义方法
- (void)setUI{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [bg setImageToBlur:[UIImage imageNamed:@"Snip20180418_3"]
                        blurRadius:kLBBlurredImageDefaultBlurRadius
                   completionBlock:^(){
                       NSLog(@"The blurred image has been set");
                   }];
    [self.view addSubview:bg];
}

@end
