//
//  ViewController.m
//  JSPlayer
//
//  Created by Jay on 3/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "JSPlayer/PlayerView.h"

@interface ViewController ()

@property (nonatomic, weak) PlayerView *playerView;
@end

@implementation ViewController
- (IBAction)video:(id)sender {
    VideoModel *model = [VideoModel new];
    model.title = @"hello tv";
    model.url = @"http://vip888.kuyun99.com/20180802/wcFfyu0v/index.m3u8?sign=9a2f77b13159249164e257ed7356dab84549a9f7b9a70e5509bc3e0359cdcfd7a258b5708ab7d87677196d08cb14c397bce8db18e488383ddf21376648d73e35";//@"https1://t.bwzybf.com/2018/10/25/oWEYZvMJUDeyxaWJ/playlist.m3u8";//@"https://cdn.youku-letv.com/20181022/m4MlVDnt/index.m3u8";
    [_playerView playWithModel:model];
    
    //    self.spStatusBarStyle = UIStatusBarStyleDefault;
    //    self.spStatusBarHidden = YES;
    
}

- (IBAction)living:(id)sender {
    VideoModel *model = [VideoModel new];
    model.title = @"hello tv";
    model.url = @"https://de035ceb0768225b04e9a007abe39fca.live.prod.hkatv.com/a1_cbr_lo_1.m3u8";//@"http://m.567it.com/j5.m3u8";
    
    [_playerView playWithModel:model];
    //self.spStatusBarStyle = UIStatusBarStyleLightContent;
    //    self.spStatusBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    VideoModel *model = [VideoModel new];
    model.title = @"hello tv";
    //    model.live_stream = [NSURL fileURLWithPath:@"/Users/jay/Downloads/20180503102411_460.mp4"];
    model.url = @"http://aldirect.hls.huya.com/huyalive/94525224-2472147404-10617792251071299584-2777026638-10057-A-0-1_1200.m3u8";//@"https://cdn.youku-letv.com/20181022/m4MlVDnt/index.m3u8";
    //    model.live_stream = @"http://e1.vdowowza.vip.hk1.tvb.com/tvblive/smil:mobilehd_financeintl.smil/playlist.m3u8";
    //    model.live_stream = @"http://onair.onair.network:8068/listen.pls";
    
    PlayerView *player = [PlayerView playerView];
    player.frame = CGRectMake( 0, 100, self.view.bounds.size.width,  self.view.bounds.size.width * 9.0 / 16.0);
    player.allowSafariPlay = YES;
    [player playWithModel:model];
    [self.view addSubview:player];
    _playerView = player;
    
    

    

}
- (IBAction)click:(UIButton *)sender {
    
    
    NSArray *lists = @[@"rtmp://live.hkstv.hk.lxdns.com/live/hks",@"https://cdn.youku-letv.com/20181022/m4MlVDnt/index.m3u8",@"http://m.567it.com/jade.m3u8"];
    
    VideoModel *model = [VideoModel new];
    model.title = @"hello tv";
    model.url = lists[sender.tag];
    
    [self.playerView playWithModel:model];

    
}




@end
