//
//  AdInstlAdapterGuoHe.h
//  AdInstlSDK_iOS
//
//  Created by Ma ming on 13-5-16.
//
//

#import "AdInstlAdNetworkAdapter.h"
#import "GuoHeadInterstitialSDK.h"

@interface AdInstlAdapterGuoHe : AdInstlAdNetworkAdapter<GuoHeadInterstitialSDKDelegate> {
    
}

+ (AdInstlAdNetworkType)networkType;

@end
