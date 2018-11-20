//
//  AdNativeAdapterGDTMob.h
//  AdViewDevelop
//
//  Created by maming on 15/12/25.
//  Copyright © 2015年 maming. All rights reserved.
//

#import "AdNativeAdNetworkAdapter.h"
#import "GDTNativeAd.h"

@interface AdNativeAdapterGDTMob : AdNativeAdNetworkAdapter <GDTNativeAdDelegate> {
}

@property (strong, nonatomic) GDTNativeAd *nativeAd;

+ (AdNativeAdNetworkType)networkType;

@end
