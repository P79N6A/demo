//
//  LZBaseViewController.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/16.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZBaseViewController.h"

#import "UIImageView+LBBlurredImage.h"

@interface LZBaseViewController ()

@end

@implementation LZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

#pragma mark  -  自定义方法
- (void)setUI{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [bg setImageToBlur:[UIImage imageNamed:@"03511538eaa8b631aaeb4c79503b2f432151df473900b-BhbAhj_fw658"]
                        blurRadius:kLBBlurredImageDefaultBlurRadius
                   completionBlock:^(){
                       NSLog(@"The blurred image has been set");
                   }];
    [self.view addSubview:bg];
}

@end
