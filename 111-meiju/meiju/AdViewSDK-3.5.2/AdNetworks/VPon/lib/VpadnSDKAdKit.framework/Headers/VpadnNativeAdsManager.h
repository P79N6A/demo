//
//  VpadnNativeAdsManager.h
//  iphone-vpon-sdk
//
//  Created by Mike Chou on 5/19/16.
//  Copyright © 2016 com.vpon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VpadnNativeAd.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VpadnNativeAdsManagerDelegate <NSObject>

- (void)onVpadnNativeAdsReceived;
- (void)onVpadnNativeAdsFailedToLoadWithError:(NSError *)error;

@end

@interface VpadnNativeAdsManager : NSObject

@property (nonatomic, weak, nullable) id <VpadnNativeAdsManagerDelegate> delegate;
@property (nonatomic, assign, readonly) NSUInteger uniqueNativeAdCount;
@property (nonatomic, copy, readonly) NSString *strBannerID;
@property (nonatomic, copy, readonly) NSString *platform;
@property (nonatomic, assign, readonly) BOOL bShowTestLog;

- (id)initWithBannerID:(NSString *)bannerID platform:(NSString *)platform forNumAdsRequested:(NSUInteger)numAdsRequested;
- (id)initWithBannerID:(NSString *)bannerID forNumAdsRequested:(NSUInteger)numAdsRequested;

- (void)loadAds;
- (void)loadAdsWithTestIdentifiers:(NSArray *)arrayTestIdentifiers;
- (BOOL)isReady;
- (nullable VpadnNativeAd *)nextNativeAd;
- (void)showTestLog:(BOOL)bShow;

@end
NS_ASSUME_NONNULL_END
