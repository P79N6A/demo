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
    NSString*urlPath = @"http://cache.m.iqiyi.com/mus/224131601/9aedd710f12c5b6c204543280b9ed789/afbe8fd3d73448c9//20180409/14/55/f1c7eb3d1c594e3c67096f56fcc4ae44.m3u8?qd_originate=tmts_py&tvid=993758500&bossStatus=0&qd_vip=0&px=&src=2_20_201&prv=&previewType=&previewTime=&from=&qd_time=1537259962613&qd_p=716f376f&qd_asc=04bb8d3ee37754870e2b18d108abf1d8&qypid=993758500_04000000001000000000_1&qd_k=4ced491cc8ecbd2a4e3e2c29b26abc69&isdol=0&code=2&ff=f4v&iswb=0&preIdAll=62a6bd28b1fd96ca48fd205a7a608432-3388e20264ee7e252017045edf529a9f-62a6bd28b1fd96ca48fd205a7a608432&sgti=12_v0j5eu22mofo7ch7n98sdljp_1537259961745&dfp=a05a1c3bc4057b4120ac9c6f18ea313f23c2f29092e308dbee14d1f64bd4563018&vf=859c7980de6b8ac5e075edf624344b74&np_tag=nginx_part_tag&qypid=993758500_31";
    
    NSArray*arr = [urlPath componentsSeparatedByString:@"/"];
    
    NSString*documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString*savePath = [NSString stringWithFormat:@"%@/%@",documentPath,[arr lastObject]];
    
    HZPlayer*player = [[HZPlayer alloc]initWithFrame:self.view.bounds urlPath:urlPath savePath:savePath];
    [self.view addSubview:player];
    
}

@end
