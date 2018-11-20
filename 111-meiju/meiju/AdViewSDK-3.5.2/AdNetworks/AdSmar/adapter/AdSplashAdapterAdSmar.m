//
//  AdSplashAdapterAdSmar.m
//  AdViewDevelop
//
//  Created by zhoutong on 16/8/11.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdSplashAdapterAdSmar.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "adViewAdNetworkRegistry.h"
#import "AdSpreadScreenManagerImpl.h"
#import "adViewLog.h"
#import "adViewAdNetworkAdapter+Helpers.h"

@implementation AdSplashAdapterAdSmar

+ (AdSpreadScreenAdNetworkType)networkType {
    return AdSpreadScreenAdNetworkTypeAdSmar;
}

+ (void)load {
    if (NSClassFromString(@"FullScreenAd") != nil) {
        [[AdViewAdNetworkRegistry sharedSpreadScreenRegistry] registerClass:self];
    }
}

- (BOOL)loadAdSpreadScreen:(UIViewController *)controller {
    Class DomobSplashAdClass = NSClassFromString(@"FullScreenAd");
    
    if (DomobSplashAdClass == nil) return NO;
    if (controller == nil) return NO;
    
    [[FullScreenAd sharedInstance] setDisplayTime:5];

    [[FullScreenAd sharedInstance] loadAdWithAdUnitId:self.networkConfig.pubId2 AndAppId:self.networkConfig.pubId];//@"5439A9D94B4437EF48B142734DB9A0AB"@"5714887afc897826"
    [FullScreenAd sharedInstance].fullScreenAdDelegate = self;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timeOutToFailLoad) userInfo:nil repeats:NO];
    
    [self.adSpreadScreenManager adapter:self requestString:@"req"];
    
    return YES;
}

- (void)timeOutToFailLoad{
    [self.adSpreadScreenManager adapter:self requestString:@"fail"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_FailLoadAd error:[NSError errorWithDomain:@"请求超时" code:100 userInfo:nil]];

}

#pragma mark -  splash delegate
- (void) onAdSuccess{
    [_timer invalidate];
    _timer = nil;
    [FullScreenAd sharedInstance].fullScreenAdDelegate = nil;
    
    [self.adSpreadScreenManager adapter:self requestString:@"suc"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidLoadAd error:nil];
    [[FullScreenAd   sharedInstance]showFullscreenBrowserAnimated:YES];
}

- (void) onAdFailed:(AdError *)errorCode{
    [self.adSpreadScreenManager adapter:self requestString:@"fail"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_FailLoadAd error:[NSError errorWithDomain:errorCode.description code:errorCode.errorCode userInfo:nil]];
}

- (void) onAdClick{
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_WillPresentAd error:nil];
}

- (void) onAdClose{
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidDismissAd error:nil];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"AdSmar splash stop being delegate");
    [FullScreenAd sharedInstance].fullScreenAdDelegate = nil;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
