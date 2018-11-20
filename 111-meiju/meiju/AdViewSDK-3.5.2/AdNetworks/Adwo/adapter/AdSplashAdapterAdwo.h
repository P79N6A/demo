//
//  AdSplashAdapterBaidu.h
//  AdViewDevelop
//
//  Created by maming on 14-11-14.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdSpreadScreenAdNetworkAdapter.h"
#import <MandhelingSDK/AdwoAdSDK.h>

@interface AdSplashAdapterAdwo : AdSpreadScreenAdNetworkAdapter<AWAdViewDelegate>
{
    UIView *adWoSplash;
    BOOL mCanShowAd;
}

+ (AdSpreadScreenAdNetworkType)networkType;

@end
