//
//  AdInstlAdapterPingcoo.h
//  AdInstlSDK_iOS
//
//  Created by adview on 13-9-2.
//
//

#import <Foundation/Foundation.h>
#import "AdInstlAdNetworkAdapter.h"
#import "pingcooSDK.h"

@interface AdInstlAdapterPingcoo : AdInstlAdNetworkAdapter<pingcooSDKDelegate>
{
     pingcooSDK *pingcoo;
}

+(AdInstlAdNetworkType)networkType;

@property (nonatomic, weak) UIViewController * parent;

@end
