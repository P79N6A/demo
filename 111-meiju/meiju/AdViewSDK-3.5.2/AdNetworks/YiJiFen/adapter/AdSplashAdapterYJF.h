//
//  AdSplashAdapterBaidu.h
//  AdViewDevelop
//
//  Created by maming on 14-11-14.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdSpreadScreenAdNetworkAdapter.h"
#import <eAd/eAd.h>

@interface AdSplashAdapterYJF : AdSpreadScreenAdNetworkAdapter<EADSplashAdDelegate>{
}

+ (AdSpreadScreenAdNetworkType)networkType;

@property (nonatomic, strong) EADSplashAd *splashAd;
@property (nonatomic, weak) UIViewController * parent;

@end
