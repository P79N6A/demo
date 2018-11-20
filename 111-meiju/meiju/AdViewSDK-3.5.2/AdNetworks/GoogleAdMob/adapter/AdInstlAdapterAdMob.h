//
//  AdInstlAdapterAdMob.h
//  AdInstlSDK_iOS
//
//  Created by adview on 13-10-16.
//
//

#import "AdInstlAdNetworkAdapter.h"
#import <GoogleMobileAds/GADInterstitial.h>

@interface AdInstlAdapterAdMob : AdInstlAdNetworkAdapter<GADInterstitialDelegate>
{
    GADInterstitial *AdmobInstl;
}

@property (nonatomic, retain) GADInterstitial *AdmobInstl;
@property (nonatomic, weak) UIViewController * parent;

+ (AdInstlAdNetworkType)networkType;

@end
