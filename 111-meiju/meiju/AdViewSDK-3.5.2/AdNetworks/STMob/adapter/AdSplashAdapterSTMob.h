//
//  AdSplashAdapterBaidu.h
//  AdViewDevelop
//
//  Created by maming on 14-11-14.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdSpreadScreenAdNetworkAdapter.h"
#import "SuntengMobileAdsSDK.h"

@interface AdSplashAdapterSTMob : AdSpreadScreenAdNetworkAdapter<STMSplashAdDelegate>{
}

@property (nonatomic, strong) STMSplashAd *splashAd;

+ (AdSpreadScreenAdNetworkType)networkType;

@end
