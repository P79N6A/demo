//
//  AppDelegate.m
//  BackgroundDownloadDemo
//
//  Created by HK on 16/9/10.
//  Copyright © 2016年 hkhust. All rights reserved.
//

#import "AppDelegate.h"
//#import "NSURLSession+CorrectedResumeData.h"
//
//#define IS_IOS10ORLATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10)
//
//typedef void(^CompletionHandlerType)();

@interface AppDelegate ()
//<NSURLSessionDownloadDelegate>
//
//@property (strong, nonatomic) NSMutableDictionary *completionHandlerDictionary;
////@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
//@property (strong, nonatomic) NSMutableDictionary *downloadTasks;
//
//@property (strong, nonatomic) NSURLSession *backgroundSession;
////@property (strong, nonatomic) NSData *resumeData;
//@property (strong, nonatomic) NSMutableDictionary *resumeDatas;
//@property (strong, nonatomic) NSMutableDictionary *downloadStatus;
//@property (strong, nonatomic) NSMutableArray *awaitURLs;
//
//
//@property (strong, nonatomic) UILocalNotification *localNotification;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    self.completionHandlerDictionary = @{}.mutableCopy;
//    self.backgroundSession = [self backgroundURLSession];
//
//    [self initLocalNotification];
//    // ios8后，需要添加这个注册，才能得到授权
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
//                                                                                 categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//        // 通知重复提示的单位，可以是天、周、月
//        self.localNotification.repeatInterval = 0;
//    } else {
//        // 通知重复提示的单位，可以是天、周、月
//        self.localNotification.repeatInterval = 0;
//    }
//
//    UILocalNotification *localNotification = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    if (localNotification) {
//        [self application:application didReceiveLocalNotification:localNotification];
//    }
    return YES;
}

//- (NSMutableDictionary *)downloadTasks{
//    if (!_downloadTasks) {
//        _downloadTasks = [NSMutableDictionary dictionary];
//    }
//    return _downloadTasks;
//}
//
//- (NSMutableDictionary *)resumeDatas{
//    if (!_resumeDatas) {
//        _resumeDatas = [NSMutableDictionary dictionary];
//    }
//    return _resumeDatas;
//}
//
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
//- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
//    // 你必须重新建立一个后台 seesion 的参照
//    // 否则 NSURLSessionDownloadDelegate 和 NSURLSessionDelegate 方法会因为
//    // 没有 对 session 的 delegate 设定而不会被调用。参见上面的 backgroundURLSession
//    NSURLSession *backgroundSession = [self backgroundURLSession];
//    
//    NSLog(@"Rejoining session with identifier %@ %@", identifier, backgroundSession);
//    
//    // 保存 completion handler 以在处理 session 事件后更新 UI
//    [self addCompletionHandler:completionHandler forSession:identifier];
//}
//
//#pragma mark Save completionHandler
//- (void)addCompletionHandler:(CompletionHandlerType)handler forSession:(NSString *)identifier {
//    if ([self.completionHandlerDictionary objectForKey:identifier]) {
//        NSLog(@"Error: Got multiple handlers for a single session identifier.  This should not happen.\n");
//    }
//    
//    [self.completionHandlerDictionary setObject:handler forKey:identifier];
//}
//
//- (void)callCompletionHandlerForSession:(NSString *)identifier {
//    CompletionHandlerType handler = [self.completionHandlerDictionary objectForKey:identifier];
//    
//    if (handler) {
//        [self.completionHandlerDictionary removeObjectForKey: identifier];
//        NSLog(@"Calling completion handler for session %@", identifier);
//        
//        handler();
//    }
//}
//
//#pragma mark - Local Notification
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下载通知"
//                                                    message:notification.alertBody
//                                                   delegate:nil
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil];
//    [alert show];
//    
//    // 图标上的数字减1
//    application.applicationIconBadgeNumber -= 1;
//}
//
//- (void)applicationWillResignActive:(UIApplication *)application {
//    // 图标上的数字减1
//    application.applicationIconBadgeNumber -= 1;
//}
//
//- (void)initLocalNotification {
//    self.localNotification = [[UILocalNotification alloc] init];
//    self.localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:5];
//    self.localNotification.alertAction = nil;
//    self.localNotification.soundName = UILocalNotificationDefaultSoundName;
//    self.localNotification.alertBody = @"下载完成了！";
//    self.localNotification.applicationIconBadgeNumber = 1;
//    self.localNotification.repeatInterval = 0;
//}
//
//- (void)sendLocalNotification {
//    [[UIApplication sharedApplication] scheduleLocalNotification:self.localNotification];
//}
//
//
//#pragma mark - backgroundURLSession
//- (NSURLSession *)backgroundURLSession {
//    static NSURLSession *session = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSString *identifier = @"com.yourcompany.appId.BackgroundSession";
//        NSURLSessionConfiguration* sessionConfig = nil;
//#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000)
//        sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
//#else
//        sessionConfig = [NSURLSessionConfiguration backgroundSessionConfiguration:identifier];
//#endif
//        session = [NSURLSession sessionWithConfiguration:sessionConfig
//                                                delegate:self
//                                           delegateQueue:[NSOperationQueue mainQueue]];
//    });
//    
//    return session;
//}
//
//#pragma mark - Public Mehtod
//- (BOOL)beginDownload:(NSString *)downloadURLString {
//    
//    if (self.downloadTasks.allKeys.count >= self.maxCount) {
//        [self.awaitURLs addObject:downloadURLString];
//        return NO;
//    }
//
//    
//    NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
//    //cancel last download task
//    [self.downloadTasks[downloadURLString] cancelByProducingResumeData:^(NSData * resumeData) {
//
//    }];
//    
//    self.downloadTasks[downloadURLString] = [self.backgroundSession downloadTaskWithRequest:request];
//    [self.downloadTasks[downloadURLString] resume];
//    
//    self.downloadStatus[downloadURLString] = @(TTDownloaderStateRunning);
//    
//    return YES;
//}
//
//- (void)pauseDownload:(NSString *)downloadURLString {
//    __weak __typeof(self) wSelf = self;
//    [self.downloadTasks[downloadURLString] cancelByProducingResumeData:^(NSData * resumeData) {
//        __strong __typeof(wSelf) sSelf = wSelf;
//        sSelf.resumeDatas[downloadURLString] = resumeData;
//        self.downloadStatus[downloadURLString] = @(TTDownloaderStatePause);
//
//    }];
//}
//
//- (void)continueDownload:(NSString *)downloadURLString {
//    if (self.resumeDatas[downloadURLString]) {
//        if (IS_IOS10ORLATER) {
//            self.downloadTasks[downloadURLString] = [self.backgroundSession downloadTaskWithCorrectResumeData:self.resumeDatas[downloadURLString]];
//        } else {
//            self.downloadTasks[downloadURLString] = [self.backgroundSession downloadTaskWithResumeData:self.resumeDatas[downloadURLString]];
//        }
//        [self.downloadTasks[downloadURLString] resume];
//        [self.resumeDatas removeObjectForKey:downloadURLString];
//        self.downloadStatus[downloadURLString] = @(TTDownloaderStateRunning);
//    }
//}
//- (TTDownloaderState)statusDownload:(NSString *)downloadURLString{
//    return (TTDownloaderState)[[self.downloadStatus valueForKey:downloadURLString] integerValue];
//}
//- (BOOL)isValideResumeData:(NSData *)resumeData
//{
//    if (!resumeData || resumeData.length == 0) {
//        return NO;
//    }
//    return YES;
//}
//
//
//
//#pragma mark - NSURLSessionDownloadDelegate
//- (void)URLSession:(NSURLSession *)session
//      downloadTask:(NSURLSessionDownloadTask *)downloadTask
//didFinishDownloadingToURL:(NSURL *)location {
//    
//  
//    NSLog(@"downloadTask:%lu didFinishDownloadingToURL:%@", (unsigned long)downloadTask.taskIdentifier, location);
//    NSString *locationString = [location path];
//    NSString *finalLocation = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",downloadTask.response.suggestedFilename]];
//    NSError *error;
//    [[NSFileManager defaultManager] moveItemAtPath:locationString toPath:finalLocation error:&error];
//    
//    self.downloadStatus[downloadTask.response.URL.absoluteString] = @(TTDownloaderStateSuccess);
//    [self.downloadTasks removeObjectForKey:downloadTask.response.URL.absoluteString];
//    [self.resumeDatas removeObjectForKey:downloadTask.response.URL.absoluteString];
//    // 用 NSFileManager 将文件复制到应用的存储中
//    // ...
//    if (self.awaitURLs.count) {
//        NSString *url = self.awaitURLs.firstObject;
//        if ([self beginDownload:url]) [self.awaitURLs removeObject:url];
//    }
//    // 通知 UI 刷新
//}
//
//- (void)URLSession:(NSURLSession *)session
//      downloadTask:(NSURLSessionDownloadTask *)downloadTask
// didResumeAtOffset:(int64_t)fileOffset
//expectedTotalBytes:(int64_t)expectedTotalBytes {
//    
//    NSLog(@"fileOffset:%lld expectedTotalBytes:%lld",fileOffset,expectedTotalBytes);
//}
//
//- (void)URLSession:(NSURLSession *)session
//      downloadTask:(NSURLSessionDownloadTask *)downloadTask
//      didWriteData:(int64_t)bytesWritten
// totalBytesWritten:(int64_t)totalBytesWritten
//totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
//    
//    NSLog(@"downloadTask:%lu percent:%.2f%%",(unsigned long)downloadTask.taskIdentifier,(CGFloat)totalBytesWritten / totalBytesExpectedToWrite * 100);
//    NSString *strProgress = [NSString stringWithFormat:@"%.2f",(CGFloat)totalBytesWritten / totalBytesExpectedToWrite];
//    [self postDownlaodProgressNotification:@{@"progress":strProgress,@"key":downloadTask.response.URL.absoluteString}];
//}
//
//- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
//    NSLog(@"Background URL session %@ finished events.\n", session);
//    
//    if (session.configuration.identifier) {
//        // 调用在 -application:handleEventsForBackgroundURLSession: 中保存的 handler
//        [self callCompletionHandlerForSession:session.configuration.identifier];
//    }
//}
//
///*
// * 该方法下载成功和失败都会回调，只是失败的是error是有值的，
// * 在下载失败时，error的userinfo属性可以通过NSURLSessionDownloadTaskResumeData
// * 这个key来取到resumeData(和上面的resumeData是一样的)，再通过resumeData恢复下载
// */
//- (void)URLSession:(NSURLSession *)session
//              task:(NSURLSessionTask *)task
//didCompleteWithError:(NSError *)error {
//    
//    if (error) {
//        // check if resume data are available
//        if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
//            NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
//            //通过之前保存的resumeData，获取断点的NSURLSessionTask，调用resume恢复下载
//            self.resumeDatas[task.response.URL.absoluteString] = resumeData;
//            self.downloadTasks[task.response.URL.absoluteString] = [self.backgroundSession downloadTaskWithResumeData:resumeData];
//            self.downloadStatus[task.response.URL.absoluteString] = @(TTDownloaderStateRunning);
//
//        }
//        self.downloadStatus[task.response.URL.absoluteString] = @(TTDownloaderStateFail);
//        [self.downloadTasks removeObjectForKey:task.response.URL.absoluteString];
//
//    } else {
//        [self sendLocalNotification];
//        [self postDownlaodProgressNotification:@{@"progress":@"1",@"key":task.response.URL.absoluteString}];
//        self.downloadStatus[task.response.URL.absoluteString] = @(TTDownloaderStateSuccess);
//        [self.downloadTasks removeObjectForKey:task.response.URL.absoluteString];
//        [self.resumeDatas removeObjectForKey:task.response.URL.absoluteString];
//    }
//    
//    if (self.awaitURLs.count) {
//        NSString *url = self.awaitURLs.firstObject;
//        if ([self beginDownload:url]) [self.awaitURLs removeObject:url];
//    }
//}
//
//- (void)postDownlaodProgressNotification:(NSDictionary *)userInfo {
//    //NSDictionary *userInfo = @{@"progress":strProgress,};
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadProgressNotification object:nil userInfo:userInfo];
//    });
//}
@end
