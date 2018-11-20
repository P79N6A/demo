//
//  VideoDelegate.h
//  AdSdk
//
//  Created by youlan-sligner on 2017/10/12.
//  Copyright © 2017年 youlanad-sligner. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YLVideoDelegate <NSObject>
- (void)onClick:(UIView *)adView;
- (void)onAdSucessed:(UIView *)adView;
- (void)onAdFailed:(UIView *)adView;
- (void)onAdClose;
- (void)browserClosed;
@end
