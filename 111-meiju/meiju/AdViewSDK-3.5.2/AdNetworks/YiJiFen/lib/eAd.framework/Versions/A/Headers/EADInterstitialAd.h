//
//  EADInterstitialAd.h
//  eAd
//
//  Created by Emar on 3/19/15.
//  Copyright (c) 2015 Emar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol EADInterstitialAdDelegate;


@interface EADInterstitialAd : NSObject

@property (nonatomic, readonly, getter=isLoaded) BOOL loaded;

@property (weak, nonatomic) id<EADInterstitialAdDelegate> delegate;

- (void)startLoading;
- (void)presentFromViewController:(UIViewController *)viewController;

@end



/*!
 * @protocol EADSplashAdDelegate
 */
@protocol EADInterstitialAdDelegate <NSObject>
@optional

/*!
 * @method splashAdDidLoad:
 *
 * @discussion
 * 广告数据获取成功
 *
 */
- (void)interstitialAdDidLoad:(EADInterstitialAd *)interstitialAd;

/*!
 * @method splashAd:didFailWithError:
 *
 * @discussion
 * 广告数据获取失败
 *
 */
- (void)interstitialAd:(EADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error;

/*!
 * @method splashAdDidDisappear:
 *
 * @discussion
 * 插屏广告关闭
 *
 */
- (void)interstitialAdDidDisappear:(EADInterstitialAd *)interstitialAd;

@end