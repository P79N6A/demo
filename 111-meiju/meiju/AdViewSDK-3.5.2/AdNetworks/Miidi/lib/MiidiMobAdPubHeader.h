//
//  MiidiMobAdPubHeader.h
//  MiidiMobAd
//
//  Created by yangheng_MacBookPro on 15/5/6.
//  Copyright (c) 2015年 org.iOS. All rights reserved.
//


#ifndef MiidiMobAd_MiidiMobAdPubHeader_h
#define MiidiMobAd_MiidiMobAdPubHeader_h

/**
 * +
 *  横幅广告*支持的尺寸如下
 * +
 */
@class UIView;

#define MiidiMobAdBannerViewSize            MobAdBannerSizeType
#define MiidiMobAdBannerViewSizeUnknow      MobAdBannerSizeType0
#define MiidiMobAdBannerViewSize320X50      MobAdBannerSizeType1
#define MiidiMobAdBannerViewSize50X50       MobAdBannerSizeType2
#define MiidiMobAdBannerViewSize200X200     MobAdBannerSizeType3
#define MiidiMobAdBannerViewSize460X72      MobAdBannerSizeType4
#define MiidiMobAdBannerViewSize768X72      MobAdBannerSizeType5


typedef NS_ENUM(NSInteger, MiidiMobAdBannerViewSize) {
    MiidiMobAdBannerViewSizeUnknow  = 0,
    MiidiMobAdBannerViewSize320X50  = 1,    // iPhone and iPod Touch (Recommend)
    
    MiidiMobAdBannerViewSize50X50   = 2,
    MiidiMobAdBannerViewSize200X200 = 3,
    
    MiidiMobAdBannerViewSize460X72  = 4,    // iPad Portrait    (Recommend)
    MiidiMobAdBannerViewSize768X72  = 5,    // iPad Landscape   (Recommend)
};

@protocol MiidiMobAdBannerDelegate <NSObject>


@optional

- (void)didMiidiBasBannerFinishLoad:(UIView *)banner;
- (void)didMiidiBasBannerFailedLoad:(UIView *)banner withMiidiBasError:(NSError *)error;

@end





#endif
