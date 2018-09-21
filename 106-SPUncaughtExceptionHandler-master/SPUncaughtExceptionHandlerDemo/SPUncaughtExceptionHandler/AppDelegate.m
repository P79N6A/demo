//
//  AppDelegate.m
//  SPUncaughtExceptionHandler
//
//  Created by 康世朋 on 16/8/10.
//  Copyright © 2016年 SP. All rights reserved.
//

#import "AppDelegate.h"
#import "SPExceptionHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return YES;
    // 默认样式
    SPExceptionHandler *exceptionHandler = [SPExceptionHandler defaultHandler];
    exceptionHandler.isShowAlertView = YES;
    exceptionHandler.isShowExceptionMessage = NO;
    exceptionHandler.alertViewTitle = @"抱歉，程序出现了异常，请联系我们";
    exceptionHandler.alertViewMessage = @"如果需要自定义message，须将isShowExceptionMessage设置为NO";
    
    exceptionHandler.logHandleBlock = ^(NSString *logFilePath) {
                //path：日志文件的路径，日志是一个名字为“ExceptionLog_sp”的“txt”文件
                //也可用这种方法获得路径：[[SPUncaughtExceptionHandler shareInstance]exceptionFilePath]
                //每次异常都会调用该block
        
                NSLog(@"%@",logFilePath);
                //模拟耗时操作
                //[NSThread sleepForTimeInterval:2.0];
        
                UISwitch *sw = [UISwitch new];
                sw.tintColor = [UIColor redColor];
                [self.window addSubview:sw];
                //处理完成后调用（如果不调用则程序不会退出）主要是为了处理耗时操作
                ExceptionHandlerFinishNotify();
    };
    exceptionHandler.doBlock = ^(NSString *message) {
                //点击（继续）后的处理，比如将崩溃信息上传到服务器，该字符串为：异常信息
                NSLog(@"%@",message);
                UISwitch *sw = [UISwitch new];
                sw.center = CGPointMake(100, 100);
                sw.tintColor = [UIColor orangeColor];
                [self.window addSubview:sw];
    };
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
