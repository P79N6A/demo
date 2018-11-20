//
//  AdViewAdapterAdSmar.h
//  AdViewDevelop
//
//  Created by zhoutong on 16/8/11.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdViewAdNetworkAdapter.h"
#import "BannerAd.h"
#import "AdDelegate.h"

@interface AdViewAdapterAdSmar : AdViewAdNetworkAdapter<AdDelegate> {
    
}

@property (nonatomic,strong) BannerAd* adView;

+ (AdViewAdNetworkType)networkType;

@end

