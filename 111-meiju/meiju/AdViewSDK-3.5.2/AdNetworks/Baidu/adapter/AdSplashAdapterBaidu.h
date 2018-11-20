//
//  AdSplashAdapterBaidu.h
//  AdViewDevelop
//
//  Created by maming on 14-11-14.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdSpreadScreenAdNetworkAdapter.h"
#import <BaiduMobAdSDK/BaiduMobAdSplash.h>

@interface AdSplashAdapterBaidu : AdSpreadScreenAdNetworkAdapter<BaiduMobAdSplashDelegate>{
}

@property (nonatomic, strong) BaiduMobAdSplash *splash;

+ (AdSpreadScreenAdNetworkType)networkType;

@end
