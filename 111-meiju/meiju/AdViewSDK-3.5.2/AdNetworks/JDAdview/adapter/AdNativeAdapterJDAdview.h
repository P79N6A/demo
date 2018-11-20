//
//  AdNativeAdapterGDTMob.h
//  AdViewDevelop
//
//  Created by maming on 15/12/25.
//  Copyright © 2015年 maming. All rights reserved.
//

#import "AdNativeAdNetworkAdapter.h"
#import <JDAdSDK/JDAdSDK.h>

@interface AdNativeAdapterJDAdview : AdNativeAdNetworkAdapter<JDAdDelegate>  {
}

@property (strong, nonatomic) JDNativeAd *nativeAd;

+ (AdNativeAdNetworkType)networkType;

@end
