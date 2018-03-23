//
//  ViewController.m
//  avplayer
//
//  Created by Jay on 2018/3/23.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
/** <##> */
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    NSURL *url = [NSURL URLWithString:@"http://v.91kds.com/b9/bst1.m3u8?id=szwshd&nwtime=1521791023&sign=5c058e64a0e8ffc6b2b74de8ef60c61b&mip=113.111.49.151&from=net"];
    
    
    //防盗链
    NSMutableDictionary * headers = [NSMutableDictionary dictionary];
    [headers setObject:@"http://m.91kds.net/"forKey:@"Referer"];
    
    
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:@{@"AVURLAssetHTTPHeaderFieldsKey" : headers}];
    
    
    // 初始化playerItem
    AVPlayerItem *playerItem  = [AVPlayerItem playerItemWithAsset:urlAsset];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];

    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = CGRectMake(0, 0, 375, 200);
    [self.view.layer addSublayer:playerLayer];

    [self.player play];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
