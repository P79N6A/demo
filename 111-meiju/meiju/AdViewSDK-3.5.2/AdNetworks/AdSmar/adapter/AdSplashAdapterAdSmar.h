//
//  AdSplashAdapterAdSmar.h
//  AdViewDevelop
//
//  Created by zhoutong on 16/8/11.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdSpreadScreenAdNetworkAdapter.h"
#import "FullScreenAd.h"
#import "AdDelegate.h"

@interface AdSplashAdapterAdSmar : AdSpreadScreenAdNetworkAdapter<AdDelegate>

@property(nonatomic,strong) NSTimer *timer;

@end
