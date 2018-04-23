#import "AppDelegate.h"

#import "ViewController.h"
#import "TTFUpLoadServer.h"


#import <UserNotifications/UserNotifications.h>



@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];
    
    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"1.png"]);//[NSData dataWithContentsOfFile:@"/Users/jay/Downloads/11.mp4"];

    NSInteger i = 10;
    while (i) {
        [[TTFUpLoadServer new] uploadFormData:data url:@"https://sm.ms/api/upload" parameters:@{@"name":@"TTZ"} name:@"smfile" fileName:@"112.png"];

        i --;
    }
    
    return YES;
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler(UNNotificationPresentationOptionAlert);
}

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    
}


- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler{
    self.handler = completionHandler;
    [self creatNotificationContent:identifier];
}

- (void) creatNotificationContent:(NSString *)identifier{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    
    content.title = @"上传完成通知";
    content.body = [NSString stringWithFormat:@"上传完成--%@",identifier];
    UNTimeIntervalNotificationTrigger *trigger  = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.0 repeats:NO];
    
    
    NSString * requestIdentfier = @"com.yunhu.localNotification";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentfier content:content trigger:trigger];
    
    [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
    
    
    
    
}


@end


