//
//  SmtaranBannerAd.h
//  ios_sdk
//
//  Created by xueli on 15/5/5.
//  Copyright (c) 2015年 fwang. All rights reserved.
//


typedef NS_ENUM(NSInteger, SmtaranBannerAdSize) {
    
    SmtaranBannerAdSizeNormal,  //for iPhone 320X50  iPhone6 375*50 iPhone6 Plus 414*50  iPad 728X90
    SmtaranBannerAdSizeLarge,   //for iPhone 320X50  iPhone6 375*58 iPhone6 Plus 414*64  iPad 728X90
    
};

typedef NS_ENUM(NSInteger, SmtaranBannerAdRefreshTime) {
    
    SmtaranBannerAdRefreshTimeNone,         //不刷新
    SmtaranBannerAdRefreshTimeHalfMinute,   //30秒刷新
    SmtaranBannerAdRefreshTimeOneMinute,    //60秒刷新
    
};

typedef NS_ENUM(NSInteger, SmtaranBannerAdAnimationType) {
    
    SmtaranBannerAdAnimationTypeNone    = -1,   //无动画
    SmtaranBannerAdAnimationTypeRandom  = 1,    //随机动画
    SmtaranBannerAdAnimationTypeFade    = 2,    //渐隐渐现
    SmtaranBannerAdAnimationTypeCubeT2B = 3,    //立体翻转从左到右
    SmtaranBannerAdAnimationTypeCubeL2R = 4,    //立体翻转从上到下
    
};

@class SmtaranBannerAd;

@protocol SmtaranBannerAdDelegate <NSObject>

@optional
/**
 *  adBanner被点击
 *  @param adBanner
 */
- (void)smtaranBannerAdClick:(SmtaranBannerAd*)adBanner;

/**
 *  adBanner请求成功并展示广告
 *  @param adBanner
 */
- (void)smtaranBannerAdSuccessToShowAd:(SmtaranBannerAd*)adBanner;

/**
 *  adBanner请求失败
 *  @param adBanner
 */
- (void)smtaranBannerAdFaildToShowAd:(SmtaranBannerAd*)adBanner withError:(NSError*) error;

/**
 *  adBanner被点击后弹出LandingPage
 *  @param adBanner
 */
- (void)smtaranBannerLandingPageShowed:(SmtaranBannerAd*)adBanner;

/**
 *  adBanner弹出的LandingPage被关闭
 *  @param adBanner
 */
- (void)smtaranBannerLandingPageHided:(SmtaranBannerAd*)adBanner;

@end

@interface SmtaranBannerAd : UIView

@property(nonatomic, assign) id<SmtaranBannerAdDelegate> delegate;

/**
 *  初始化并请求横幅广告
 *  @param adSize 广告视图大小
 *  @param delegate 该广告所使用的委托
 *  @param slotToken 横幅广告位id
 */
- (id)initBannerAdSize:(SmtaranBannerAdSize)adSize
              delegate:(id<SmtaranBannerAdDelegate>)delegate
             slotToken:(NSString *)slotToken;
/**
 *  设置广告刷新间隔时间
 *  @param refreshTime 广告刷新间隔时间，单位是“秒”
 */
- (void)setBannerAdRefreshTime:(SmtaranBannerAdRefreshTime)refreshTime;

/**
 *  设置多个广告之间过渡（切换）效果
 *  @param animationType	多个广告之间过渡（切换）效果
 */
- (void)setBannerAdAnimeType:(SmtaranBannerAdAnimationType)animationType;


@end
