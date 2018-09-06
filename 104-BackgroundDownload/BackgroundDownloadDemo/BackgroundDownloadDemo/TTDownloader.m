//
//  TTDownloader.m
//  BackgroundDownloadDemo
//
//  Created by Jay on 6/9/18.
//  Copyright © 2018年 hkhust. All rights reserved.
//

#import "TTDownloader.h"
#import "NSURLSession+CorrectedResumeData.h"

#define IS_IOS10ORLATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10)
typedef void(^CompletionHandlerType)();
typedef void(^CompletionDictType)(CGFloat);

static TTDownloader *_downloader;

@interface TTDownloader()<NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSMutableDictionary *downloadTasks;
@property (strong, nonatomic) NSURLSession *backgroundSession;
@property (strong, nonatomic) NSMutableDictionary *resumeDatas;
@property (strong, nonatomic) NSMutableArray *awaitURLs;
@property (strong, nonatomic) NSMutableDictionary *completionHandlerDictionary;
@property (strong, nonatomic) NSMutableDictionary *completionDict;
@property (nonatomic, strong) NSMutableArray *finishTasksDict;
@property (nonatomic, strong) NSMutableDictionary *downloadSourcesDict;

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

- (NSArray<TTDownloadModel *> *)downloadSources{
    
    NSMutableArray *tasks = [NSMutableArray array];
    NSArray *objs = _downloadSourcesDict.allValues;
    [objs enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TTDownloadModel *model = [TTDownloadModel new];
        [model setValuesForKeysWithDictionary:obj];
        [tasks addObject:model];
    }];
    return tasks;
}
- (NSMutableDictionary *)downloadSourcesDict{
    if (!_downloadSourcesDict) {
        _downloadSourcesDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"downloadSourcesDict"].mutableCopy;
        if (!_downloadSourcesDict) {
            _downloadSourcesDict = [NSMutableDictionary dictionary];
        }
    }
    return _downloadSourcesDict;
}

- (NSMutableArray<TTDownloadModel *> *)finishTasks{
    if (!_finishTasks) {
        _finishTasks = [NSMutableArray array];
        _finishTasksDict = [NSMutableArray array];
        NSArray * objs = [[NSUserDefaults standardUserDefaults] arrayForKey:@"finishTasks"];
        [objs enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TTDownloadModel *model = [TTDownloadModel new];
            [model setValuesForKeysWithDictionary:obj];
            NSString *finalLocation = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",model.localURL]];
            model.localURL = finalLocation;

            [_finishTasks addObject:model];
        }];
        [_finishTasksDict addObjectsFromArray:objs];
    }
    return _finishTasks;
}

- (NSMutableDictionary *)completionHandlerDictionary{
    if (!_completionHandlerDictionary) {
        _completionHandlerDictionary = [NSMutableDictionary dictionary];
    }
    return _completionHandlerDictionary;
}

- (NSMutableDictionary *)completionDict{
    if (!_completionDict) {
        _completionDict = [NSMutableDictionary dictionary];
    }
    return _completionDict;
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
- (NSMutableArray *)awaitURLs{
    if (!_awaitURLs) {
        _awaitURLs = [NSMutableArray array];
    }
    return _awaitURLs;
}



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
- (BOOL)beginDownload:(NSString *)downloadURLString
             fileName:(NSString *)name
    completionHandler:(void (^)(CGFloat progress))completionHandler{
    
    self.completionDict[downloadURLString] = completionHandler;
    
    if (self.downloadTasks.allKeys.count >= self.maxCount) {
        [self.awaitURLs addObject:@{@"url":downloadURLString,@"name":name}];
        return NO;
    }
    
    
    NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    //cancel last download task
    [self.downloadTasks[downloadURLString] cancelByProducingResumeData:^(NSData * resumeData) {
        
    }];
    
    self.downloadTasks[downloadURLString] = [self.backgroundSession downloadTaskWithRequest:request];
    [self.downloadTasks[downloadURLString] resume];
    

    

    NSDictionary *model = @{@"title":name,@"url":downloadURLString,@"status":@(TTDownloaderStateRunning)};
    self.downloadSourcesDict[downloadURLString] = model;
    [[NSUserDefaults standardUserDefaults] setObject:self.downloadSourcesDict forKey:@"downloadSourcesDict"];
    return YES;
}

- (void)pauseDownload:(NSString *)downloadURLString {
    __weak __typeof(self) wSelf = self;
    [self.downloadTasks[downloadURLString] cancelByProducingResumeData:^(NSData * resumeData) {
        __strong __typeof(wSelf) sSelf = wSelf;
        sSelf.resumeDatas[downloadURLString] = resumeData;
        
        NSMutableDictionary *model = self.downloadSourcesDict[downloadURLString];
        model = model.mutableCopy;
        model[@"status"] = @(TTDownloaderStatePause);
        sSelf.downloadSourcesDict[downloadURLString] = model;
        [[NSUserDefaults standardUserDefaults] setObject:self.downloadSourcesDict forKey:@"downloadSourcesDict"];
    }];
}

- (void)continueDownload:(NSString *)downloadURLString {
    if (self.resumeDatas[downloadURLString]) {
        if (IS_IOS10ORLATER) {
            self.downloadTasks[downloadURLString] = [self.backgroundSession downloadTaskWithCorrectResumeData:self.resumeDatas[downloadURLString]];
        } else {
            self.downloadTasks[downloadURLString] = [self.backgroundSession downloadTaskWithResumeData:self.resumeDatas[downloadURLString]];
        }
        [self.downloadTasks[downloadURLString] resume];
        [self.resumeDatas removeObjectForKey:downloadURLString];

        
        NSMutableDictionary *model = self.downloadSourcesDict[downloadURLString];
        model = model.mutableCopy;
        model[@"status"] = @(TTDownloaderStateRunning);
        self.downloadSourcesDict[downloadURLString] = model;
        [[NSUserDefaults standardUserDefaults] setObject:self.downloadSourcesDict forKey:@"downloadSourcesDict"];
    }
}

- (BOOL)isValideResumeData:(NSData *)resumeData
{
    if (!resumeData || resumeData.length == 0) {
        return NO;
    }
    return YES;
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


    NSDictionary *dict = self.downloadSourcesDict[url];
    [self.downloadSourcesDict removeObjectForKey:url];
    [[NSUserDefaults standardUserDefaults] setObject:self.downloadSourcesDict forKey:@"downloadSourcesDict"];

    NSDictionary *info = @{@"localURL":downloadTask.response.suggestedFilename,
                           @"title":dict[@"title"],
                           @"url":url,
                           @"status":@(TTDownloaderStateSuccess)
                           };
    TTDownloadModel *model = [TTDownloadModel new];
    [model setValuesForKeysWithDictionary:info];
    model.localURL = finalLocation;
    
    [self.finishTasks addObject:model];
    [self.finishTasksDict addObject:info];
    [[NSUserDefaults standardUserDefaults] setObject:self.finishTasksDict forKey:@"finishTasks"];
    // ...
    if (self.awaitURLs.count) {
        NSDictionary *obj = self.awaitURLs.firstObject;
        NSString *url = obj[@"url"];
        NSString *name = obj[@"name"];
        CompletionDictType block = self.completionDict[url];

        if ([self beginDownload:url fileName:name completionHandler:block]) [self.awaitURLs removeObject:obj];
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
    [self postDownlaodProgressNotification:@{@"progress":strProgress,@"key":url}];
    
    CompletionDictType block = self.completionDict[url];
    block(strProgress.floatValue);
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

            NSMutableDictionary *model = self.downloadSourcesDict[url];
            model = model.mutableCopy;
            model[@"status"] = @(TTDownloaderStateRunning);
            [[NSUserDefaults standardUserDefaults] setObject:self.downloadSourcesDict forKey:@"downloadSourcesDict"];
            return;
        }
//        self.downloadStatus[task.response.URL.absoluteString] = @(TTDownloaderStateFail);
        [self.downloadTasks removeObjectForKey:url];
        NSMutableDictionary *model = self.downloadSourcesDict[url];
        model = model.mutableCopy;
        model[@"status"] = @(TTDownloaderStateFail);
        [[NSUserDefaults standardUserDefaults] setObject:self.downloadSourcesDict forKey:@"downloadSourcesDict"];
        
    } else {
        [self postDownlaodProgressNotification:@{@"progress":@"1",@"key":url}];
        [self.downloadTasks removeObjectForKey:url];
        [self.resumeDatas removeObjectForKey:url];
    }
    
    if (self.awaitURLs.count) {
        NSDictionary *obj = self.awaitURLs.firstObject;
        NSString *url = obj[@"url"];
        NSString *name = obj[@"name"];
        CompletionDictType block = self.completionDict[url];

        if ([self beginDownload:url fileName:name completionHandler:block]) [self.awaitURLs removeObject:obj];
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
