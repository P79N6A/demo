//
//  AdVideoAdapterDomob.m
//  AdViewDevelop
//
//  Created by maming on 16/9/14.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdVideoAdapterAppnext.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdNetworkConfig.h"
#import "adViewLog.h"
#import "AdVideoManagerImpl.h"
#import "AdVideoManagerDelegate.h"

@implementation AdVideoAdapterAppnext

+ (AdVideoAdNetworkType)networkType {
    return AdVideoAdNetworkTypeAppnext;
}

+ (void)load {
    if (NSClassFromString(@"AppnextFullScreenVideoAd") != nil) {
        [[AdViewAdNetworkRegistry sharedVideoRegistry] registerClass:self];
    }
}

- (BOOL)loadAdVideo:(UIViewController *)controller {
    Class videoManagerClass = NSClassFromString(@"AppnextFullScreenVideoAd");
    if (nil == videoManagerClass) return NO;
    
    NSString *appID = self.networkConfig.pubId;
    
    AppnextFullScreenVideoAdConfiguration *fullScreenConfig = [[AppnextFullScreenVideoAdConfiguration alloc] init];
    self.fullScreen = [[AppnextFullScreenVideoAd alloc] initWithConfig:fullScreenConfig placementID:appID];//@"891a67bd-73e8-4adb-8209-df041110e1f1"
    self.fullScreen.delegate = self;
    
    [self.fullScreen loadAd];
    
    return YES;
}

- (BOOL)showAdVideo:(UIViewController *)controller {
    if (nil == self.fullScreen) {
        AWLogInfo(@"No video object(Appnext) exist!");
        return NO;
    }
    
    [self.fullScreen showAd];
    
    return YES;
}

- (void)stopBeingDelegate {
    AWLogInfo(@"Appnext video object stopBeingDelegate");
    self.fullScreen.delegate = nil;
    self.fullScreen = nil;
}

#pragma mark - AppnextVideoAdDelegate 

- (void) adLoaded:(AppnextAd *)ad{
    AWLogInfo(@"appnext adLoaded");
    [adVideoManager adapter:self didGetEvent:VideoEventType_DidLoadAd error:nil];
}
- (void) adError:(AppnextAd *)ad error:(NSString *)error{
    AWLogInfo(@"appnext failedLoad");
    [adVideoManager adapter:self didGetEvent:VideoEventType_FailLoadAd error:[NSError errorWithDomain:error code:1 userInfo:nil]];
}
- (void) adOpened:(AppnextAd *)ad{
    [adVideoManager adapter:self didGetEvent:VideoEventType_StartPlay error:nil];
}
- (void) adClosed:(AppnextAd *)ad{
    [adVideoManager adapter:self didGetEvent:VideoEventType_Close_PlayEnd error:nil];
}
- (void) adClicked:(AppnextAd *)ad{
    [adVideoManager adapter:self didGetEvent:VideoEventType_DidClickAd error:nil];
}
- (void) adUserWillLeaveApplication:(AppnextAd *)ad{}

@end
