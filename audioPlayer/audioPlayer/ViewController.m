//
//  ViewController.m
//  audioPlayer
//
//  Created by Jayson on 2018/7/26.
//  Copyright © 2018年 Jayson. All rights reserved.
//

#import "ViewController.h"

#import "AudioPlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [AudioPlayer.player playWithURL:@"https://www3.laqddc.com/hls/2018/04/14/Zi5nffZA/playlist.m3u8"];
}

@end
