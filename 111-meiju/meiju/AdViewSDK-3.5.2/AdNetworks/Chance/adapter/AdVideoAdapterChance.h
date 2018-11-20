//
//  AdVideoAdapterChance.h
//  AdViewDevelop
//
//  Created by maming on 16/9/20.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdVideoAdNetworkAdapter.h"
#import "CSVideoAD.h"
#import "ChanceAd.h"

@interface AdVideoAdapterChance : AdVideoAdNetworkAdapter<CSVideoADDelegate>

+ (AdVideoAdNetworkType)networkType;

@end
