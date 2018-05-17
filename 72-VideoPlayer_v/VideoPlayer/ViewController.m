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
    model.url = [NSURL fileURLWithPath:@"/Users/jay/Downloads/20180503102411_460.mp4"];
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
