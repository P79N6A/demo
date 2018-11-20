//
//  AdVideoAdapterInMobi.h
//  AdViewDevelop
//
//  Created by maming on 16/9/19.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdVideoAdNetworkAdapter.h"
#import <InMobiSDK/InMobiSDK.h>

@interface AdVideoAdapterInMobi : AdVideoAdNetworkAdapter<IMInterstitialDelegate>

@property (nonatomic, strong) IMInterstitial *imadVideo;

+ (AdVideoAdNetworkType)networkType;

@end
