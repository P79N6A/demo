//
//  AdViewAdapterJDAview.h
//  AdViewAll
//
//  Created by 周桐 on 15/11/20.
//  Copyright © 2015年 unakayou. All rights reserved.
//

#import "AdViewAdNetworkAdapter.h"
#import <JDAdSDK/JDAdSDK.h>

@interface AdViewAdapterJDAdview : AdViewAdNetworkAdapter<JDAdViewDelegate,JDAdDelegate>

+ (AdViewAdNetworkType)networkType;

@property (nonatomic,strong) JDBannerAdView *banner;

@end
