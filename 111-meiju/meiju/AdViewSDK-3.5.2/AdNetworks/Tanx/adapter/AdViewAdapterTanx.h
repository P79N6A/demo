//
//  AdViewAdapterTanx.h
//  AdViewDevelop
//
//  Created by maming on 14-11-17.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdViewAdNetworkAdapter.h"
#import "MMUBannerView.h"

@interface AdViewAdapterTanx : AdViewAdNetworkAdapter<MMUBannerViewDelegate>{
}

+ (AdViewAdNetworkType)networkType;

@end
