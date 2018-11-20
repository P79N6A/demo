//
//  AdinstlAdapterMiidi.h
//  AdViewAll
//
//  Created by 张宇宁 on 15-4-21.
//  Copyright (c) 2015年 unakayou. All rights reserved.
//

#import "AdViewAdNetworkAdapter.h"
#import "ZSDK.h"

@interface AdViewAdapterDianru : AdViewAdNetworkAdapter<ZDelegate>{
}

+ (AdViewAdNetworkType)networkType;
@property (nonatomic,retain) UIViewController *vc;
@end
