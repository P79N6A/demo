//
//  AppDelegate.m
//  rmtpm3u8
//
//  Created by 何川 on 2018/3/20.
//  Copyright © 2018年 何川. All rights reserved.
//

#import "AppDelegate.h"
#import "CYLTabBarController.h"
#import "MUViewController.h"
#import "RTMPViewController.h"
#import "AvailViewController.h"

@interface AppDelegate ()<UITabBarControllerDelegate>{//
    CYLTabBarController *tabBarController;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self makeApp];
    return YES;
}

-(void)makeApp{
    MUViewController *vcmu = [[MUViewController alloc] init];
    RTRootNavigationController *muvc = [[RTRootNavigationController alloc] initWithRootViewController:vcmu];

    RTMPViewController *vcrtm= [[RTMPViewController alloc] init];
    RTRootNavigationController *vcrtmp = [[RTRootNavigationController alloc] initWithRootViewController:vcrtm];

    AvailViewController *av= [[AvailViewController alloc] init];
    RTRootNavigationController *avv = [[RTRootNavigationController alloc] initWithRootViewController:av];
    
    tabBarController = [[CYLTabBarController alloc] init];
    tabBarController.delegate = self;

    [self dealsizeTabBarForController:tabBarController];
    [tabBarController setViewControllers:@[
                                           muvc,
                                           avv,
                                           vcrtmp
                                           ]];
    
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage jk_imageWithColor:kwhite] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    NSDictionary *attributes2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:10], NSFontAttributeName,
     kBlue, NSForegroundColorAttributeName, nil];
    [[UITabBarItem appearance] setTitleTextAttributes:attributes2 forState:UIControlStateSelected];
    
    
    
}

- (void)dealsizeTabBarForController:(CYLTabBarController *)tabBarControllert {
    tabBarControllert.tabBarItemsAttributes =  @[
                                                 @{
                                                     CYLTabBarItemTitle :  @"m3u8",
                                                     CYLTabBarItemImage : @"tabicon_zichan",
                                                     CYLTabBarItemSelectedImage : @"tabicon_zichan_sel",
                                                     },
                                                 @{
                                                     CYLTabBarItemTitle :  @"Availabel",
                                                     CYLTabBarItemImage : @"tabicon_zichan",
                                                     CYLTabBarItemSelectedImage : @"tabicon_zichan_sel",
                                                     },
                                                 @{
                                                     CYLTabBarItemTitle : @"rtmp",
                                                     CYLTabBarItemImage : @"tabicon_me",
                                                     CYLTabBarItemSelectedImage : @"tabicon_me_sel",
                                                     }
                                                 ];

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
