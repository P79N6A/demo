//
//  ViewController.m
//  iqy
//
//  Created by Jay on 27/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "SPIQYVideo.h"

#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)go:(id)sender {
    
    [[SPIQYVideo sharedVideo] playWithURL:@"http://www.iqiyi.com/w_19rqzv5n11.html?list=19rrmvbt0e" completion:^(NSString *url) {
        if(!url) return ;
        MPMoviePlayerViewController *playVC = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:url]];
        playVC.view.frame = CGRectMake(0, 100, 414, 300);
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playVC animated:YES completion:nil];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
