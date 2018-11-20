//
//  AdSplashAdapterBaidu.h
//  AdViewDevelop
//
//  Created by maming on 14-11-14.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdSpreadScreenAdNetworkAdapter.h"
#import "DMSplashAdController.h"
#import "DMRTSplashAdController.h"

@interface AdSplashAdapterDomob : AdSpreadScreenAdNetworkAdapter<DMSplashAdControllerDelegate>{
}

@property (nonatomic, strong) DMSplashAdController *splashAd;

+ (AdSpreadScreenAdNetworkType)networkType;

@end
