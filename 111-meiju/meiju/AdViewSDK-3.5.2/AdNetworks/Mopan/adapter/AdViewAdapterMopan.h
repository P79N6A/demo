//
//  AdViewAdapterMopan.h
//  AdViewAll
//
//  Created by 周桐 on 15/11/23.
//  Copyright © 2015年 unakayou. All rights reserved.
//

#import "AdViewAdNetworkAdapter.h"
#import "MopSplashOfbusecation.h"

@interface AdViewAdapterMopan : AdViewAdNetworkAdapter

@property (nonatomic,strong) UIView *mopanView;

+ (AdViewAdNetworkType)networkType;

@end
