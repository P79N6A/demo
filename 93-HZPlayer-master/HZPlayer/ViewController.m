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
    NSString*urlPath = @"https://cache.m.iqiyi.com/mus/224131601/006d0133f2bdcb3b62590c353d883125/afbe8fd3d73448c9//20180409/e0/af/206e157dfb993138daf7e4ec80f7274e.m3u8?qd_originate=tmts_py&tvid=993758500&bossStatus=0&qd_vip=0&px=&qd_src=01080031010000000000&prv=&previewType=&previewTime=&from=&qd_time=1537242734699&qd_p=716f376f&qd_asc=786ef33d292ffaa667b03a1cdb5a35cf&qypid=993758500_04000000001000000000_2&qd_k=8336bb31b6bc7f51e701bdf19b4cfa4b&isdol=0&code=2&iswb=0&preIdAll=51300ad2bd6cffef99bd65d80a55aa63-8f49f1fd7ff59d9782d7c7f32ca60216-c078adedeeeca712b4bfb7a229b50543&dfp=a0fef557bd00f345089c90d3a519c30404233e43bb4cffbebbaf4f29f22332e43a&vf=e4a115afb0a99dcea214e3e12acad38d&np_tag=nginx_part_tag";
    
    NSArray*arr = [urlPath componentsSeparatedByString:@"/"];
    
    NSString*documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString*savePath = [NSString stringWithFormat:@"%@/%@",documentPath,[arr lastObject]];
    
    HZPlayer*player = [[HZPlayer alloc]initWithFrame:self.view.bounds urlPath:urlPath savePath:savePath];
    [self.view addSubview:player];
    
}

@end
