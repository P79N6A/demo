//
//  AdinstlAdapterMiidi.m
//  AdViewAll
//
//  Created by 张宇宁 on 15-3-12.
//  Copyright (c) 2015年 unakayou. All rights reserved.
//

#import "AdInstlAdapterMiidi.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewExtraManager.h"
#import "AdInstlManagerImpl.h"
#import "MiidiMobAd.h"
#import "MiidiMobAdApiConfig.h"
#import "MiidiMobAdPubHeader.h"
@implementation AdInstlAdapterMiidi

@synthesize parent;
//@synthesize AdIsReady;

+ (AdInstlAdNetworkType)networkType {
    return AdInstlAdNetworkTypeMiidi;
}

+ (void)load {
    if(NSClassFromString(@"ADPWPattee") != nil) {
        [[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
    }
}

- (BOOL)loadAdInstl:(UIViewController *)controller
{
    Class MiidiAdSpotClass = NSClassFromString (@"ADPWPattee");
    
    if (nil == MiidiAdSpotClass) {
        AWLogInfo(@"no Miidi lib, can not create.");
        return NO;
    }
    
//    NSString *str= [ADPWPattee getMiidiBasSdkVersion];
    
    [MiidiMobAd setMiidiBasPublisher:self.networkConfig.pubId withMiidiBasSecret:self.networkConfig.pubId2];
    
    [self.adInstlManager adapter:self requestString:@"req"];
    
    [self performSelector:@selector(didLoad) withObject:nil afterDelay:1];
    return YES;
}

- (void)didLoad {
    
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}

- (BOOL)showAdInstl:(UIViewController *)controller
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    if (nil == controller || ![controller isViewLoaded] || [controller isBeingDismissed]) {
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
#else
    if (nil == controller || ![controller isViewLoaded]) {
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
    
#endif
    [MiidiMobAd requestMiidiBasSplash:^(NSError * error){
        // error == nil 加载广告成功
        if (error == nil) {
            NSLog(@"MiidiMobAdSplash ==> 1.预加载成功!");
            [self MiidiAdDisplay];
            [MiidiMobAd displayMiidiBasSplash:^(void){
                NSLog(@"MiidiMobAdSplash ==> 2.展示窗口关闭!");
                [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil]; 
            }];
        }
        else {
            [self performSelector:@selector(failLoad) withObject:nil afterDelay:2];
            AWLogInfo(@"MiidMobAd fail");
            [MiidiMobAd requestMiidiBasSplashOverForFailed];
        }
    }];
    return YES;
}

- (void)failLoad
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
    [self.adInstlManager adapter:self requestString:@"fail"];
}

- (void)MiidiAdDisplay
{
    [self.adInstlManager adapter:self requestString:@"show"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
}

- (void)stopBeingDelegate
{
    AWLogInfo(@"Miidi stop being delegate");
}
@end
