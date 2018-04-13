
//
//  PlayViewController.m
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "PlayViewController.h"
#import "PlayerView.h"
#import "Model.h"

@interface PlayViewController ()
@property (nonatomic, strong) PlayerView *movieView;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISwitch *sw = [UISwitch new];
    [self.view addSubview:sw];
    sw.center = self.view.center;
    [sw addTarget:self action:@selector(sw:) forControlEvents:UIControlEventValueChanged];
    
    self.movieView = [PlayerView playerView];
    self.movieView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 200);
    [self.view addSubview:self.movieView];
//
//    Model <TTZPlayerModel>*m = [Model new];
//    m.name = @"AAAA";
//    m.url = @"http://v3.yongjiujiexi.com/20180326/DXLLmpUI/index.m3u8";//
//    m.url = @"http://acm.gg/j.m3u8";
    
     __weak typeof(self) weakSelf = self;
    self.movieView.statusBarAppearanceUpdate = ^() {
        [weakSelf setNeedsStatusBarAppearanceUpdate];
    };
    //[self.movieView playWithModel:m];
    
    [self sw:sw];
    
}

- (void)sw:(UISwitch *)sender{
    
    Model <TTZPlayerModel>*m = [Model new];
    m.name = @"AAAA";
    m.url = sender.isOn? @"http://v3.yongjiujiexi.com/20180326/DXLLmpUI/index.m3u8" : @"http://acm.gg/j.m3u8";//
    //m.url = @"http://acm.gg/j.m3u8";
    [self.movieView playWithModel:m];

}

- (BOOL)prefersStatusBarHidden{
    return self.movieView.prefersStatusBarHidden;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}


@end
