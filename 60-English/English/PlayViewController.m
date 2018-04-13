
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
    
    //[self sw:sw];
    
    NSString *url = [self.dics[self.selectIndex] valueForKey:@"url"];
    Model <TTZPlayerModel>*m = [Model new];
    m.name = [self.dics[self.selectIndex] valueForKey:@"title"];
    m.url = [url containsString:@"m3u8"]? url : [NSString stringWithFormat:@"http://app.zhangwangye.com/mdparse/app.php?id=%@",url];
    [self.movieView playWithModel:m];

}

- (BOOL)prefersStatusBarHidden{
    return self.movieView.prefersStatusBarHidden;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}


@end
