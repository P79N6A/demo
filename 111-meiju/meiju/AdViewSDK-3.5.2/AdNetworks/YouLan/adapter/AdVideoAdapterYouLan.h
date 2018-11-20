//
//  AdVideoAdapterChance.h
//  AdViewDevelop
//
//  Created by maming on 16/9/20.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdVideoAdNetworkAdapter.h"
#import "YLRewardedVideoDelegate.h"
#import "YLRewardedVideo.h"

@interface AdVideoAdapterYouLan : AdVideoAdNetworkAdapter<YLRewardedVideoDelegate>

@property (nonatomic,weak) UIViewController *parentVC;

@property(nonatomic, retain) YLRewardedVideo *video;

+ (AdVideoAdNetworkType)networkType;

@end
