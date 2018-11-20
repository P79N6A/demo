//
//  Intersitial.h
//  AdSdk
//
//  Created by youlan-sligner on 2017/10/12.
//  Copyright © 2017年 youlanad-sligner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLIntersitialDelegate.h"

@interface YLIntersitial : UIView

+ (YLIntersitial *)initAdWithAdSpaceId:(NSString *)theAdSpaceId adSize:(CGSize)adSize delegate:(id<YLIntersitialDelegate>)theDelegate frame:(CGRect)frame;
- (void)startRequest;
@end
