//
//  ViewController.m
//  VideoPlayer
//
//  Created by Jay on 12/5/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "Player/PlayerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    VideoModel *model = [VideoModel new];
    model.name = @"hello tv";
//    model.live_stream = [NSURL fileURLWithPath:@"/Users/jay/Downloads/20180503102411_460.mp4"];
    model.live_stream = @"http://v8.yongjiu8.com/20180728/9RqhywBV/index.m3u8?sign=d01961496809fa99b125ca730eb4ea6b21c32cc8ecbdb0de55ab82b9a5aaa60399c9f19f7a25806497adac43a5ca9052ec7621429f6048ef95880e0007574fa6";
//    model.live_stream = @"http://e1.vdowowza.vip.hk1.tvb.com/tvblive/smil:mobilehd_financeintl.smil/playlist.m3u8";
//    model.live_stream = @"http://onair.onair.network:8068/listen.pls";
    
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
