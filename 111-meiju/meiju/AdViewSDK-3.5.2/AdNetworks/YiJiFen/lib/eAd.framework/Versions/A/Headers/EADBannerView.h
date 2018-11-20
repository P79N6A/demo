//
//  EADBannerView.h
//  eAd
//
//  Created by Emar on 3/18/15.
//  Copyright (c) 2015 Emar. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EADBannerViewDelegate;


@interface EADBannerView : UIView

#pragma mark Pre-Request

@property (weak, nonatomic) UIViewController *rootViewController;

@property (weak, nonatomic) id<EADBannerViewDelegate> delegate;


@end





/*!
 * @protocol ADBannerViewDelegate
 */
@protocol EADBannerViewDelegate <NSObject>
@optional

/*!
 * @method bannerViewWillLoadAd:
 *
 * @discussion
 * 广告数据加载成功，开始准备展示
 *
 */
- (void)bannerViewWillLoadAd:(EADBannerView *)banner;

/*!
 * @method bannerViewDidLoadAd:
 *
 * @discussion
 * 广告准备完毕，即将展示
 *
 */
- (void)bannerViewDidLoadAd:(EADBannerView *)banner;

/*!
 * @method bannerView:didFailToReceiveAdWithError:
 *
 * @discussion
 * 广告数据获取失败，将不会有广告展示
 *
 */
- (void)bannerView:(EADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error;

@end