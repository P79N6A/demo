//
//  AdInstlAdapterAderBaidu.h
//  AdInstlSDK_iOS
//
//  Created by adview on 13-10-24.
//
//

#import <BaiduMobAdSDK/BaiduMobAdCommonConfig.h>
#import <BaiduMobAdSDK/BaiduMobAdInterstitial.h>
#import "AdInstlAdNetworkAdapter.h"

@interface AdInstlAdapterBaidu : AdInstlAdNetworkAdapter<BaiduMobAdInterstitialDelegate>
{
    BaiduMobAdInterstitial *interstitialView;
}

@property (nonatomic,retain) BaiduMobAdInterstitial *interstitialView;

+ (AdInstlAdNetworkType)networkType;

@end
