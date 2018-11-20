//
//  AdVideoAdapterDomob.h
//  AdViewDevelop
//
//  Created by maming on 16/9/14.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdVideoAdNetworkAdapter.h"
#import <AppnextLib/AppnextLib.h>

@interface AdVideoAdapterAppnext : AdVideoAdNetworkAdapter<AppnextVideoAdDelegate> {}

+ (AdVideoAdNetworkType)networkType;

@property (nonatomic, strong) AppnextFullScreenVideoAd *fullScreen;

@end
