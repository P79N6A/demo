//
//  ViewController.m
//  avplayer
//
//  Created by Jay on 2018/3/23.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()
/** <##> */
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    NSURL *url = [NSURL URLWithString:@"http://111.223.51.7:8000/listen.pls?sid=1"];
    
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSURL *url = [NSURL URLWithString:@"http://111.223.51.7:8000/listen.pls?sid=1"];
    MPMoviePlayerController *vc = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [self.view addSubview:vc.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
