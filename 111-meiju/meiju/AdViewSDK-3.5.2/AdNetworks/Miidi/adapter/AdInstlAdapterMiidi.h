//
//  AdinstlAdapterMiidi.h
//  AdViewAll
//
//  Created by 张宇宁 on 15-3-12.
//  Copyright (c) 2015年 unakayou. All rights reserved.
//

#import "AdInstlAdNetworkAdapter.h"

@interface AdInstlAdapterMiidi : AdInstlAdNetworkAdapter
{
    BOOL *isAdReady;
}
@property (nonatomic, weak) UIViewController * parent;
+ (AdInstlAdNetworkType)networkType;
@end
