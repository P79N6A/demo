//
//  Video.h
//  AdSdk
//
//  Created by youlan-sligner on 2017/10/12.
//  Copyright © 2017年 youlanad-sligner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLVideoDelegate.h"

@interface YLVideo : UIView

+ (YLVideo *)initAdWithAdSpaceId:(NSString *)theAdSpaceId adSize:(CGSize)adSize minDuration:(int)minDuration maxDuration:(int)maxDuration  delegate:(id<YLVideoDelegate>)theDelegate frame:(CGRect)frame;
- (void)startRequest;
@end
