//
//  AppDelegate.m
//  HotFox
//
//  Created by Jay on 21/6/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "AppDelegate.h"
#import <HotFix/HotFix.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //这个里的js应该是通过同步的方式请求接口得到的，如:
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1/HotFox.js"]];//调用获取修复脚本的接口
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *jss = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];//json[@"hotfix_js"];//这里只是举个例子
    NSString *js = @"fixInstanceMethodReplace('ViewController', 'join:b:', function(instance, originInvocation, originArguments){ \
    if (!originArguments[0] || !originArguments[1]) { \
    console.log('nil goes here'); \
    } else { \
    runInvocation(originInvocation); \
    } \
    });";

    if(jss) {
        [[HotFix shared] fix:jss];
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
