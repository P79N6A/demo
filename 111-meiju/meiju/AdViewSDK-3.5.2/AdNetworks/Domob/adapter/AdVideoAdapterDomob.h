//
//  AdVideoAdapterDomob.h
//  AdViewDevelop
//
//  Created by maming on 16/9/14.
//  Copyright © 2016年 maming. All rights reserved.
//

#import "AdVideoAdNetworkAdapter.h"
#import "IndependentVideoManager.h"

@interface AdVideoAdapterDomob : AdVideoAdNetworkAdapter<IndependentVideoManagerDelegate> {}

+ (AdVideoAdNetworkType)networkType;
@property (nonatomic, weak) UIViewController *rootController;
@property (nonatomic, strong) IndependentVideoManager *manager;
@property (nonatomic, assign) BOOL isFinishLoad;
@property (nonatomic, assign) BOOL failedLoad;

@property (nonatomic,strong) NSTimer *timer;

@end
