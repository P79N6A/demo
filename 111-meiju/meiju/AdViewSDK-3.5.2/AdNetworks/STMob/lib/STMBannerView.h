//
//  STMBannerView.h
//  SuntengMobileAdsSDK
//
//  Created by Joe.
//  Copyright © 2016年 Sunteng Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMConstants.h"

NS_ASSUME_NONNULL_BEGIN

@protocol STMBannerViewDelegate;

///--------------------
/// @name STMBannerView
///--------------------

@interface STMBannerView : UIView

/**
 *  Create and return a `STMBannerView` instance.
 *
 *  @param publisherID The publisher ID.
 *  @param appID       The app ID.
 *  @param placementID The placement ID.
 *  @param appKey      The app key.
 *  @param frame       The banner view frame.
 *
 *  @return A `STMInterstitialAdController` instance.
 */
- (nullable instancetype)initWithPublisherID:(NSString *)publisherID
                                       appID:(NSString *)appID
                                 placementID:(NSString *)placementID
                                      appKey:(NSString *)appKey
                                       frame:(CGRect)frame;

- (instancetype)init __attribute__((unavailable("can not use `- init` method, please use `- initWithPublisherId:appId:placementId:appKey:frame:` method")));
+ (instancetype)new __attribute__((unavailable("can not use `+ new` method, please use `- initWithPublisherId:appId:placementId:appKey:frame:` method")));

/**
 *  The poublisher ID.
 */
@property (nonatomic, copy, readonly) NSString *publisherID;

/**
 *  The app ID.
 */
@property (nonatomic, copy, readonly) NSString *appID;

/**
 *  The placement ID.
 */
@property (nonatomic, copy, readonly) NSString *placementID;

/**
 *  The app key.
 */
@property (nonatomic, copy, readonly) NSString *appKey;

/**
 *  The `STMBannerView` delegate.
 */
@property (nullable, nonatomic, weak) id<STMBannerViewDelegate> delegate;

/**
 *  Check is ad loaded and ready to show.
 */
@property (nonatomic, assign, readonly, getter=isLoaded) BOOL loaded;

/**
 *  Load ad.
 */
- (void)loadAd;

/**
 *  Manual stop banner ad automatically refresh.
 *  Use this method when banner is not display in the window.
 *  For example, stop refresh ad when you push to another view controller.
 */
- (void)stopAutomaticallyRefreshingAd;

/**
 *  Resume banner ad automatically refresh.
 */
- (void)startAutomaticallyRefreshingAd;

@end

///----------------------------
/// @name STMBannerViewDelegate
///----------------------------

@protocol STMBannerViewDelegate <NSObject>

@optional

/**
 *  The banner ad loaded.
 *
 *  @param bannerView The `bannerView` instance.
 */
- (void)bannerViewDidLoadAd:(STMBannerView *)bannerView;

/**
 *  The banner ad load failed.
 *
 *  @param bannerView The `bannerView` instance.
 *  @param error      The error information of `bannerView` load fail.
 */
- (void)bannerView:(STMBannerView *)bannerView didFailToLoadAdWithError:(NSError *)error;

/**
 *  The banner ad tapped.
 *
 *  @param bannerView The `bannerView` instance.
 */
- (void)bannerViewDidTap:(STMBannerView *)bannerView;

/**
 *  The banner ad closed.
 *
 *  @param bannerView The `bannerView` instance.
 */
- (void)bannerViewDidDismiss:(STMBannerView *)bannerView;

@end

NS_ASSUME_NONNULL_END
