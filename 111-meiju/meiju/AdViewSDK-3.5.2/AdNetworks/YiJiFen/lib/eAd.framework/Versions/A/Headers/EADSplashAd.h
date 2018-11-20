//
//  EADSplashAd.h
//  eAd
//
//  Created by Emar on 3/19/15.
//  Copyright (c) 2015 Emar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol EADSplashAdDelegate;


@interface EADSplashAd : NSObject

@property (nonatomic, readonly, getter=isLoaded) BOOL loaded;

@property (weak, nonatomic) id<EADSplashAdDelegate> delegate;

- (void)startLoading;
- (void)presentFromViewController:(UIViewController *)viewController;

@end




/*!
 * @protocol EADSplashAdDelegate
 */
@protocol EADSplashAdDelegate <NSObject>
@optional

/*!
 * @method splashAdDidLoad:
 *
 * @discussion
 * 广告数据获取成功
 *
 */
- (void)splashAdDidLoad:(EADSplashAd *)splashAd;

/*!
 * @method splashAd:didFailWithError:
 *
 * @discussion
 * 广告数据获取失败
 *
 */
- (void)splashAd:(EADSplashAd *)splashAd didFailWithError:(NSError *)error;


/*!
 * @method splashAdDidDisappear:
 *
 * @discussion
 * 开屏广告关闭
 *
 */
- (void)splashAdDidDisappear:(EADSplashAd *)splashAd;

@end
