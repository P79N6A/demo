//
//  AdNativeAdapterGDTMob.m
//  AdViewDevelop
//
//  Created by maming on 15/12/25.
//  Copyright © 2015年 maming. All rights reserved.
//

#import "AdNativeAdapterInMobi.h"
#import "AdViewNativeAdInfo.h"
#import "adViewAdNetworkRegistry.h"
#import "adViewLog.h"
#import "AdNativeManagerImpl.h"
#import "adViewAdNetworkConfig.h"
#import "AdViewExtraManager.h"

@implementation AdNativeAdapterInMobi

+ (AdNativeAdNetworkType)networkType {
    return AdNativeAdNetworkTypeInMobi;
}

+ (void)load {
    if (NSClassFromString(@"IMNative") != nil) {
        [[AdViewAdNetworkRegistry sharedNativeRegistry] registerClass:self];
    }
}

- (void)loadNativeAd:(int)adcount {
    Class INMOBINativeClass = NSClassFromString(@"IMNative");
    if (nil == INMOBINativeClass) {
        AWLogInfo(@"no INMOBI lib, can not create");
        [self.adNativeManager adapter:self failedRequestNativeAd:nil];
    }
    
    NSString *appKey = self.networkConfig.pubId;//@"4028cb8b2c3a0b45012c406824e800ba";
    NSString *placementId = self.networkConfig.pubId2;//@"1453926340624";
//    NSString *appKey = @"4028cb8b2c3a0b45012c406824e800ba";//@"4028cb8b2c3a0b45012c406824e800ba";
//    NSString *placementId = @"1453926340624";//@"1453926340624";
    
    
    [IMSdk initWithAccountID:appKey];
    [IMSdk setLogLevel:kIMSDKLogLevelNone];
    
    //添加gps
    BOOL gpsON = NO;
    if ([self.adNativeDelegate respondsToSelector:@selector(adNativeOpenGps)]) {
        gpsON = [self.adNativeDelegate adNativeOpenGps];
        
    }
    if (gpsON) {
        CLLocation *loc =[[AdViewExtraManager sharedManager] getLocation];
        [IMSdk setLocation:loc];
    }
    self.nativeAd = [[IMNative alloc] initWithPlacementId:[placementId longLongValue] delegate:self];
    self.nativeAd.delegate = self;
    //添加必传字段
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"c_adview" forKey:@"tp"];
    [dict setObject:ADVIEW_VERSION_STR forKey:@"tp-ver"];
    if (self.nativeAd) {
        [self.nativeAd setExtras:[NSDictionary dictionaryWithDictionary:dict]];
    }

    [self.nativeAd load];
    [self.adNativeManager adapter:self report:AdNativeReportType_Request];
}

- (void)showNativeAd:(UIView *)view withNativeData:(AdViewNativeAdInfo *)adInfo {
    [self.nativeAd primaryViewOfWidth:25];
    [self.adNativeManager adapter:self report:AdNativeReportType_Impression];
}

- (void)clickNativeAd:(AdViewNativeAdInfo *)adInfo withClickPoint:(CGPoint)point{
    [self.nativeAd reportAdClickAndOpenLandingPage];
    [self.adNativeManager adapter:self report:AdNativeReportType_Click];
}

- (void)stopBeingDelegate {
    self.nativeAd.delegate = nil;
    self.nativeAd = nil;
}

#pragma mark - Delegate

-(void)nativeDidFinishLoading:(IMNative*)native{
    AdViewNativeAdInfo *nativeInfo = [[AdViewNativeAdInfo alloc] init];
    
    [nativeInfo setValue:native.adTitle forKey:AdViewNativeAdTitle];
    [nativeInfo setValue:native.adIcon forKey:AdViewNativeAdIconUrl];
    [nativeInfo setValue:native.adDescription forKey:AdViewNativeAdDesc];
    [nativeInfo setValue:[native.adLandingPageUrl host] forKey:AdViewNativeAdImageUrl];


    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [mutableArray addObject:nativeInfo];
    
    [self.adNativeManager adapter:self didReceivedNativeAd:mutableArray];
}

-(void)native:(IMNative*)native didFailToLoadWithError:(IMRequestStatus*)error{
    [self.adNativeManager adapter:self failedRequestNativeAd:error];
}

-(void)nativeWillPresentScreen:(IMNative*)native{
    
}
    /**
     * Notifies the delegate that the native ad has presented a full screen content.
     */
-(void)nativeDidPresentScreen:(IMNative*)native{}
    /**
     * Notifies the delegate that the native ad would be dismissing the presented full screen content.
     */
-(void)nativeWillDismissScreen:(IMNative*)native{}
    /**
     * Notifies the delegate that the native ad has dismissed the presented full screen content.
     */
-(void)nativeDidDismissScreen:(IMNative*)native;{}
    /**
     * Notifies the delegate that the user will be taken outside the application context.
     */
-(void)userWillLeaveApplicationFromNative:(IMNative*)native{}

/**
 * Notifies the delegate that the native ad impression has been tracked
 */
-(void)nativeAdImpressed:(IMNative*)native{}
@end
