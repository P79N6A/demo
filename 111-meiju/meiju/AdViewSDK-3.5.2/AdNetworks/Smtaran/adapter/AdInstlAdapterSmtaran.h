//
//  AdInstlAdapterSmtaran.h
//  AdInstlSDK_iOS
//
//  Created by Ma ming on 13-5-31.
//
//

#import "AdInstlAdNetworkAdapter.h"
#import "SmtaranSDKManager.h"
#import "SmtaranInterstitialAd.h"


@interface AdInstlAdapterSmtaran : AdInstlAdNetworkAdapter <SmtaranInterstitialAdDelegate> {
    BOOL isStatusHidden;
}

@property (retain, nonatomic) SmtaranInterstitialAd * SmtaranView;
@property (weak, nonatomic) UIViewController *parent;
@property (nonatomic, assign) BOOL isStatusHidden;

+ (AdInstlAdNetworkType)networkType;

@end
