//
//  AdInstlAdapterAdSmar.m
//  AdViewDevelop
//
//  Created by zhoutong on 16/8/11.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdInstlAdapterMobFox.h"
#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"

@implementation AdInstlAdapterMobFox

+ (AdInstlAdNetworkType)networkType {
    return AdInstlAdNetworkTypeMobFox;
}

+ (void)load {
    if(NSClassFromString(@"MobFoxInterstitialAd") != nil) {
        [[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
    }
}

- (BOOL)loadAdInstl:(UIViewController*)controller
{
    Class AdInterstitialClass = NSClassFromString(@"MobFoxInterstitialAd");
    if(nil == AdInterstitialClass) return NO;
    
    NSString *appID = self.networkConfig.pubId;//@"267d72ac3f77a3f447b32cf7ebf20673";
    
    [MobFoxInterstitialAd locationServicesDisabled:[self isOpenGps]];
    
    self.mobfoxInterAd = [[MobFoxInterstitialAd alloc] init:appID withRootViewController:controller];
    
    self.mobfoxInterAd.delegate = self;
    self.mobfoxInterAd.autoplay =  false;
    
    [self.mobfoxInterAd loadAd];

    _timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(timeOutToFailLoad) userInfo:nil repeats:NO];
    
    [self.adInstlManager adapter:self requestString:@"req"];

    return YES;
}

- (BOOL)showAdInstl:(UIViewController*)controller
{

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0)
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
    
    [self.mobfoxInterAd show];
    
    return YES;
}
- (BOOL) isOpenGps {
    if ([adInstlManager.delegate respondsToSelector:@selector(adInstlOpenGps)])
        return [adInstlManager.delegate adInstlOpenGps];
    return NO;
}
- (void)timeOutToFailLoad{
    [self.adInstlManager adapter:self requestString:@"fail"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
}

#pragma mark InterstitialAd DelegateMethod

- (void)MobFoxInterstitialAdDidLoad:(MobFoxInterstitialAd *)interstitial{
    [_timer invalidate];
    _timer = nil;
    self.mobfoxInterAd.delegate = nil;
    [self.adInstlManager adapter:self requestString:@"suc"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}

- (void)MobFoxInterstitialAdDidFailToReceiveAdWithError:(NSError *)error{
    AWLogInfo(@"error is %@",error);
    [self.adInstlManager adapter:self requestString:@"fail"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:error];
}

- (void)MobFoxInterstitialAdWillShow:(MobFoxInterstitialAd *)interstitial{}

- (void)MobFoxInterstitialAdClosed{
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

- (void)MobFoxInterstitialAdClicked{
    [self.adInstlManager adapter:self requestString:@"click"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];

}

- (void)MobFoxInterstitialAdFinished{}


- (void)stopBeingDelegate {
    AWLogInfo(@"--MobFox--stopBeingDelegate");
    self.mobfoxInterAd.delegate = nil;
    self.mobfoxInterAd = nil;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
