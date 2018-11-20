//
//  AdInstlAdapterYJF.h
//  AdInstlSDK_iOS
//
//  Created by Ma ming on 13-3-13.
//
//

#import "AdInstlAdNetworkAdapter.h"
#import <eAd/eAd.h>


@interface AdInstlAdapterYJF : AdInstlAdNetworkAdapter<EADInterstitialAdDelegate>

+ (AdInstlAdNetworkType)networkType;
@property (strong, nonatomic) EADInterstitialAd *interstitialAd;
@property (nonatomic, weak) UIViewController * parent;
@end
