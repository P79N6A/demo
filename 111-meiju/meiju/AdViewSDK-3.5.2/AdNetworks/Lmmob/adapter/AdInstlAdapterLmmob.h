//
//  AdInstlAdapterLmmob.h
//  AdInstlSDK_iOS
//
//  Created by Ma ming on 13-5-8.
//
//

#import "AdInstlAdNetworkAdapter.h"
#import <MBJoy/MBJoyView.h>

@interface AdInstlAdapterLmmob : AdInstlAdNetworkAdapter<MBJoyViewDelegate> {

}

@property (nonatomic, weak) UIViewController * parent;
@property (nonatomic, retain) MBJoyView * immobInstl;

+ (AdInstlAdNetworkType)networkType;

@end
