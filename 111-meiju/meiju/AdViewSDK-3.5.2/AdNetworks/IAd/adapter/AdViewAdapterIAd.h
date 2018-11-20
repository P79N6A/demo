/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#import <iAd/iAd.h>

@interface AdViewAdapterIAd : AdViewAdNetworkAdapter <ADBannerViewDelegate> {
	
}

+ (AdViewAdNetworkType)networkType;

@end
