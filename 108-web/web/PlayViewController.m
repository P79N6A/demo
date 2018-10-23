//
//  PlayViewController.m
//  web
//
//  Created by Jay on 23/10/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "PlayViewController.h"

#import "Player/PlayerView.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PlayerView *player = [PlayerView playerView];
    player.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.width * 9/16.0);
    player.allowSafariPlay = YES;
    
    [self.view addSubview:player];
    
    VideoModel *model = [VideoModel new];
    model.title = self.title;
    model.url = self.url;
    
    [player playWithModel:model];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
