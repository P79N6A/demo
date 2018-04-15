//
//  ViewController.m
//  amr->wav
//
//  Created by czljcb on 2017/6/27.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "ViewController.h"
#import "amrFileCodec.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        
        NSData *amrData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://img.11yuehui.com/yl/voice/100259/14963979284471.mp3"]];
        NSData *data = DecodeAMRToWAVE(amrData);
        [data writeToFile:@"users/czljcb/desktop/cz.wav" atomically:YES];

        if (_audioPlayer) {
            [_audioPlayer stop];
            _audioPlayer = nil;
        }
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
        
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
        
    });
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
