//
//  AdInstlAdapterAdSmar.h
//  AdViewDevelop
//
//  Created by zhoutong on 16/8/11.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdInstlAdNetworkAdapter.h"
#import <MobFoxSDKCore/MobFoxSDKCore.h>


@interface AdInstlAdapterMobFox : AdInstlAdNetworkAdapter<MobFoxInterstitialAdDelegate> {
    
}

+ (AdInstlAdNetworkType)networkType;

@property (nonatomic,strong) MobFoxInterstitialAd *mobfoxInterAd;

@property (nonatomic,strong) NSTimer *timer;

@end
