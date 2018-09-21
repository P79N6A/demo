//
//  SPExceptionHandler.m
//  SPExceptionHandler
//
//  Created by Jay on 21/9/18.
//  Copyright © 2018年 SP. All rights reserved.
//

#import "SPExceptionHandler.h"
#import <UIKit/UIKit.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@interface SPExceptionHandler ()
{
    BOOL dismissed;
    NSString *_message_exception;
}

@end

BOOL finish;

@implementation SPExceptionHandler

+ (void)load{
    InstallUncaughtExceptionHandler();
}

+ (instancetype)defaultHandler {
    static SPExceptionHandler *single = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[self alloc]init];
        single.isShowExceptionMessage = YES;
        single.isShowAlertView = YES;
        // 1.获取Documents路径
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        // 2.创建文件路径
        NSString *filePath = [docPath stringByAppendingPathComponent:@"ExceptionLog_sp.txt"];
        // 3.使用文件管理对象创建文件
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:filePath]) {
            [fileManager createFileAtPath:filePath contents:[@">>>>>>>程序异常日志<<<<<<<<\n" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }
        single.exceptionFilePath = filePath;
    });
    return single;
}

+ (NSArray *)backtrace {
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = UncaughtExceptionHandlerSkipAddressCount; i < UncaughtExceptionHandlerSkipAddressCount + UncaughtExceptionHandlerReportAddressCount; i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
// 被夹在这中间的代码针对于此警告都会无视并且不显示出来
- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex {
    if (anIndex == 0) {
        dismissed = YES;
    }else if (anIndex==1) {
        //继续
        !(_doBlock)? : _doBlock(_message_exception);
    }
}
- (void)validateAndSaveCriticalApplicationData:(NSException *)exception {
    NSString *exceptionMessage = [NSString stringWithFormat:NSLocalizedString(@"\n********** %@ 异常原因如下: **********\n%@\n%@\n========== End ==========\n", nil), [self currentTimeString], [exception reason], [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]];
    // 4.创建文件对接对象,文件对象此时针对文件，可读可写
    NSFileHandle *handle = [NSFileHandle fileHandleForUpdatingAtPath:_exceptionFilePath];
    [handle seekToEndOfFile];
    [handle writeData:[exceptionMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
    //NSLog(@"%@", filePath);
    !(_logHandleBlock)? : _logHandleBlock(_exceptionFilePath);

}
- (void)handleException:(NSException *)exception {
    [self validateAndSaveCriticalApplicationData:exception];
    if (_isShowExceptionMessage) {
        _alertViewMessage = [NSString stringWithFormat:NSLocalizedString(@"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开\n\n" @"异常原因如下:\n%@\n%@", nil), [exception reason], [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]];
    }else {
        _alertViewMessage = _alertViewMessage? _alertViewMessage : [NSString stringWithFormat:NSLocalizedString(@"\n如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开\n", nil)];
    }
    NSString *titleStr = nil;
    if (_alertViewTitle) {
        titleStr = _alertViewTitle;
    }else {
        titleStr = NSLocalizedString(@"抱歉，程序出现了异常", nil);
    }
    _message_exception = [NSString stringWithFormat:NSLocalizedString(@"异常原因如下:\n%@\n%@", nil), [exception reason], [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:_alertViewMessage delegate:self cancelButtonTitle:NSLocalizedString(@"退出", nil) otherButtonTitles:NSLocalizedString(@"继续", nil), nil];
    //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉，程序出现了异常" message:[NSString stringWithFormat:@"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开\n\n" @"异常原因如下:\n%@\n%@", [exception reason], [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]] delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"继续", nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_isShowAlertView) {
            [alert show];
        }else {
            if (finish) {
                dismissed = YES;
            }
        }
    });
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    while (!dismissed){
        for (NSString *mode in (__bridge NSArray *)allModes) {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    CFRelease(allModes);
#pragma clang diagnostic pop
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    }else{
        [exception raise];
    }
}

- (NSString *)currentTimeString {
    //时间格式化
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

@end


void HandleException(NSException *exception) {
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    NSArray *callStack = [SPExceptionHandler backtrace];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [[SPExceptionHandler defaultHandler] performSelectorOnMainThread:@selector(handleException:) withObject: [NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo] waitUntilDone:YES];
}
void SignalHandler(int signal) {
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    NSArray *callStack = [SPExceptionHandler backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [[SPExceptionHandler defaultHandler] performSelectorOnMainThread:@selector(handleException:) withObject: [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName reason: [NSString stringWithFormat: NSLocalizedString(@"Signal %d was raised.", nil), signal] userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey]] waitUntilDone:YES];
}
SPExceptionHandler* InstallUncaughtExceptionHandler(void) {
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
    return [SPExceptionHandler defaultHandler];
}
void teste(){
    
}
void ExceptionHandlerFinishNotify() {
    finish =YES;
}
