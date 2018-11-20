//
//  AdVideoAdapterInMobi.h
//  AdViewDevelop
//
//  Created by maming on 16/9/19.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdVideoAdNetworkAdapter.h"
#import "STVideoSDK.h"

@interface AdVideoAdapterSTMob : AdVideoAdNetworkAdapter<STFullScreenVideoSDKDelegate>

@property (nonatomic,strong) UIViewController *parent;
+ (AdVideoAdNetworkType)networkType;

@end
