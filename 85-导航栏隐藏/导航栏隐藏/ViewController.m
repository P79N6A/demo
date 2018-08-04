//
//  ViewController.m
//  导航栏隐藏
//
//  Created by PW on 17/3/11.
//  Copyright © 2017年 Oriental Horizon. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationBar+Alpha.h"
#import "PW_Controller.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"首页";
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    imageView.image = [UIImage imageNamed:@"品牌默认"];
    [self.view addSubview:imageView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 400, 100, 50)];
    
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
 
   


}

-(void) btnClick{

    PW_Controller *PW_VC = [[PW_Controller alloc]init];
    [self.navigationController pushViewController:PW_VC animated:YES];

}

@end
