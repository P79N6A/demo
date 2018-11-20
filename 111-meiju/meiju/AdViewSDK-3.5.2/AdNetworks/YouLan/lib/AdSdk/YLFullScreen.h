//
//  FullScreen.h
//  AdSdk
//
//  Created by youlan-sligner on 2017/10/12.
//  Copyright © 2017年 youlanad-sligner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YLFullScreenDelegate.h"

@interface YLFullScreen : UIView
+ (YLFullScreen *)initAdWithAdSpaceId:(NSString *)theAdSpaceId adSize:(CGSize)adSize delegate:(id<YLFullScreenDelegate>)theDelegate;
- (void)startRequest;
@end
