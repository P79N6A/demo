//
//  AdNativeAdapterAdSmar.m
//  AdViewDevelop
//
//  Created by zhoutong on 16/8/11.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdNativeAdapterAdSmar.h"
#import "AdViewNativeAdInfo.h"
#import "adViewAdNetworkRegistry.h"
#import "adViewLog.h"
#import "AdNativeManagerImpl.h"
#import "adViewAdNetworkConfig.h"

@implementation AdNativeAdapterAdSmar

+ (AdNativeAdNetworkType)networkType {
    return AdNativeAdNetworkTypeAdSmar;
}

+ (void)load {
    if (NSClassFromString(@"NativeAd") != nil) {
        [[AdViewAdNetworkRegistry sharedNativeRegistry] registerClass:self];
    }
}

- (void)loadNativeAd:(int)adcount {
    Class GDTNativeClass = NSClassFromString(@"NativeAd");
    if (nil == GDTNativeClass) {
        AWLogInfo(@"no adsmar lib, can not create");
        [self.adNativeManager adapter:self failedRequestNativeAd:nil];
    }
    
    NSString *appKey = self.networkConfig.pubId;//@"5714887afc897826";//
    NSString *placementId = self.networkConfig.pubId2;//@"818260D7ACAE742A194F0BBE9EDBCF93";//
    _nativeAd = [[NativeAd alloc]initWithAppId:appKey adunitId:placementId];
    _nativeAd.NativeDelegate = self;
    _nativeAd.controller = [self.adNativeManager.delegate viewControllerForPresentingModalView];
    [_nativeAd loadAd:adcount];

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
    self.nativeAd.NativeDelegate = nil;
    self.nativeAd = nil;
}

#pragma mark - Delegate
-(void)onAdSuccess:(NSArray *)nativeAdDataArray {
    NSMutableArray *nativeAdArray = [[NSMutableArray alloc] init];
    for (NativeAdDataModel * data in nativeAdDataArray) {
        
        AdViewNativeAdInfo *nativeInfo = [[AdViewNativeAdInfo alloc] init];
        [nativeInfo setValue:data.title forKey:AdViewNativeAdTitle];
        [nativeInfo setValue:data.image forKey:AdViewNativeAdIconUrl];
//        [nativeInfo setValue:[adDict objectForKey:GDTNativeAdDataKeyDesc] forKey:AdViewNativeAdDesc];
//        [nativeInfo setValue:[adDict objectForKey:GDTNativeAdDataKeyImgUrl] forKey:AdViewNativeAdImageUrl];
        [nativeInfo setValue:data forKey:AdViewNativeAdPdata];
        [nativeAdArray addObject:nativeInfo];
    }
    [self.adNativeManager adapter:self didReceivedNativeAd:nativeAdArray];
}

-(void)onAdFailed:(AdError *)error {
    [self.adNativeManager adapter:self failedRequestNativeAd:[NSError errorWithDomain:error.errorDescription code:error.errorCode userInfo:nil]];
}

@end
