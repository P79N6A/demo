//
//  TTDownloader.m
//  BackgroundDownloadDemo
//
//  Created by Jay on 6/9/18.
//  Copyright © 2018年 hkhust. All rights reserved.
//

#import "TTDownloader.h"
#import "NSURLSession+CorrectedResumeData.h"
#import "NSObject+DB.h"

#define IS_IOS10ORLATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10)
typedef void(^CompletionHandlerType)(void);
typedef void(^ProgressHandlerType)(CGFloat,NSString*);
typedef void(^SpeedHandlerType)(NSString*,NSString*);

static TTDownloader *_downloader;

@interface TTDownloader()<NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSMutableDictionary *downloadTasks;
@property (strong, nonatomic) NSURLSession *backgroundSession;
@property (strong, nonatomic) NSMutableDictionary *resumeDatas;
@property (strong, nonatomic) NSMutableDictionary *completionHandlerDictionary;
@property (strong, nonatomic) NSMutableDictionary *progressBlockDict;
@property (strong, nonatomic) NSMutableDictionary *speedBlockDict;
@property (strong, nonatomic) NSMutableDictionary *speedDict;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation TTDownloader
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloader = [super allocWithZone:zone];
    });
    return _downloader;
}
+ (instancetype)defaultDownloader{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloader = [[self alloc] init];
        
    });
    return _downloader;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _maxCount = 3;
    }
    return self;
}

- (NSURLSession *)backgroundSession{
    if (!_backgroundSession) {
        _backgroundSession = [self backgroundURLSession];
    }
    return _backgroundSession;
}

- (NSTimer *)timer{
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(upDateSpeed) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}
- (void)upDateSpeed{
    [self.downloadTasks.allKeys enumerateObjectsUsingBlock:^(NSString * url, NSUInteger idx, BOOL * _Nonnull stop) {
        SpeedHandlerType speedBlock = self.speedBlockDict[url];
        
        NSMutableDictionary *speedValue = self.speedDict[url];
      
        
        NSInteger speed = [speedValue[@"now"] integerValue] - [speedValue[@"last"] integerValue];
        NSNumber *nowBytes = [speedValue valueForKey:@"now"];
        speedValue[@"last"] = nowBytes;
        
        !(speedBlock)? : speedBlock([self speedString:speed],url);

    }];
}

- (NSArray<TTDownloadModel *> *)downloadSources{
    NSArray *downloadModels = [TTDownloadModel findWhere:[NSString stringWithFormat:@"where status != %lu",(unsigned long)TTDownloaderStateSuccess]];
    return downloadModels;
}

- (NSMutableArray<TTDownloadModel *> *)finishTasks{
    NSArray *downloadModels = [TTDownloadModel findWhere:[NSString stringWithFormat:@"where status = %lu",(unsigned long)TTDownloaderStateSuccess]];
    
    
    return downloadModels.mutableCopy;
}

- (NSMutableDictionary *)completionHandlerDictionary{
    if (!_completionHandlerDictionary) {
        _completionHandlerDictionary = [NSMutableDictionary dictionary];
    }
    return _completionHandlerDictionary;
}

- (NSMutableDictionary *)progressBlockDict{
    if (!_progressBlockDict) {
        _progressBlockDict = [NSMutableDictionary dictionary];
    }
    return _progressBlockDict;
}
- (NSMutableDictionary *)speedBlockDict{
    if (!_speedBlockDict) {
        _speedBlockDict = [NSMutableDictionary dictionary];
    }
    return _speedBlockDict;
}
- (NSMutableDictionary *)speedDict{
    if (!_speedDict) {
        _speedDict = [NSMutableDictionary dictionary];
    }
    return _speedDict;
}
- (NSMutableDictionary *)downloadTasks{
    if (!_downloadTasks) {
        _downloadTasks = [NSMutableDictionary dictionary];
    }
    return _downloadTasks;
}

- (NSMutableDictionary *)resumeDatas{
    if (!_resumeDatas) {
        _resumeDatas = [NSMutableDictionary dictionary];
    }
    return _resumeDatas;
}

//- (NSMutableDictionary *)downloadStatus{
//    if (!_downloadStatus) {
//        _downloadStatus = [NSMutableDictionary dictionary];
//    }
//    return _downloadStatus;
//}
//- (NSMutableArray *)awaitURLs{
//    if (!_awaitURLs) {
//        _awaitURLs = [NSMutableArray array];
//    }
//    return _awaitURLs;
//}



- (void)callCompletionHandlerForSession:(NSString *)identifier {
    CompletionHandlerType handler = [self.completionHandlerDictionary objectForKey:identifier];
    
    if (handler) {
        [self.completionHandlerDictionary removeObjectForKey: identifier];
        NSLog(@"Calling completion handler for session %@", identifier);
        
        handler();
    }
}



#pragma mark - backgroundURLSession
- (NSURLSession *)backgroundURLSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *identifier = @"com.yourcompany.appId.BackgroundSession";
        NSURLSessionConfiguration* sessionConfig = nil;
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000)
        sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
#else
        sessionConfig = [NSURLSessionConfiguration backgroundSessionConfiguration:identifier];
#endif
        session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                delegate:self
                                           delegateQueue:[NSOperationQueue mainQueue]];
    });
    
    return session;
}

#pragma mark - Public Mehtod


/**
 //FIXME:  -  开始下载

 @param downloadURLString 资源URL
 @param name 文件名称
 @param progressBlock 下载进度
 @param speedBlock 下载网速
 @return 是否处理成功
 */
- (BOOL)beginDownload:(NSString *)downloadURLString
             fileName:(NSString *)name
             progress:(void (^)(CGFloat progress,NSString *url))progressBlock
                speed:(void (^)(NSString *speed,NSString *url))speedBlock{

     TTDownloadModel *downloadModel = [TTDownloadModel findWhere:[NSString stringWithFormat:@"where url = '%@'",downloadURLString]].firstObject;
    // 下载中 或者 下载完毕
    BOOL isExist = ([self.downloadTasks.allKeys containsObject:downloadURLString] &&  downloadModel.status == TTDownloaderStateRunning) || (downloadModel.status == TTDownloaderStateSuccess);
    
    if (isExist) {
        return NO;
    }

    downloadModel = downloadModel? downloadModel : [TTDownloadModel new];
    downloadModel.title = name;
    downloadModel.url = downloadURLString;
    downloadModel.status = TTDownloaderStateRunning;
    
    if(progressBlock) self.progressBlockDict[downloadURLString] = progressBlock;
    if(speedBlock) self.speedBlockDict[downloadURLString] = speedBlock;
    
    if (self.downloadTasks.count >= self.maxCount) {
        downloadModel.status = TTDownloaderStateAwait;
        [downloadModel saveOrUpdate];
        return NO;
    }
    
    [downloadModel saveOrUpdate];
    
    NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    //cancel last download task
    [self.downloadTasks[downloadURLString] cancelByProducingResumeData:^(NSData * resumeData) {
        NSLog(@"%s", __func__);
    }];
    
    self.downloadTasks[downloadURLString] = [self.backgroundSession downloadTaskWithRequest:request];
    [self.downloadTasks[downloadURLString] resume];
    [self timer];
    return YES;
}


/**
 //FIXME:  -  暂停下载

 @param downloadURLString 资源URL
 */
- (void)pauseDownload:(NSString *)downloadURLString {
    __weak __typeof(self) wSelf = self;
    [self.downloadTasks[downloadURLString] cancelByProducingResumeData:^(NSData * resumeData) {
        __strong __typeof(wSelf) sSelf = wSelf;
        sSelf.resumeDatas[downloadURLString] = resumeData;
        TTDownloadModel *downloadModel = [TTDownloadModel findWhere:[NSString stringWithFormat:@"where url = '%@'",downloadURLString]].firstObject;
        downloadModel.status = TTDownloaderStatePause;
        [downloadModel update];
    }];
}
/**
 //FIXME:  -  继续下载
 
 @param downloadURLString 资源URL
 */
- (void)continueDownload:(NSString *)downloadURLString {
    if (self.resumeDatas[downloadURLString]) {
        if (IS_IOS10ORLATER) {
            self.downloadTasks[downloadURLString] = [self.backgroundSession downloadTaskWithCorrectResumeData:self.resumeDatas[downloadURLString]];
        } else {
            self.downloadTasks[downloadURLString] = [self.backgroundSession downloadTaskWithResumeData:self.resumeDatas[downloadURLString]];
        }
        [self.downloadTasks[downloadURLString] resume];
        [self.resumeDatas removeObjectForKey:downloadURLString];
        [self timer];
        TTDownloadModel *downloadModel = [TTDownloadModel findWhere:[NSString stringWithFormat:@"where url = '%@'",downloadURLString]].firstObject;
        downloadModel.status = TTDownloaderStateRunning;
        [downloadModel update];
    }
}

- (BOOL)isValideResumeData:(NSData *)resumeData
{
    if (!resumeData || resumeData.length == 0) {
        return NO;
    }
    return YES;
}

- (NSString *)speedString:(NSInteger)speed{
    NSString *speedStr = nil;
    if (speed >= 0 && speed < 1024) {
        //B
        speedStr = [NSString stringWithFormat:@"下载速度为：%ldb/s", (long)speed];
    } else if (speed >= 1024 && speed < 1024 * 1024) {
        //KB
        speedStr = [NSString stringWithFormat:@"下载速度为：%.2lfkb/s", (long)speed / 1024.0];
    } else if (speed >= 1024 * 1024) {
        //MB
        speedStr = [NSString stringWithFormat:@"下载速度为：%.2lfmb/s", (long)speed / 1024.0 / 1024.0];
    }
    
    NSLog(@"文件：%@的下载速度：%@", @"",speedStr);
    return speedStr;
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    
    NSLog(@"downloadTask:%lu didFinishDownloadingToURL:%@", (unsigned long)downloadTask.taskIdentifier, location);
    NSString *locationString = [location path];
    NSString *finalLocation = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",downloadTask.response.suggestedFilename]];
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:locationString toPath:finalLocation error:&error];
    
    NSString *url = downloadTask.originalRequest.URL.absoluteString;

    [self.downloadTasks removeObjectForKey:url];
    [self.resumeDatas removeObjectForKey:url];
    // 用 NSFileManager 将文件复制到应用的存储中

    TTDownloadModel *downloadModel = [TTDownloadModel findWhere:[NSString stringWithFormat:@"where url = '%@'",url]].firstObject;
    downloadModel.status = TTDownloaderStateSuccess;
    downloadModel.localURL = downloadTask.response.suggestedFilename;
    [downloadModel update];


    // ...
    NSArray *awaitTasks = [TTDownloadModel findWhere:[NSString stringWithFormat:@"where status = %lu",(unsigned long)TTDownloaderStateAwait]];

    if (awaitTasks.count) {

        TTDownloadModel *model = awaitTasks.firstObject;
        ProgressHandlerType block = self.progressBlockDict[url];
        SpeedHandlerType speedBlock = self.speedBlockDict[url];

        [self beginDownload:model.url fileName:model.title progress:block speed:speedBlock];
    }
    // 通知 UI 刷新
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    
    NSLog(@"fileOffset:%lld expectedTotalBytes:%lld",fileOffset,expectedTotalBytes);
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    NSLog(@"downloadTask:%lu percent:%.2f%%",(unsigned long)downloadTask.taskIdentifier,(CGFloat)totalBytesWritten / totalBytesExpectedToWrite * 100);
    NSString *strProgress = [NSString stringWithFormat:@"%.2f",(CGFloat)totalBytesWritten / totalBytesExpectedToWrite];
    NSString *url = downloadTask.originalRequest.URL.absoluteString;

    NSMutableDictionary *speedDict = self.speedDict[url];
    speedDict = speedDict.mutableCopy;
    if (speedDict) {
        speedDict[@"now"] = @(totalBytesWritten);
    }else{
        speedDict = [NSMutableDictionary dictionary];
        speedDict[@"last"] = @(0);
        speedDict[@"now"] = @(totalBytesWritten);
    }
    
    self.speedDict[url] = speedDict;
    
    [self postDownlaodProgressNotification:@{@"progress":strProgress,@"key":url}];
    
    ProgressHandlerType block = self.progressBlockDict[url];
    !(block)? : block(strProgress.floatValue,url);
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSLog(@"Background URL session %@ finished events.\n", session);
    
    if (session.configuration.identifier) {
        // 调用在 -application:handleEventsForBackgroundURLSession: 中保存的 handler
        [self callCompletionHandlerForSession:session.configuration.identifier];
    }
}

/*
 * 该方法下载成功和失败都会回调，只是失败的是error是有值的，
 * 在下载失败时，error的userinfo属性可以通过NSURLSessionDownloadTaskResumeData
 * 这个key来取到resumeData(和上面的resumeData是一样的)，再通过resumeData恢复下载
 */
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    
    NSString *url = task.originalRequest.URL.absoluteString;

    if (error) {
        // check if resume data are available
        if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
            NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
            //通过之前保存的resumeData，获取断点的NSURLSessionTask，调用resume恢复下载
            self.resumeDatas[task.response.URL.absoluteString] = resumeData;
            self.downloadTasks[task.response.URL.absoluteString] = [self.backgroundSession downloadTaskWithResumeData:resumeData];

            TTDownloadModel *downloadModel = [TTDownloadModel findWhere:[NSString stringWithFormat:@"where url = '%@'",url]].firstObject;
            downloadModel.status = TTDownloaderStateFail;
            [downloadModel update];
            
            return;
        }
        
        [self.downloadTasks removeObjectForKey:url];
        TTDownloadModel *downloadModel = [TTDownloadModel findWhere:[NSString stringWithFormat:@"where url = '%@'",url]].firstObject;
        downloadModel.status = TTDownloaderStateFail;
        [downloadModel update];
        
    } else {
        [self postDownlaodProgressNotification:@{@"progress":@"1",@"key":url}];
        [self.downloadTasks removeObjectForKey:url];
        [self.resumeDatas removeObjectForKey:url];
    }
    
    NSArray *awaitTasks = [TTDownloadModel findWhere:[NSString stringWithFormat:@"where status = %lu",(unsigned long)TTDownloaderStateAwait]];

    if (awaitTasks.count) {
            
            TTDownloadModel *model = awaitTasks.firstObject;
            ProgressHandlerType block = self.progressBlockDict[url];
            SpeedHandlerType speedBlock = self.speedBlockDict[url];
        
        [self beginDownload:model.url fileName:model.title progress:block speed:speedBlock];
    }
    
}

- (void)postDownlaodProgressNotification:(NSDictionary *)userInfo {
    //NSDictionary *userInfo = @{@"progress":strProgress,};
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadProgressNotification object:nil userInfo:userInfo];
    });
}


@end

@implementation TTDownloadModel
+(NSString *)primaryKey{return @"mid";}
- (NSString *)localURL{
    NSString *finalLocation = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",_localURL]];
    return finalLocation;
}
@end

@implementation UIApplication (TTDownloader)

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    // 你必须重新建立一个后台 seesion 的参照
    // 否则 NSURLSessionDownloadDelegate 和 NSURLSessionDelegate 方法会因为
    // 没有 对 session 的 delegate 设定而不会被调用。参见上面的 backgroundURLSession
    NSURLSession *backgroundSession = [TTDownloader.defaultDownloader backgroundURLSession];
    
    NSLog(@"Rejoining session with identifier %@ %@", identifier, backgroundSession);
    
    // 保存 completion handler 以在处理 session 事件后更新 UI
    [self addCompletionHandler:completionHandler forSession:identifier];
}

#pragma mark Save completionHandler
- (void)addCompletionHandler:(CompletionHandlerType)handler forSession:(NSString *)identifier {
    if ([TTDownloader.defaultDownloader.completionHandlerDictionary objectForKey:identifier]) {
        NSLog(@"Error: Got multiple handlers for a single session identifier.  This should not happen.\n");
    }
    
    [TTDownloader.defaultDownloader.completionHandlerDictionary setObject:handler forKey:identifier];
}

@end
