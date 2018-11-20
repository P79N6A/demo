//
//  AdSplashAdapterBaidu.h
//  AdViewDevelop
//
//  Created by maming on 14-11-14.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdSpreadScreenAdNetworkAdapter.h"
#import "SplashAdView.h"

@interface AdSplashAdapterOpera : AdSpreadScreenAdNetworkAdapter<OperaSplashAdDelegate>{
}

@property (nonatomic, strong) SplashAdView *splash;

+ (AdSpreadScreenAdNetworkType)networkType;

@end
