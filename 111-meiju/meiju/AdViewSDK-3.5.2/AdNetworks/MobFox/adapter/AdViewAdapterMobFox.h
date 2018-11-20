//
//  AdViewAdapterAdSmar.h
//  AdViewDevelop
//
//  Created by zhoutong on 16/8/11.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdViewAdNetworkAdapter.h"
#import <MobFoxSDKCore/MobFoxSDKCore.h>

@interface AdViewAdapterMobFox : AdViewAdNetworkAdapter<MobFoxAdDelegate> {
    
}

@property (strong, nonatomic) MobFoxAd *mobfoxAd;

+ (AdViewAdNetworkType)networkType;

@end

