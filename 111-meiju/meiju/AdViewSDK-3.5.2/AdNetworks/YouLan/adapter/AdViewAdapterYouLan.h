//
//  AdViewAdapterGDTMob.h
//  AdViewSDK
//
//  Created by 马明 on 14-1-28.
//
//

#import "AdViewAdNetworkAdapter.h"
#import "YLBanner.h"

@interface AdViewAdapterYouLan : AdViewAdNetworkAdapter<YLBannerDelegate> {
    
}

+ (AdViewAdNetworkType)networkType;

@end
