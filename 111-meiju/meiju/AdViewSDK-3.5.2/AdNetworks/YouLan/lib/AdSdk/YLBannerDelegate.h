//
//  BannerDelegate.h
//  AdSdk
//
//  Created by youlanad-sligner on 2017/9/5.
//  Copyright © 2017年 youlanad-sligner. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLBanner;

@protocol YLBannerDelegate <NSObject>
- (void)onClick:(YLBanner *)adView;
- (void)onRefresh:(YLBanner *)adView;
- (void)onAdSucessed:(UIView *)adView;
- (void)onAdFailed:(UIView *)adView;
- (void)browserClosed;
@end
