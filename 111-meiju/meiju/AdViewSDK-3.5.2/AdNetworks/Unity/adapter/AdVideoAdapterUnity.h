//
//  AdVideoAdapterChance.h
//  AdViewDevelop
//
//  Created by maming on 16/9/20.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdVideoAdNetworkAdapter.h"
#import <UnityAds/UnityAds.h>

#if 1 //修改此处可以变更激励非激烈视频 1为非激励
#define PlacementId(placementId)   ([placementId isEqualToString:@"video"] || [placementId isEqualToString:@"defaultZone"] || [placementId isEqualToString:@"defaultVideoAndPictureZone"])
#else
#define PlacementId(placementId)   ([placementId isEqualToString:@"rewardedVideo"] || [placementId isEqualToString:@"rewardedVideoZone"] || [placementId isEqualToString:@"incentivizedZone"])
#endif

@interface AdVideoAdapterUnity : AdVideoAdNetworkAdapter<UnityAdsDelegate>

@property (nonatomic,strong) UIViewController *parentVC;

@property (nonatomic,strong) NSString *placementId;

+ (AdVideoAdNetworkType)networkType;

@end
