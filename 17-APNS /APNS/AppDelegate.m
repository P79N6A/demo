//
//  AppDelegate.m
//  APNS
//
//  Created by pkss on 2017/5/10.
//  Copyright © 2017年 J. All rights reserved.
//

#import "AppDelegate.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

#pragma mark 3D Touch
- (void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler{
    //照相type
    if ([shortcutItem.type isEqualToString:@"Camera"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.window.rootViewController presentViewController:picker animated:YES completion:nil];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //设置动态标签
    UIApplicationShortcutItem * item = [[UIApplicationShortcutItem alloc] initWithType:@"Home" localizedTitle:@"动态标签" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeHome] userInfo:nil];
    
    //设置动态标签
    UIApplicationShortcutItem * item2 = [[UIApplicationShortcutItem alloc] initWithType:@"Home2" localizedTitle:@"动态标签2" localizedSubtitle:@"4444" icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"icon"] userInfo:nil];
    
    [UIApplication sharedApplication].shortcutItems = @[item,item2];

    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        
        UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center setDelegate:self];
        
        UNAuthorizationOptions type = UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert;
        
        [center requestAuthorizationWithOptions:type completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (granted) {
                
                NSLog(@"注册成功");
                
            }else{
                
                NSLog(@"注册失败");
                
            }
            
        }];
        
        [center getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
            
        }];
        
    }else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        
        UIUserNotificationTypeSound |
        
        UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        
        [application registerUserNotificationSettings:settings];
        
    }else{//ios8一下
        
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        
        UIRemoteNotificationTypeSound |
        
        UIRemoteNotificationTypeAlert;
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
        
    }
    
    // 注册获得device Token
    
    [application registerForRemoteNotifications];
    
    return YES;
}
// 将得到的deviceToken传给SDK

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  
                                  stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                 
                                 stringByReplacingOccurrencesOfString:@">" withString:@""]
                                
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceTokenStr:\n%@",deviceTokenStr);
    
}
// 注册deviceToken失败

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"error -- %@",error);
    
}

//在前台显示ios10
# pragma mark - 前台调用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    NSLog(@"%@", notification.request.content.userInfo);

    completionHandler(UNNotificationPresentationOptionBadge|
                      
                      UNNotificationPresentationOptionSound|
                      
                      UNNotificationPresentationOptionAlert);
}
// ios10
# pragma mark - 前后台杀死点击通知调用

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    //处理推送过来的数据
    
    //[self handlePushMessage:response.notification.request.content.userInfo];
    
    NSLog(@"%@", response.notification.request.content.userInfo);
    
    [self.window addSubview:[UISwitch new]];
    completionHandler();
    
}

//iOS10以下的处理
# pragma mark - 前后台调用（content-available = 1） 优先级低

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //实现你接收到远程推送的消息处理代码；
    NSLog(@"didReceiveRemoteNotification:%@",userInfo);

}
//iOS10以下的处理
# pragma mark - 前后台调用（content-available = 1）优先级高

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary * _Nonnull)userInfo fetchCompletionHandler:(void (^ _Nonnull)(UIBackgroundFetchResult))completionHandler{
    
    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
    
    /*
     
     UIApplicationStateActive 应用程序处于前台
     
     UIApplicationStateBackground 应用程序在后台，用户从通知中心点击消息将程序从后台调至前台
     
     UIApplicationStateInactive 用用程序处于关闭状态(不在前台也不在后台)，用户通过点击通知中心的消息将客户端从关闭状态调至前台
     
     */
    
    //应用程序在前台给一个提示特别消息
    
    if (application.applicationState == UIApplicationStateActive) {
        
        //应用程序在前台
        
//        [self createAlertViewControllerWithPushDict:userInfo];
        
    }else{
        
        //其他两种情况，一种在后台程序没有被杀死，另一种是在程序已经杀死。用户点击推送的消息进入app的情况处理。
        
//        [self handlePushMessage:userInfo];
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
    
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
