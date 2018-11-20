//
//  AdInstlAdapterGDTMob.h
//  AdInstlSDK_iOS
//
//  Created by ZhongyangYu on 14-9-28.
//
//

#import "AdInstlAdNetworkAdapter.h"
#import "PosterAdView.h"

@interface AdInstlAdapterOpera : AdInstlAdNetworkAdapter <OperaPosterAdDelegate>

@property (nonatomic, strong) PosterAdView * operaInstl;

@end
