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
    model.live_stream = [NSURL fileURLWithPath:@"/Users/jay/Downloads/20180503102411_460.mp4"];
    model.live_stream = @"https://vd3.bdstatic.com/mda-iekywrziqr96hr4c/mda-iekywrziqr96hr4c.mp4";
    
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
