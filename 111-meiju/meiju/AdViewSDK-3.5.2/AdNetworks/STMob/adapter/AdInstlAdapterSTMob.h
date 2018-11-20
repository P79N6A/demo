//
//  AdInstlAdapterGDTMob.h
//  AdInstlSDK_iOS
//
//  Created by ZhongyangYu on 14-9-28.
//
//

#import "AdInstlAdNetworkAdapter.h"
#import "SuntengMobileAdsSDK.h"

@interface AdInstlAdapterSTMob : AdInstlAdNetworkAdapter <STMInterstitialAdControllerDelegate>

@property (nonatomic, strong) STMInterstitialAdController *interstitialAdController;

@property (nonatomic, strong) UIViewController *parent;

@end
