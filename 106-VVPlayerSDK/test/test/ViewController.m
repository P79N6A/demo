//
//  ViewController.m
//  test
//
//  Created by Jay on 17/9/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

//#import <VVPlayer/VVPlayerView.h>
#import <YYPlayer/YYPlayerView.h>

@interface ViewController ()
@property (nonatomic, weak) YYPlayerView *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    YYVideoModel *model = [YYVideoModel new];
    model.title = @"hello tv";
    //    model.live_stream = [NSURL fileURLWithPath:@"/Users/jay/Downloads/20180503102411_460.mp4"];
    model.url = @"http://vip888.kuyun99.com/20180802/wcFfyu0v/index.m3u8?sign=9a2f77b13159249164e257ed7356dab84549a9f7b9a70e5509bc3e0359cdcfd7a258b5708ab7d87677196d08cb14c397bce8db18e488383ddf21376648d73e35";
    //    model.live_stream = @"http://e1.vdowowza.vip.hk1.tvb.com/tvblive/smil:mobilehd_financeintl.smil/playlist.m3u8";
    //    model.live_stream = @"http://onair.onair.network:8068/listen.pls";
    model.url = @"http://m.91kds.cn/jiemu_cctv2.html";
    
    YYPlayerView *player = [YYPlayerView playerView];
    player.allowSafariPlay = YES;
    player.frame = CGRectMake(0, 64, 320, 200);
    [player playWithModel:model];
    [self.view addSubview:player];
    _player = player;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
