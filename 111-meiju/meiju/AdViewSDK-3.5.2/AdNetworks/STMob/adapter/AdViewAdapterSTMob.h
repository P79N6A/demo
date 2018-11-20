//
//  AdViewAdapterGDTMob.h
//  AdViewSDK
//
//  Created by 马明 on 14-1-28.
//
//

#import "AdViewAdNetworkAdapter.h"
#import "STMBannerView.h"

@interface AdViewAdapterSTMob : AdViewAdNetworkAdapter<STMBannerViewDelegate> {
    
}

@property (nonatomic, strong) STMBannerView *bannerAdView;

+ (AdViewAdNetworkType)networkType;

@end
