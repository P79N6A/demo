//
//  ViewController.m
//  BackgroundDownloadDemo
//
//  Created by HK on 16/9/10.
//  Copyright © 2016年 hkhust. All rights reserved.
//

#import "ViewController.h"
#import "TTDownloader.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *p2;

@end

@implementation ViewController
- (IBAction)p2:(id)sender {
    
    [TTDownloader.defaultDownloader beginDownload:@"http://sbslive.cnrmobile.com/storage/storage2/51/34/18/3e59db9bb51802c2ef7034793296b724.3gp" fileName:@"jlzg022677" completionHandler:^(CGFloat progress) {
        self.p2.progress = progress;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDownloadProgress:) name:kDownloadProgressNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDownloadProgress:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGFloat fProgress = [userInfo[@"progress"] floatValue];
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",fProgress * 100];
    self.downloadProgress.progress = fProgress;
}

#pragma mark Method
- (IBAction)download:(id)sender {
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [TTDownloader.defaultDownloader beginDownload:@"http://jlzg.cnrmobile.com/resource/index/sp/jlzg0226.mp4" fileName:@"jlzg0226" completionHandler:^(CGFloat progress) {
        NSLog(@"%s---%f", __func__,progress);
    }];
}

- (IBAction)pauseDownlaod:(id)sender {
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [TTDownloader.defaultDownloader pauseDownload:@"http://jlzg.cnrmobile.com/resource/index/sp/jlzg0226.mp4"];
}

- (IBAction)continueDownlaod:(id)sender {
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [TTDownloader.defaultDownloader continueDownload:@"http://jlzg.cnrmobile.com/resource/index/sp/jlzg0226.mp4"];
}

@end
