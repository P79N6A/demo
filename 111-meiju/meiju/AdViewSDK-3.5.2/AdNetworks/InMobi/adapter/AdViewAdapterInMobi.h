/*
 
 Adview .
 
 */

#import "AdViewAdNetworkAdapter.h"
#import <InMobiSDK/InMobiSDK.h>

@interface AdViewAdapterInMobi : AdViewAdNetworkAdapter<IMBannerDelegate> {
    
}

+ (AdViewAdNetworkType)networkType;

@end
