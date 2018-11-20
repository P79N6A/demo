//
//  STMNativeAd.h
//  SuntengMobileAdsSDK
//
//  Created by Joe.
//  Copyright © 2016年 Sunteng Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STMConstants.h"
#import "STMNativeAdView.h"
#import "STMNativeAdImage.h"

NS_ASSUME_NONNULL_BEGIN

@protocol STMNativeAdDelegate;

///------------------
/// @name STMNativeAd
///------------------

@interface STMNativeAd : NSObject


/**
 Create and return a `STMNativeAd` instance.

 @param publisherID The publisher ID.
 @param appID The app ID.
 @param placementID The placement ID.
 @param appKey The app key.
 @return A `STMNativeAd` instance.
 */
- (nullable instancetype)initWithPublisherID:(NSString *)publisherID
                                       appID:(NSString *)appID
                                 placementID:(NSString *)placementID
                                      appKey:(NSString *)appKey;

- (instancetype)init __attribute__((unavailable("can not use `- init` method, please use `+ nativeAdWithPublisherID:appID:placementID:appKey:` method")));
+ (instancetype)new __attribute__((unavailable("can not use `+ new` method, please use `+ nativeAdWithPublisherID:appID:placementID:appKey:` method")));

/**
 *  The publisher ID.
 */
@property (nonatomic, strong, readonly) NSString *publisherID;

/**
 *  The app ID.
 */
@property (nonatomic, strong, readonly) NSString *appID;

/**
 *  The placement ID.
 */
@property (nonatomic, strong, readonly) NSString *placementID;

/**
 *  The appKey.
 */
@property (nonatomic, strong, readonly) NSString *appKey;

/**
 *  The `STMNativeAd` delegate.
 */
@property (nullable, nonatomic, weak) id<STMNativeAdDelegate> delegate;


/**
 Disable automatically download native ad images.
 */
- (void)disableImageLoading;


/**
 Register native ad view.

 @param nativeAdView The native ad view.
 @param viewController Ad present from this controller.
 */
- (void)registerNativeAdView:(STMNativeAdView *)nativeAdView withViewController:(UIViewController *)viewController;

/**
 *  Load ad.
 */
- (void)loadAd;

/**
 *  Check is ad loaded and ready to show.
 */
- (BOOL)isValid;

@property (nullable, nonatomic, strong, readonly) STMNativeAdImage *logo;
@property (nullable, nonatomic, strong, readonly) NSString *title;
@property (nullable, nonatomic, strong, readonly) NSString *detail;
@property (nullable, nonatomic, strong, readonly) STMNativeAdImage *icon;
@property (nullable, nonatomic, strong, readonly) NSString *action;
@property (nullable, nonatomic, strong, readonly) NSArray<STMNativeAdImage *> *images;

@end

///--------------------------
/// @name STMNativeAdDelegate
///--------------------------

@protocol STMNativeAdDelegate <NSObject>

@optional


/**
 The native ad loaded.

 @param nativeAd The `STMNativeAd` instance.
 */
- (void)nativeAdDidLoad:(STMNativeAd *)nativeAd;


/**
 The native ad load failed.

 @param nativeAd The `STMNativeAd` instance.
 @param error Error show why native ad load failed.
 */
- (void)nativeAd:(STMNativeAd *)nativeAd didLoadFailWithError:(NSError *)error;


/**
 The native ad presented.

 @param nativeAd The `STMNativeAd` instance.
 */
- (void)nativeAdDidPresent:(STMNativeAd *)nativeAd;


/**
 The native ad tapped.

 @param nativeAd The `STMNativeAd` instance.
 */
- (void)nativeAdDidTap:(STMNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END
