//
//  AdInstlAdapterChance.h
//  AdInstlSDK_iOS
//
//  Created by adview on 13-7-8.
//
//

#import "AdInstlAdNetworkAdapter.h"
#import "CSInterstitial.h"
#import "ChanceAd.h"

@interface AdInstlAdapterChance : AdInstlAdNetworkAdapter<CSInterstitialDelegate>
{
    
}

+ (AdInstlAdNetworkType)networkType;
@property (weak, nonatomic) UIView *parent;
@end
