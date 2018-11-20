//
//  AdSplashAdapterBaidu.h
//  AdViewDevelop
//
//  Created by maming on 14-11-14.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdSpreadScreenAdNetworkAdapter.h"
#import "GDTSplashAd.h"

@interface AdSplashAdapterGDTMob : AdSpreadScreenAdNetworkAdapter<GDTSplashAdDelegate>{
}

@property (nonatomic, strong) GDTSplashAd *splash;

+ (AdSpreadScreenAdNetworkType)networkType;

@end
