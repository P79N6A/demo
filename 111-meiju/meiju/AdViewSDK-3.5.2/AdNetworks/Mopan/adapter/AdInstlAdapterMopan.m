//
//  AdInstlAdapterMopan.m
//  AdViewAll
//
//  Created by 周桐 on 15/8/19.
//  Copyright (c) 2015年 unakayou. All rights reserved.
//

#import "AdInstlAdapterMopan.h"
#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "adViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"

@implementation AdInstlAdapterMopan

+ (AdInstlAdNetworkType)networkType
{
    return AdInstlAdNetworkTypeMopan;
}

+ (void)load
{
    [[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
}

- (BOOL)loadAdInstl:(UIViewController*)controller
{
    if (controller == nil) return NO;

    [MopSpotController initWithProductId:self.networkConfig.pubId ProductSecret:self.networkConfig.pubId2];
//    磨盘官方key
//    [MopSpotController initWithProductId:@"900" ProductSecret:@"900900900"];
    [MopSpotController setDelegateWithObj:self];
    [MopSpotController loadDataWithReloadSwitch:YES];
    [MopSpotController clickCloseButton:^{
        
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
    }];

    [self.adInstlManager adapter:self requestString:@"req"];
    
    return YES;
}

- (BOOL)showAdInstl:(UIViewController*)controller
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    BOOL isNotPresent = (![controller isViewLoaded] || [controller isBeingDismissed] || [controller isMovingFromParentViewController]);
#else
    BOOL isNotPresent = ![controller isViewLoaded];
#endif
    
    if (nil == controller || isNotPresent) {
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
//判断展示成功失败
    BOOL isSuc = [MopSpotController showMopPlaque:^(MopError flag) {
        switch (flag) {
            case NoneError:
//                [self.adInstlManager adapter:self requestString:@"show"];
                [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
                break;
            default:
                [self.adInstlManager adapter:self requestString:@"fail"];
                [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
                break;
        }
    }];
    
    return isSuc;
}

- (void)stopBeingDelegate
{
    AWLogInfo(@"mopan -- stopBeingDelegate");
}

//延迟加载，如果一直失败修改上面的延迟时间
- (void)didLoadAfterDelay{
    [self.adInstlManager adapter:self requestString:@"suc"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}
#pragma mark delegate
//插屏加载成功时调用
- (void)mopSpotLoadSuccess{
    [self performSelector:@selector(didLoadAfterDelay) withObject:nil afterDelay:0.2];
}
//插屏加载失败时调用
- (void)mopSpotLoadFailure{
    [self.adInstlManager adapter:self requestString:@"fail"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
}
//用户点击插屏时候调用
- (void)mopSpotClickAd{
    
}

@end
