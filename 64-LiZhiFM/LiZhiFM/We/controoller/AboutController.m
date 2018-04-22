//
//  AboutController.m
//  screenshot
//
//  Created by czljcb on 2017/9/24.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "AboutController.h"

@interface AboutController ()

@end

@implementation AboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)qq:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://jq.qq.com/?_wv=1027&k=5fxoFdA"]];
}

@end
