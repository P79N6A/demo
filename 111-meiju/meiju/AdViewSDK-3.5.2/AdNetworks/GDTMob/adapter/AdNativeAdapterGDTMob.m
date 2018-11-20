//
//  AdNativeAdapterGDTMob.m
//  AdViewDevelop
//
//  Created by maming on 15/12/25.
//  Copyright © 2015年 maming. All rights reserved.
//

#import "AdNativeAdapterGDTMob.h"
#import "AdViewNativeAdInfo.h"
#import "adViewAdNetworkRegistry.h"
#import "adViewLog.h"
#import "AdNativeManagerImpl.h"
#import "adViewAdNetworkConfig.h"

@implementation AdNativeAdapterGDTMob

+ (AdNativeAdNetworkType)networkType {
    return AdNativeAdNetworkTypeGDTMob;
}

+ (void)load {
    if (NSClassFromString(@"GDTNativeAd") != nil) {
        [[AdViewAdNetworkRegistry sharedNativeRegistry] registerClass:self];
    }
}

- (void)loadNativeAd:(int)adcount {
    Class GDTNativeClass = NSClassFromString(@"GDTNativeAd");
    if (nil == GDTNativeClass) {
        AWLogInfo(@"no GDTMob lib, can not create");
        [self.adNativeManager adapter:self failedRequestNativeAd:nil];
    }
    
    NSString *appKey = self.networkConfig.pubId;//@"appkey";
    NSString *placementId = self.networkConfig.pubId2;//@"1080215124193862";
    self.nativeAd = [[GDTNativeClass alloc] initWithAppkey:appKey placementId:placementId];
    self.nativeAd.delegate = self;
    self.nativeAd.controller = [self.adNativeManager.delegate viewControllerForPresentingModalView];
    [self.nativeAd loadAd:adcount];
    [self.adNativeManager adapter:self report:AdNativeReportType_Request];
}

- (void)showNativeAd:(UIView *)view withNativeData:(AdViewNativeAdInfo *)adInfo {
    [self.nativeAd attachAd:[adInfo valueForKey:AdViewNativeAdPdata] toView:view];
    [self.adNativeManager adapter:self report:AdNativeReportType_Impression];
}

- (void)clickNativeAd:(AdViewNativeAdInfo *)adInfo {
    [self.nativeAd clickAd:[adInfo valueForKey:AdViewNativeAdPdata]];
    [self.adNativeManager adapter:self report:AdNativeReportType_Click];
}

- (void)stopBeingDelegate {
    self.nativeAd.delegate = nil;
    self.nativeAd = nil;
}

#pragma mark - GDTDelegate
- (void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray {
    NSMutableArray *nativeAdArray = [[NSMutableArray alloc] init];
    for (GDTNativeAdData * data in nativeAdDataArray) {
        NSDictionary *adDict = data.properties;
        AdViewNativeAdInfo *nativeInfo = [[AdViewNativeAdInfo alloc] init];
        [nativeInfo setValue:[adDict objectForKey:GDTNativeAdDataKeyTitle] forKey:AdViewNativeAdTitle];
        [nativeInfo setValue:[adDict objectForKey:GDTNativeAdDataKeyIconUrl] forKey:AdViewNativeAdIconUrl];
        [nativeInfo setValue:[adDict objectForKey:GDTNativeAdDataKeyDesc] forKey:AdViewNativeAdDesc];
        [nativeInfo setValue:[adDict objectForKey:GDTNativeAdDataKeyImgUrl] forKey:AdViewNativeAdImageUrl];
        [nativeInfo setValue:data forKey:AdViewNativeAdPdata];
        [nativeAdArray addObject:nativeInfo];
    }
    [self.adNativeManager adapter:self didReceivedNativeAd:nativeAdArray];
}

- (void)nativeAdFailToLoad:(NSError *)error {
    [self.adNativeManager adapter:self failedRequestNativeAd:error];
}

- (void)nativeAdWillPresentScreen {

}

- (void)nativeAdClosed {

}

- (void)nativeAdApplicationWillEnterBackground {

}
@end
