//
//  AdNativeAdapterGDTMob.m
//  AdViewDevelop
//
//  Created by maming on 15/12/25.
//  Copyright © 2015年 maming. All rights reserved.
//

#import "AdNativeAdapterJDAdview.h"
#import "AdViewNativeAdInfo.h"
#import "adViewAdNetworkRegistry.h"
#import "adViewLog.h"
#import "AdNativeManagerImpl.h"
#import "adViewAdNetworkConfig.h"

@implementation AdNativeAdapterJDAdview

+ (AdNativeAdNetworkType)networkType {
    return AdNativeAdNetworkTypeJDAdview;
}

+ (void)load {
    if (NSClassFromString(@"JDNativeAd") != nil) {
        [[AdViewAdNetworkRegistry sharedNativeRegistry] registerClass:self];
    }
}

- (void)loadNativeAd:(int)adcount {
    Class JDNativeClass = NSClassFromString(@"JDNativeAd");
    if (nil == JDNativeClass) {
        AWLogInfo(@"no JD lib, can not create");
        [self.adNativeManager adapter:self failedRequestNativeAd:nil];
    }
    
    JDAdAppInfo *appInfo = [[JDAdAppInfo alloc] init];
    appInfo.keywords = @"金融，财会";
    
    JDAdUser *userinfo = [[JDAdUser alloc] initJDAdUserWithGender:JDAdGenderFemale yob:@"1983" keywords:@"白领" segments:@"1,3,5"];
    
    [JDAdManager shareManager].isHttp = YES;
    [JDAdManager shareManager].istest = NO;
    [JDAdManager shareManager].app = appInfo;
    [JDAdManager shareManager].user = userinfo;
    
    /**
     *  需开发者自行修改所需广告尺寸
     */
    CGSize size = CGSizeMake(100, 100);
    
    self.nativeAd = [[JDAdManager shareManager] getNativeAdsBySize:size withTagid:self.networkConfig.pubId andCounts:adcount];
    //@"204143cac2d34934a85e2ecd305e9e21"
    self.nativeAd.delegate = self;
    [self.adNativeManager adapter:self report:AdNativeReportType_Request];
}

- (void)showNativeAd:(UIView *)view withNativeData:(AdViewNativeAdInfo *)adInfo {
    
    [(JDNativeAdActor*)[adInfo valueForKey:AdViewNativeAdPdata] doExposedReports];
    [self.adNativeManager adapter:self report:AdNativeReportType_Impression];
}

- (void)clickNativeAd:(AdViewNativeAdInfo *)adInfo {
    /**
     *  自行跳转
     */
    NSURL *url = [NSURL URLWithString:[adInfo valueForKey:AdViewNativeAdLinkUrl]];
    [[UIApplication sharedApplication] openURL:url];
    [self.adNativeManager adapter:self report:AdNativeReportType_Click];
}

- (void)stopBeingDelegate {
    self.nativeAd.delegate = nil;
    self.nativeAd = nil;
}

#pragma mark - Delegate

- (void)nativeAd:(JDNativeAd *)nativeAd{
    NSMutableArray *nativeAdArray = [[NSMutableArray alloc] init];

    for (JDNativeAdActor *act in nativeAd.contents) {
        
        AdViewNativeAdInfo *nativeInfo = [[AdViewNativeAdInfo alloc] init];
        [nativeInfo setValue:[act getNativeAdTitle] forKey:AdViewNativeAdTitle];
        [nativeInfo setValue:[act getProductDesc] forKey:AdViewNativeAdDesc];
        [nativeInfo setValue:[act getImgUrlString] forKey:AdViewNativeAdIconUrl];
        [nativeInfo setValue:[act getClickUrl] forKey:AdViewNativeAdLinkUrl];
        
        [nativeInfo setValue:act forKey:AdViewNativeAdPdata];
        [nativeAdArray addObject:nativeInfo];
    }
    [self.adNativeManager adapter:self didReceivedNativeAd:nativeAdArray];
}
- (void)ad:(JDAd*)ad loadWithError:(JDAdError)error{
    [self.adNativeManager adapter:self failedRequestNativeAd:nil];
}
- (void)ad:(JDAd*)ad networkErrorState:(JDAdURLResponseStatus)state{
    if (JDAdURLResponseStatusSuccess != state) {
        AWLogInfo(@"JDBannerAdView fail");
        [self.adNativeManager adapter:self failedRequestNativeAd:nil];
    }
}
@end
