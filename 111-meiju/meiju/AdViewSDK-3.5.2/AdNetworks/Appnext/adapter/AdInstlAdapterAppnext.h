//
//  AdInstlAdapterGDTMob.h
//  AdInstlSDK_iOS
//
//  Created by ZhongyangYu on 14-9-28.
//
//

#import "AdInstlAdNetworkAdapter.h"
#import <AppnextLib/AppnextLib.h>

@interface AdInstlAdapterAppnext : AdInstlAdNetworkAdapter <AppnextVideoAdDelegate>

@property (nonatomic, strong) AppnextInterstitialAd *interstitial;

@end
