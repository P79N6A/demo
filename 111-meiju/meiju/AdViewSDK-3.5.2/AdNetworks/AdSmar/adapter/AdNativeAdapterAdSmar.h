//
//  AdNativeAdapterAdSmar.h
//  AdViewDevelop
//
//  Created by zhoutong on 16/8/11.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdNativeAdNetworkAdapter.h"
#import "NativeAd.h"

@interface AdNativeAdapterAdSmar : AdNativeAdNetworkAdapter<NativeAdDelegate>

@property (nonatomic,strong) NativeAd *nativeAd;

+ (AdNativeAdNetworkType)networkType;

@end
