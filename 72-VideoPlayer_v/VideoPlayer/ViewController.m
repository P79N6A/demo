//
//  ViewController.m
//  VideoPlayer
//
//  Created by Jay on 12/5/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "Player/PlayerView.h"
#import "VideoModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    VideoModel *model = [VideoModel new];
    model.name = @"hello tv";
    model.url = @"http://175.6.128.2:468/15013_xv_78678200_78678200_0_0_0-15013_xa_78678200_78678200_0_0_0-0-0.m3u8?uuid=82e7f53dc05c44718dbcd8df509beea4&org=yyweb&m=c5ea59d88f1ac114aa5a55b63838c010&r=1237740623&v=1&t=1526113006&uid=0";
//    model.url = @"http://123.246.130.146/78dda3f83909dc934ee94d8c29414c8b.m3u8?type=phone.ios&key=f623f4ca07337d1c273bc5198112f351&k=0fcd80e898346ef7f9a4e8e32c4acf3a-b2d8-1526125813";
    
    PlayerView *player = [PlayerView playerView];
    player.frame = CGRectMake(0, 100, 320, 200);
    [player playWithModel:model];
    [self.view addSubview:player];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
