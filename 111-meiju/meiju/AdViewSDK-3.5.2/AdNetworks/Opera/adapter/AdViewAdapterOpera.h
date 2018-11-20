//
//  AdViewAdapterGDTMob.h
//  AdViewSDK
//
//  Created by 马明 on 14-1-28.
//
//

#import "AdViewAdNetworkAdapter.h"
#import "BannerAdView.h"

@interface AdViewAdapterOpera : AdViewAdNetworkAdapter<OperaBannerAdDelegate> {
    BannerAdView *bannerView;
}

+ (AdViewAdNetworkType)networkType;

@end
