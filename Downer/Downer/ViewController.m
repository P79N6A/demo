//
//  ViewController.m
//  Downer
//
//  Created by Jay on 16/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

#import "YCDownloadManager.h"

@interface ViewController ()<YCDownloadItemDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)esume:(id)sender {
    YCDownloadItem *item = [[YCDownloadItem alloc] initWithUrl:@"https://codeload.github.com/easyui/EZPlayer/zip/master" fileId:nil];
    item.delegate = self;
    item.enableSpeed = YES;
    [YCDownloadManager resumeDownloadWithItem:item];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)start:(id)sender {
    YCDownloadItem *item = [[YCDownloadItem alloc] initWithUrl:@"https://codeload.github.com/easyui/EZPlayer/zip/master" fileId:nil];
    item.delegate = self;
    item.enableSpeed = YES;
    [YCDownloadManager startDownloadWithItem:item];
}


- (void)downloadItemStatusChanged:(YCDownloadItem *)item{
    NSLog(@"downloadItemStatus:%lu,savePath:%@",(unsigned long)item.downloadStatus,item.savePath);
}
- (void)downloadItem:(YCDownloadItem *)item downloadedSize:(int64_t)downloadedSize totalSize:(int64_t)totalSize{
    NSLog(@"progress:%f", 1.0 * downloadedSize/totalSize);

}
- (void)downloadItem:(YCDownloadItem *)item speed:(NSUInteger)speed speedDesc:(NSString *)speedDesc{
    NSLog(@"speed:%lu,speedDesc:%@",speed,speedDesc);
    
}


- (IBAction)pause:(id)sender {
    YCDownloadItem *item = [[YCDownloadItem alloc] initWithUrl:@"https://codeload.github.com/easyui/EZPlayer/zip/master" fileId:nil];
    item.delegate = self;
    item.enableSpeed = YES;
    [YCDownloadManager pauseDownloadWithItem:item];

}


@end
