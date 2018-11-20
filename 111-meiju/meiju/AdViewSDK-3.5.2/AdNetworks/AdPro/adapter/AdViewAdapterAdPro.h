//
//  AdViewAdapterAdPro.h
//  AdViewAll
//
//  Created by 周桐 on 15/9/7.
//  Copyright (c) 2015年 unakayou. All rights reserved.
//

#import "AdViewAdNetworkAdapter.h"
#import <AdProSDK/AdProBannerView.h>

@interface AdViewAdapterAdPro : AdViewAdNetworkAdapter<AdProBannerViewDelegate>

+ (AdViewAdNetworkType)networkType;

@end
