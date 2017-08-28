//
//  AppDelegate.m
//  HTTPServer
//
//  Created by pkss on 2017/4/20.
//  Copyright © 2017年 zhangsheng. All rights reserved.
//

#import "AppDelegate.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MyHTTPConnection.h"

@interface AppDelegate ()
@property (nonatomic, strong) HTTPServer * httpServer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _httpServer = [[HTTPServer alloc] init];
    [_httpServer setPort:1234];
    [_httpServer setType:@"_http._tcp."];
    // webPath是server搜寻HTML等文件的路径
    NSString * webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"web"];
    [_httpServer setDocumentRoot:webPath];
    [_httpServer setConnectionClass:[MyHTTPConnection class]];
    NSError *err;
    if ([_httpServer start:&err]) {
        NSLog(@"port %hu",[_httpServer listeningPort]);
    }else{
        NSLog(@"%@",err);
    }
    NSString *ipStr = [self getIpAddresses];
    NSLog(@"ip地址 %@", ipStr);

    
    return YES;
}

- (NSString *)getIpAddresses{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
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
