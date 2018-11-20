//
//  AdVideoAdapterChance.m
//  AdViewDevelop
//
//  Created by maming on 16/9/20.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdVideoAdapterUnity.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdNetworkConfig.h"
#import "adViewLog.h"
#import "AdVideoManagerImpl.h"
#import "AdVideoManagerDelegate.h"

@implementation AdVideoAdapterUnity
+ (AdVideoAdNetworkType)networkType {
    return AdVideoAdNetworkTypeUnity;
}

+ (void)load {
    if (NSClassFromString(@"UnityAds") != nil) {
        [[AdViewAdNetworkRegistry sharedVideoRegistry] registerClass:self];
    }
}

- (BOOL)loadAdVideo:(UIViewController *)controller {
    Class unityVideoClass = NSClassFromString(@"UnityAds");
    if (nil == unityVideoClass) {
        return NO;
    }
    self.parentVC = controller;
    
    NSString *gameId = networkConfig.pubId;//@"14850";//
    //初始化只走一次
    [UnityAds setDebugMode:NO];
    [UnityAds initialize:gameId delegate:self testMode:NO];

    return YES;
}

- (BOOL)showAdVideo:(UIViewController *)controller {
   
    //unity的判断加载完成不靠谱，ready YES也有可能反回加载失败，故延时处理
    [self performSelector:@selector(showVideo) withObject:nil afterDelay:2];
        
        return YES;
}
- (void)showVideo{
    if (self.placementId) {
        [UnityAds show:self.parentVC placementId:self.placementId];
    }else{
        [UnityAds show:self.parentVC];
    }
    
}
- (void)stopBeingDelegate {
    AWLogInfo(@"UnityAds video stopBeingDelegate!");
    self.placementId = nil;
    self.parentVC = nil;
}
- (void)delaySuc{
    AWLogInfo(@"unity 视频广告请求成功");
    [adVideoManager adapter:self didGetEvent:VideoEventType_DidLoadAd error:nil];
}

#pragma mark - UnityAdsDelegate
- (void)unityAdsReady:(NSString *)placementId{
    if (PlacementId(placementId)) {
        self.placementId = placementId;
        AWLogInfo(@"unity 视频广告请求成功");
        [adVideoManager adapter:self didGetEvent:VideoEventType_DidLoadAd error:nil];
    }
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
    if (error == kUnityAdsErrorInitSanityCheckFail) {
        //由于unity不执行加载过程，影响sdk后续线程，延迟处理
        [self performSelector:@selector(delaySuc) withObject:nil afterDelay:0.5];
    }else{
        AWLogInfo(@"unity 视频广告请求失败");
        [adVideoManager adapter:self didGetEvent:VideoEventType_FailLoadAd error:[NSError errorWithDomain:message code:0 userInfo:nil]];
    }
}

- (void)unityAdsDidStart:(NSString *)placementId{
    [adVideoManager adapter:self didGetEvent:VideoEventType_StartPlay error:nil];
}

- (void)unityAdsDidFinish:(NSString *)placementId
          withFinishState:(UnityAdsFinishState)state{
    switch (state) {
        case kUnityAdsFinishStateError:
            [adVideoManager adapter:self didGetEvent:VideoEventType_FailShow error:nil];
            break;
        case kUnityAdsFinishStateSkipped:
            [adVideoManager adapter:self didGetEvent:VideoEventType_Close_Playing error:nil];
            break;
        case kUnityAdsFinishStateCompleted:
             [adVideoManager adapter:self didGetEvent:VideoEventType_EndPlay error:nil];
            break;
        default:
            break;
    }
}

@end
