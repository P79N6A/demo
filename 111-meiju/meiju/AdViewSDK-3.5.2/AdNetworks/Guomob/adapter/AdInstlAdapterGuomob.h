//
//  AdInstlAdapterGuomob.h
//  AdInstlSDK_iOS
//
//  Created by Ma ming on 13-5-2.
//
//

#import "AdInstlAdNetworkAdapter.h"
#import "GMInterstitialAD.h"

@interface AdInstlAdapterGuomob : AdInstlAdNetworkAdapter <GMInterstitialDelegate>
{
    GMInterstitialAD * guomobInstl;
}

@property (retain, nonatomic) GMInterstitialAD * guomobInstl;
@property (weak, nonatomic) UIViewController * parent;
@property (nonatomic, retain) UIButton *closeButton;

+ (AdInstlAdNetworkType)networkType;

@end
