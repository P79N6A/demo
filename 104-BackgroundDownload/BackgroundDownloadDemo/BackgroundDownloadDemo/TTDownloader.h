//
//  TTDownloader.h
//  BackgroundDownloadDemo
//
//  Created by Jay on 6/9/18.
//  Copyright © 2018年 hkhust. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDownloadProgressNotification @"downloadProgressNotification"

typedef NS_ENUM(NSUInteger, TTDownloaderState) {
    TTDownloaderStateUnStart,
    TTDownloaderStateRunning,
    TTDownloaderStatePause,
    TTDownloaderStateFail,
    TTDownloaderStateSuccess,
    TTDownloaderStateAwait
};


@interface TTDownloadModel : NSObject
@property (nonatomic, assign) NSInteger mid;
@property (copy, nonatomic) NSString *localURL;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *title;
@property (nonatomic, assign) TTDownloaderState status;
@end

@interface TTDownloader : NSObject
+ (instancetype)defaultDownloader;

@property (assign, nonatomic) NSInteger maxCount;

- (BOOL)beginDownload:(NSString *)downloadURLString
             fileName:(NSString *)name
             progress:(void (^)(CGFloat progress,NSString *url))progressBlock
                speed:(void (^)(NSString *speed,NSString *url))speedBlock;


- (void)pauseDownload:(NSString *)downloadURLString;
- (void)continueDownload:(NSString *)downloadURLString;

@property (strong, nonatomic) NSArray <TTDownloadModel *>*downloadSources;
/**获取已经完成的下载任务*/
@property (strong, nonatomic) NSMutableArray <TTDownloadModel *>*finishTasks;

@end
