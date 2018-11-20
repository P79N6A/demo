//
//  AdVideoAdapterChance.h
//  AdViewDevelop
//
//  Created by maming on 16/9/20.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdVideoAdNetworkAdapter.h"
#import <AdColony/AdColony.h>

@interface AdVideoAdapterAdColony : AdVideoAdNetworkAdapter

@property (nonatomic,weak) UIViewController *parentVC;

@property (nonatomic,weak) AdColonyInterstitial *adColonyVideo;

+ (AdVideoAdNetworkType)networkType;

@end
