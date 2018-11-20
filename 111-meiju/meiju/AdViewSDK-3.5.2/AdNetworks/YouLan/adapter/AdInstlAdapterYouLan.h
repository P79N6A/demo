//
//  AdInstlAdapterGDTMob.h
//  AdInstlSDK_iOS
//
//  Created by ZhongyangYu on 14-9-28.
//
//

#import "AdInstlAdNetworkAdapter.h"
#import "YLIntersitial.h"

@interface AdInstlAdapterYouLan : AdInstlAdNetworkAdapter <YLIntersitialDelegate>

@property (nonatomic, strong) YLIntersitial * intersitial;

@property (nonatomic, assign)BOOL isReady;

@end
