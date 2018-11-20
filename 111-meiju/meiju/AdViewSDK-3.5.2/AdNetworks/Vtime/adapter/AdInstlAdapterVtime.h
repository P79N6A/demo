//
//  AdInstlAdapterVtime.h
//  AdInstlSDK_iOS
//
//  Created by adview on 13-9-2.
//
//

#import <Foundation/Foundation.h>
#import "AdInstlAdNetworkAdapter.h"
#import "VTimeSDK.h"

@interface AdInstlAdapterVtime : AdInstlAdNetworkAdapter<VTimeSDKDelegate>

@property(nonatomic, weak)UIView *parent;
@property(nonatomic, weak)UIView *userView;
+(AdInstlAdNetworkType)networkType;

@end
