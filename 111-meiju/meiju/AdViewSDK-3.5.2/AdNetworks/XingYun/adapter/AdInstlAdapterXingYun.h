//
//  AdInstlAdapterXingYun.h
//  AdViewAll
//
//  Created by 张宇宁 on 14-12-10.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//

#import "AdInstlAdNetworkAdapter.h"
#import <Walker/GuInitServer.h>
#import <Walker/PobAppFrame.h>
@interface AdInstlAdapterXingYun : AdInstlAdNetworkAdapter<PobAppFrameDelegate>

@property (nonatomic, weak) UIViewController *rootController;
@property (nonatomic, strong) GuInitServer * gunInitServer;
@property (nonatomic, strong) PobAppFrame  * pobAppFrame;
@end