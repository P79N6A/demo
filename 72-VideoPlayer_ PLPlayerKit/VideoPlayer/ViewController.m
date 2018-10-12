//
//  ViewController.m
//  VideoPlayer
//
//  Created by Jay on 12/5/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "Player/PlayerView.h"
#import "SpeedMonitor.h"
#include <objc/runtime.h>


@interface ViewController ()
@property (nonatomic, weak) PlayerView *player;
@property (nonatomic, strong) SpeedMonitor *speeder;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    VideoModel *model = [VideoModel new];
    model.title = @"hello tv";
//    model.live_stream = [NSURL fileURLWithPath:@"/Users/jay/Downloads/20180503102411_460.mp4"];
//    model.url = @"http://vip888.kuyun99.com/20180802/wcFfyu0v/index.m3u8?sign=9a2f77b13159249164e257ed7356dab84549a9f7b9a70e5509bc3e0359cdcfd7a258b5708ab7d87677196d08cb14c397bce8db18e488383ddf21376648d73e35";
//    model.live_stream = @"http://e1.vdowowza.vip.hk1.tvb.com/tvblive/smil:mobilehd_financeintl.smil/playlist.m3u8";
//    model.live_stream = @"http://onair.onair.network:8068/listen.pls";
    model.url = @"http://app.zhangwangye.com/mdparse/app.php?id=https://www.iqiyi.com/v_19rrkrbwr433.html3";
    
    PlayerView *player = [PlayerView playerView];
    player.allowSafariPlay = YES;
    player.frame = CGRectMake(0, 64, 320, 200);
    [player playWithModel:model];
    [self.view addSubview:player];
    _player = player;
    
    self.speeder =  [[SpeedMonitor alloc] init];
    [self.speeder startNetworkSpeedMonitor];
}
- (IBAction)living:(id)sender {
    VideoModel *model = [VideoModel new];
    model.title = @"hello tv";
    //    model.live_stream = [NSURL fileURLWithPath:@"/Users/jay/Downloads/20180503102411_460.mp4"];
//    model.url = @"http://vip888.kuyun99.com/20180802/wcFfyu0v/index.m3u8?sign=9a2f77b13159249164e257ed7356dab84549a9f7b9a70e5509bc3e0359cdcfd7a258b5708ab7d87677196d08cb14c397bce8db18e488383ddf21376648d73e35";
    model.url = @"http://m.567it.com/jade.m3u8";
//    model.url = @"http://onair.onair.network:8068/listen.pls";
    
    [_player playWithModel:model];
}

- (IBAction)video:(id)sender {
    VideoModel *model = [VideoModel new];
    model.title = @"hello tv";
    //    model.live_stream = [NSURL fileURLWithPath:@"/Users/jay/Downloads/20180503102411_460.mp4"];
    model.url = @"http://vip888.kuyun99.com/20180802/wcFfyu0v/index.m3u8?sign=9a2f77b13159249164e257ed7356dab84549a9f7b9a70e5509bc3e0359cdcfd7a258b5708ab7d87677196d08cb14c397bce8db18e488383ddf21376648d73e35";
    //    model.live_stream = @"http://e1.vdowowza.vip.hk1.tvb.com/tvblive/smil:mobilehd_financeintl.smil/playlist.m3u8";
    //    model.live_stream = @"http://onair.onair.network:8068/listen.pls";
    
    [_player playWithModel:model];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.spStatusBarHidden = !self.spStatusBarHidden;
//    self.spStatusBarStyle = !self.spStatusBarStyle;
    return;
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    
    NSArray *allApplications = [workspace performSelector:@selector(allApplications)];//这样就能获取到手机中安装的所有App
    
    NSLog(@"设备上安装的所有app:%@",allApplications);    NSInteger zlConnt = 0;
    
    for (NSString *appStr in allApplications) {
        
              NSString *app = [NSString stringWithFormat:@"%@",appStr];//转换成字符串
        
                NSRange range = [app rangeOfString:@"你要查询App的bundle ID"];//是否包含这个bundle ID
        
                 if (range.length > 1) {
            
                            zlConnt ++;
            
                     }
        
           }
    
       if (zlConnt >= 1) {
        
                NSLog(@"已安装");
        
            }

}

@end
