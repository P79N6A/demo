//
//  Banner.h
//  AdSdk
//
//  Created by youlanad-sligner on 2017/9/5.
//  Copyright © 2017年 youlanad-sligner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YLBannerDelegate.h"

@interface YLBanner : UIView
+ (YLBanner *)initAdWithAdSpaceId:(NSString *)theAdSpaceId adSize:(CGSize)adSize delegate:(id<YLBannerDelegate>)theDelegate frame:(CGRect)frame;

- (void)startRequest;
- (void)stopRequest;
@end
