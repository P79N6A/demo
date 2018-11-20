/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#import <MandhelingSDK/AdwoAdSDK.h>

@interface AdViewAdapterAdwo : AdViewAdNetworkAdapter <AWAdViewDelegate> {
}

+ (AdViewAdNetworkType)networkType;

@end
