//
//  AppDelegate.m
//  GDTMobDemo
//
//  Created by Jay on 21/5/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "AppDelegate.h"
#import "GDTMob.h"

#import <GDTMobSDK/GDTSDKConfig.h>
#import <GDTMobSDK/GDTSplashAd.h>

static NSString *kGDTMobSDKAppId = @"1105344611";
#define IS_IPHONEX (([[UIScreen mainScreen] nativeBounds].size.height-2436)?NO:YES)


@interface AppDelegate ()<GDTSplashAdDelegate>

@property (strong, nonatomic) GDTSplashAd *splash;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [GDTMob loadLaunchAD];
    
//    [GDTSDKConfig setHttpsOn];
//    //开屏广告初始化并展示代码
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//    {
//        GDTSplashAd *splash = [[GDTSplashAd alloc] initWithAppId:kGDTMobSDKAppId placementId:@"9040714184494018"];
//        splash.delegate = self;
//        UIImage *splashImage = [UIImage imageNamed:@"SplashNormal"];
//        if (IS_IPHONEX) {
//            splashImage = [UIImage imageNamed:@"SplashX"];
//        } else if ([UIScreen mainScreen].bounds.size.height == 480) {
//            splashImage = [UIImage imageNamed:@"SplashSmall"];
//        }
//        UIImage *backgroundImage = [AppDelegate imageResize:splashImage
//                                                   andResizeTo:[UIScreen mainScreen].bounds.size];
//        splash.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
//        splash.fetchDelay = 3;
//        [splash loadAdAndShowInWindow:self.window];
//        self.splash = splash;
//
//    }

    
    return YES;
}

+ (UIImage *)imageResize:(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
