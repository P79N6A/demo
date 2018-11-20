//
//  AdVideoAdapterInMobi.m
//  AdViewDevelop
//
//  Created by maming on 16/9/19.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdVideoAdapterSTMob.h"
#import "adViewAdNetworkRegistry.h"
#import "adViewAdNetworkConfig.h"
#import "adViewLog.h"
#import "AdVideoManagerImpl.h"
#import "AdVideoManagerDelegate.h"

@implementation AdVideoAdapterSTMob


+ (AdVideoAdNetworkType)networkType {
    return AdVideoAdNetworkTypeSTMob;
}

+ (void)load {
    if (NSClassFromString(@"STVideoSDK") != nil) {
        [[AdViewAdNetworkRegistry sharedVideoRegistry] registerClass:self];
    }
}

- (BOOL)loadAdVideo:(UIViewController *)controller {
    Class videoClass = NSClassFromString(@"STVideoSDK");
    if(nil == videoClass) return NO;
    
    self.parent = controller;
    
    NSString *key = self.networkConfig.pubId;//@"2_36_40";//
    NSArray *keys = [key componentsSeparatedByString:@"_"];
    if (!keys || [keys count] != 3) {
        return NO;
    }
    NSString * key1 = [keys objectAtIndex:0];
    NSString * key2 = [keys objectAtIndex:1];
    NSString * key3 = [keys objectAtIndex:2];
    
    NSString * appKey = self.networkConfig.pubId2;//@"Ac7Kd3lJ^KQX9Hjkn_Z(UO9jqViFh*q1";//
    
    [STVideoSDK registerSDKWithPublishedId:key1
                                     appId:key2
                               placementId:key3
                                    appKey:appKey];
    if ([adVideoManager.delegate respondsToSelector:@selector(adVideoOpenGps)]) {
        if (![adVideoManager.delegate adVideoOpenGps]) {
            [STVideoSDK disableLocationServices];
        }
    }else{
        [STVideoSDK disableLocationServices];
    }
    [STVideoSDK isHaveVideo:^(int state) {
        if (state != 0) {
            [adVideoManager adapter:self didGetEvent:VideoEventType_FailLoadAd error:nil];
        }
    }];
    [STVideoSDK sharedInstance].delegate = self;
    //Wi-Fi下预加载广告资源文件
    [STVideoSDK preDownloadResourcesAtWifiNetwork];
    
    return YES;
}

- (BOOL)showAdVideo:(UIViewController *)controller {
    
    if ([STVideoSDK isReadyForPlay]) {
        [STVideoSDK presentVideoPlayerViewControllerInViewController:self.parent videoPlayFinishWithCompletionHandler:nil];
        return YES;
    }
    return NO;
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--舜飞 video-- stopBeingDelegate");
    
}

#pragma mark - delegate
// 全屏视频广告资源加载成功
- (void)fullScreenVideoDidLoad{
    [adVideoManager adapter:self didGetEvent:VideoEventType_DidLoadAd error:nil];
}

// 全屏视频广告资源加载失败
- (void)fullScreenVideoDidLoadFail{
    AWLogInfo(@"fullScreenVideoDidLoadFail");
    [adVideoManager adapter:self didGetEvent:VideoEventType_FailLoadAd error:nil];
}

// 全屏视频广告展示成功
- (void)fullScreenVideoDidPresent{
    [adVideoManager adapter:self didGetEvent:VideoEventType_StartPlay error:nil];
}

// 全屏视频广告完整播放
- (void)fullScreenVideoDidFullPlay{
    [adVideoManager adapter:self didGetEvent:VideoEventType_EndPlay error:nil];
}

// 广告被点击
- (void)fullScreenVideoDidTap{
    [adVideoManager adapter:self didGetEvent:VideoEventType_DidClickAd error:nil];
}

// 广告关闭
- (void)fullScreenVideoDidDismiss{
    [adVideoManager adapter:self didGetEvent:VideoEventType_Close_PlayEnd error:nil];
}

@end
