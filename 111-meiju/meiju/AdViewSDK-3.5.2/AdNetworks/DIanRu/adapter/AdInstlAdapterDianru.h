//
//  AdInstlAdapterDianru.h
//  AdInstlSDK_iOS
//
//  Created by adview on 14-2-25.
//
//

#import "AdInstlAdNetworkAdapter.h"

#import "ZSDK.h"

@interface AdInstlAdapterDianru : AdInstlAdNetworkAdapter<ZDelegate>

+ (AdInstlAdNetworkType)networkType;

@property (nonatomic, strong) UIView * drView;
@property (nonatomic, assign) UIViewController *rootController;

@end
