//
//  AdInstlAdapterGDTMob.h
//  AdInstlSDK_iOS
//
//  Created by ZhongyangYu on 14-9-28.
//
//

#import "AdInstlAdNetworkAdapter.h"
#import <MMAdSDK/MMAdSDK.h>

@interface AdInstlAdapterMillennialMedia : AdInstlAdNetworkAdapter <MMInterstitialDelegate>

@property (nonatomic, strong) UIViewController *parent;

@property (nonatomic, strong) MMInterstitialAd *interstitialAd;

@end
