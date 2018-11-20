//
//  AdViewAdapterYJF.h
//  AdViewAll
//
//  Created by 张宇宁 on 15-3-16.
//  Copyright (c) 2015年 unakayou. All rights reserved.
//

#import "AdViewAdNetworkAdapter.h"
#import <eAd/eAd.h>
@interface AdViewAdapterYJF : AdViewAdNetworkAdapter<EADBannerViewDelegate>

@property (strong, nonatomic) EADBannerView *bannerAd;
+ (AdViewAdNetworkType)networkType;
@end
