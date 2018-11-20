//
//  AdInstlAdapterGDTMob.h
//  AdInstlSDK_iOS
//
//  Created by ZhongyangYu on 14-9-28.
//
//

#import "AdInstlAdNetworkAdapter.h"
#import "GDTMobInterstitial.h"

@interface AdInstlAdapterGDTMob : AdInstlAdNetworkAdapter <GDTMobInterstitialDelegate>

@property (nonatomic, strong) GDTMobInterstitial * GDTMobInstl;

@end
