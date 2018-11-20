//
//  AdInstlAdapterJDAview.h
//  AdViewAll
//
//  Created by 周桐 on 15/11/20.
//  Copyright © 2015年 unakayou. All rights reserved.
//

#import "AdInstlAdNetworkAdapter.h"
#import <JDAdSDK/JDAdSDK.h>

@interface AdInstlAdapterJDAdview : AdInstlAdNetworkAdapter<JDAdViewDelegate,JDAdDelegate>

+ (AdInstlAdNetworkType)networkType;

@property (nonatomic,strong) JDModalAdView *jdInstl;

@end
