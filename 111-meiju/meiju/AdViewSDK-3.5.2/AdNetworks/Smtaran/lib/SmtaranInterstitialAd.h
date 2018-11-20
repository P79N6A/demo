//
//  InterstitialAd.h
//  ios_sdk
//
//  Created by xueli on 15/4/23.
//  Copyright (c) 2015年 fwang. All rights reserved.
//

typedef NS_ENUM(NSInteger, SmtaranInterstitialAdSize) {
    
    SmtaranInterstitialAdSizeNormal,    // for iPhone 300*250 iPad 600*500
    SmtaranInterstitialAdSizeLarge,     // for iPhone 320*480 iPad 640*960
    
};

@class SmtaranInterstitialAd;

@protocol SmtaranInterstitialAdDelegate <NSObject>

@optional

/**
 *  adInterstitial被点击
 *  @param adInterstitial
 */
- (void)smtaranInterstitialAdClick:(SmtaranInterstitialAd *)adInterstitial;

/**
 *  adInterstitial被关闭
 *  @param adInterstitial
 */
- (void)smtaranInterstitialAdClose:(SmtaranInterstitialAd *)adInterstitial;

/**
 *  adInterstitial请求成功
 *  @param adInterstitial
 */
- (void)smtaranInterstitialAdSuccessToRequest:(SmtaranInterstitialAd *)adInterstitial;

/**
 *  adInterstitial请求失败
 *  @param adInterstitial
 */
- (void)smtaranInterstitialAdFaildToRequest:(SmtaranInterstitialAd *)adInterstitial withError:(NSError*) error;

@end

@interface SmtaranInterstitialAd : UIView

@property(nonatomic, assign) id<SmtaranInterstitialAdDelegate> delegate;

/**
 *  初始化并请求插屏广告
 *  @param adSize 广告视图大小
 *  @param delegate 该广告所使用的委托
 *  @param slotToken 插屏广告位id
 */
- (id)initInterstitialAdSize:(SmtaranInterstitialAdSize)adSize
                    delegate:(id<SmtaranInterstitialAdDelegate>)delegate
                   slotToken:(NSString *)slotToken;

/**
 *  展示插屏广告
 */
- (void)showInterstitialAd;

@end
