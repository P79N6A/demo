//
//  ViewController.m
//  HZPlayer
//
//  Created by ios开发 on 2017/8/25.
//  Copyright © 2017年 fuhanzhang. All rights reserved.
//

#import "ViewController.h"
#import "HZPlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSString*urlPath = @"http://image.zhimabaobao.com/upload/quan/2017/08/24/d19eb5e00bb74c3ca3c566545a2a3ca6.mp4";
    NSString*urlPath = @"https://jaysongd.github.io/api/new.mp4";
    
    NSArray*arr = [urlPath componentsSeparatedByString:@"/"];
    
    NSString*documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString*savePath = [NSString stringWithFormat:@"%@/%@",documentPath,[arr lastObject]];
    
    HZPlayer*player = [[HZPlayer alloc]initWithFrame:self.view.bounds urlPath:urlPath savePath:savePath];
    [self.view addSubview:player];
    
}

@end
