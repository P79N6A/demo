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
@property (nonatomic, weak) PlayerView *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    VideoModel *model = [VideoModel new];
    model.name = @"hello tv";
    model.isVod = YES;
//    model.live_stream = [NSURL fileURLWithPath:@"/Users/jay/Downloads/20180503102411_460.mp4"];
    model.url = @"http://vip888.kuyun99.com/20180802/wcFfyu0v/index.m3u8?sign=9a2f77b13159249164e257ed7356dab84549a9f7b9a70e5509bc3e0359cdcfd7a258b5708ab7d87677196d08cb14c397bce8db18e488383ddf21376648d73e35";
//    model.live_stream = @"http://e1.vdowowza.vip.hk1.tvb.com/tvblive/smil:mobilehd_financeintl.smil/playlist.m3u8";
//    model.live_stream = @"http://onair.onair.network:8068/listen.pls";
    
    PlayerView *player = [PlayerView playerView];
    player.frame = CGRectMake(0, 100, 320, 200);
    [player playWithModel:model];
    [self.view addSubview:player];
    _player = player;
}

- (IBAction)video:(id)sender {
    VideoModel *model = [VideoModel new];
    model.name = @"hello tv";
    model.isVod = YES;
    model.url = @"http://vip888.kuyun99.com/20180802/wcFfyu0v/index.m3u8?sign=9a2f77b13159249164e257ed7356dab84549a9f7b9a70e5509bc3e0359cdcfd7a258b5708ab7d87677196d08cb14c397bce8db18e488383ddf21376648d73e35";
    
    [_player playWithModel:model];
    
    self.spStatusBarStyle = UIStatusBarStyleDefault;
}

- (IBAction)living:(id)sender {
    VideoModel *model = [VideoModel new];
    model.name = @"hello tv";
    model.url = @"http://116.199.5.51:8114/LIVES/index.m3u8?Fsv_otype=1&FvSeid=&Pcontent_id=&Provider_id=&Fsv_chan_hls_se_idx=23";
    
    [_player playWithModel:model];
    self.spStatusBarStyle = UIStatusBarStyleLightContent;
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    VideoModel *model = [VideoModel new];
//    model.name = @"hello radio";
//    model.url = @"http://111.223.51.7:8000/listen.pls?sid=1";
//    
//    [_player playWithModel:model];
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
