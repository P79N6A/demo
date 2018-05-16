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
    model.url = @"http://127.0.0.1/api/yy.php?id=78678200";
    model.url = @"http://125.74.12.48/78dda3f83909dc934ee94d8c29414c8b.m3u8?type=phone.ios&key=f819d9800ba3959e041049b2baad069e&k=025943b2e0a6d1680274bbeea082dee2-8d9b-1526108754";
    
    PlayerView *player = [PlayerView playerView];
    player.frame = CGRectMake(0, 0, 375, 200);
    [player playWithModel:model];
    [self.view addSubview:player];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
