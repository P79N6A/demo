//
//  AdInstlAdapterAdSmar.h
//  AdViewDevelop
//
//  Created by zhoutong on 16/8/11.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdInstlAdNetworkAdapter.h"
#import "InterstitialAd.h"
#import "AdDelegate.h"

@interface AdInstlAdapterAdSmar : AdInstlAdNetworkAdapter<AdDelegate> {
    
}

+ (AdInstlAdNetworkType)networkType;

@end
