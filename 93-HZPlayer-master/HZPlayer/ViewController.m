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
    NSString*urlPath = @"http://vip888.kuyun99.com/20180802/wcFfyu0v/index.m3u8?sign=9a2f77b13159249164e257ed7356dab84549a9f7b9a70e5509bc3e0359cdcfd7a258b5708ab7d87677196d08cb14c397bce8db18e488383ddf21376648d73e35";
    
    NSArray*arr = [urlPath componentsSeparatedByString:@"/"];
    
    NSString*documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString*savePath = [NSString stringWithFormat:@"%@/%@",documentPath,[arr lastObject]];
    
    HZPlayer*player = [[HZPlayer alloc]initWithFrame:self.view.bounds urlPath:urlPath savePath:savePath];
    [self.view addSubview:player];
    
}

@end
