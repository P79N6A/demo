//
//  AdNativeAdapterGDTMob.h
//  AdViewDevelop
//
//  Created by maming on 15/12/25.
//  Copyright © 2015年 maming. All rights reserved.
//

#import "AdNativeAdNetworkAdapter.h"
#import <InMobiSDK/InMobiSDK.h>

@interface AdNativeAdapterInMobi : AdNativeAdNetworkAdapter <IMNativeDelegate> {
}

@property (strong, nonatomic) IMNative *nativeAd;

+ (AdNativeAdNetworkType)networkType;

@end
