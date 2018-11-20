//
//  AdViewAdapterGDTMob.h
//  AdViewSDK
//
//  Created by 马明 on 14-1-28.
//
//

#import "AdViewAdNetworkAdapter.h"
#import "GDTMobBannerView.h"

@interface AdViewAdapterGDTMob : AdViewAdNetworkAdapter<GDTMobBannerViewDelegate> {
    
}

+ (AdViewAdNetworkType)networkType;

@end
