//
//  ViewController.m
//  player
//
//  Created by FEIWU888 on 2017/10/13.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import "ViewController.h"

#import <BCPlayer.h>

@interface ViewController ()<BCPlayerDelegate>
@property (nonatomic, strong) BCVideoPlayer *play;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _play = [[BCVideoPlayer alloc]init];
    UIView *videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 200)];
    [self.view addSubview:videoView];
    
    

    _play.delegate = self;
    
    [_play playWithUrl:[NSURL URLWithString:@"http://v1-tt.ixigua.com/515d49721f8ac4c077956a0e3bc48ea9/59dedf0f/video/m/220382f200f09cd45c4a07ce85ebd3b5cab1151a2020000545ca9d02764/"]
              showView:videoView
          andSuperView:self.view
             cacheType:NBPlayerCacheTypePlayWithCache];
}



- (void)BCVideoPlayer:(BCVideoPlayer *)player didCompleteWithError:(NSError *)error{
    
}

/**
 返回播放进度
 
 @param player 当前的player
 @param progress 播放进度
 */
- (void)BCVideoPlayer:(BCVideoPlayer *)player withProgress:(double)progress currentTime:(double)current totalTime:(double)totalTime{
    
}

@end
