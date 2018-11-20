//
//  AdVideoAdapterChance.m
//  AdViewDevelop
//
//  Created by maming on 16/9/20.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdVideoAdapterChance.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdNetworkConfig.h"
#import "adViewLog.h"
#import "AdVideoManagerImpl.h"
#import "AdVideoManagerDelegate.h"

@implementation AdVideoAdapterChance
+ (AdVideoAdNetworkType)networkType {
    return AdVideoAdNetworkTypeChance;
}

+ (void)load {
    if (NSClassFromString(@"CSVideoAD") != nil) {
        [[AdViewAdNetworkRegistry sharedVideoRegistry] registerClass:self];
    }
}

- (BOOL)loadAdVideo:(UIViewController *)controller {
    Class ChanceVideoClass = NSClassFromString(@"CSVideoAD");
    Class ChanceAdClass = NSClassFromString(@"ChanceAd");
    if (nil == ChanceAdClass || nil == ChanceVideoClass) {
        return NO;
    }
    
    [ChanceAd startSession:self.networkConfig.pubId];
    
    [CSVideoAD sharedInstance].placementID = self.networkConfig.pubId2;
//    [CSVideoAD sharedInstance].userInfo = self.networkConfig.pubId3;
    [CSVideoAD sharedInstance].delegate = self;
    [[CSVideoAD sharedInstance] loadVideoADWithOrientation:YES andDownloadVideoOnlyWifi:NO];
    
    return YES;
}

- (BOOL)showAdVideo:(UIViewController *)controller {
    if ([CSVideoAD sharedInstance].videoStatus == CSVideoStatus_IsReady) {
        [[CSVideoAD sharedInstance] showVideoADWithOrientation:YES];
        return YES;
    }
    return NO;
}

- (void)stopBeingDelegate {
    AWLogInfo(@"Chance video stopBeingDelegate!");
}

#pragma mark - CSVideoADDelegate

// 视频广告请求成功
- (void)csVideoADRequestVideoADSuccess:(CSVideoAD *)csVideoAD
{
//    [adVideoManager adapter:self didGetEvent:VideoEventType_DidLoadAd error:nil];
}

// 视频广告请求失败
- (void)csVideoAD:(CSVideoAD *)csVideoAD requestVideoADError:(CSError *)csError
{
    AWLogInfo(@"chance 视频广告请求失败");
    [adVideoManager adapter:self didGetEvent:VideoEventType_FailLoadAd error:csError];
}

// 视频文件准备好了（不播放视频广告时才会有回调）
// isCache为YES表示视频文件为缓存
- (void)csVideoAD:(CSVideoAD *)csVideoAD videoFileIsReady:(BOOL)isCache
{
    AWLogInfo(@"chance 视频广告请求成功");
    [adVideoManager adapter:self didGetEvent:VideoEventType_DidLoadAd error:nil];
}

// 视频广告将要播放
// 返回YES表示播放视频广告，返回NO表示暂不播放。未实现按YES处理
- (BOOL)csVideoADWillPlayVideoAD:(CSVideoAD *)csVideoAD
{
    return YES;
}

// 视频广告加载过程中的退出播放
- (void)csVideoADExitPlayWhenLoading:(CSVideoAD *)csVideoAD
{
    [adVideoManager adapter:self didGetEvent:VideoEventType_Close_Playing error:nil];
}

// 视频广告因视频文件错误导致的取消播放
- (void)csVideoAD:(CSVideoAD *)csVideoAD cancelPlayWithError:(NSError *)error
{
    [adVideoManager adapter:self didGetEvent:VideoEventType_FailShow error:error];
}

// 视频广告展现失败
- (void)csVideoAD:(CSVideoAD *)csVideoAD showVideoADError:(CSError *)csError
{
    [adVideoManager adapter:self didGetEvent:VideoEventType_FailShow error:csError];
}

// 视频广告展现成功，即开始播放视频广告
- (void)csVideoAD:(CSVideoAD *)csVideoAD showVideoADSuccess:(BOOL)replay
{
    [adVideoManager adapter:self didGetEvent:VideoEventType_StartPlay error:nil];
}

// 点击视频广告的关闭按钮
- (void)csVideoAD:(CSVideoAD *)csVideoAD clickCloseButtonAndWillClose:(BOOL)close
{
    [adVideoManager adapter:self didGetEvent:VideoEventType_Close_PlayEnd error:nil];
}

// 视频广告播放完成（广告不会自动关闭）（replay为YES表示重播）
- (void)csVideoAD:(CSVideoAD *)csVideoAD playVideoFinished:(BOOL)replay
{
    [adVideoManager adapter:self didGetEvent:VideoEventType_EndPlay error:nil];
}

// 视频广告播放过程中点击了下载按钮（replay为YES表示重播）
- (void)csVideoAD:(CSVideoAD *)csVideoAD clickDownload:(BOOL)replay
{
    
}

// 视频广告关闭
- (void)csVideoADClosed:(CSVideoAD *)csVideoAD
{
}

@end
