/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#import <MBJoy/MBJoyView.h>

@interface AdViewAdapterImmob: AdViewAdNetworkAdapter<MBJoyViewDelegate> {
}
@property (nonatomic, strong) MBJoyView * MBJoyBanner;
@end
