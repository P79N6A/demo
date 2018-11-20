//
//  JDAdManager.h
//  JDAdSDKDemo
//
//  Created by Ben Miao on 15/11/7.
//  Copyright © 2015年 com.jd.dm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import <UIKit/UIViewController.h>
#import "JDAdConfigration.h"

@class JDAd;
@class JDAdUser;
@class JDAdAppInfo;
@class JDBannerAdView;
@class JDModalAdView;
@class JDNativeAd;
@class JDAdsEntranceHandler;
@protocol JDAdDelegate;
@protocol JDAdViewDelegate;

@interface JDAdManager : NSObject
@property (nonatomic,strong) JDAdAppInfo *app;
@property (nonatomic,strong) JDAdUser *user;
@property (nonatomic,strong) NSMutableArray *selected;
@property (nonatomic,assign) BOOL istest;
@property (nonatomic,assign) BOOL isHttp;  //默认使用https，改值为YES时使用http。目前暂时只支持http
@property (nonatomic,assign) id<JDAdViewDelegate> adViewDelegate;
@property (nonatomic,assign) id<JDAdDelegate> adDelegate;

+ (instancetype) shareManager;

+ (NSString*) version;

/**
 *  注册的tagIDs
 *
 *  @param tagIDs 
 */
- (void)registerTagIDs:(NSArray*)tagIDs;


//Banner广告
/**
 *  默认方式：
 *  Banner广告默认为显示在底部
 *
 *  @param adSize         广告尺寸
 *  @param parent         添加的banner的View
 *  @param viewController 一个可以presenting的viewController,不使用游览器代理时，不能为空。
 *  @param tagid          广告位tagid
 *  @param closable       是否可关闭
 *
 *  @return JDBannerAdView
 */
- (JDBannerAdView*) createBannerAds:(JDAdSize) adSize
                         withParent:(UIView*) parent
                 withViewContorller:(UIViewController*) viewController
                          withTagid:(NSString*) tagid
                        andClosable:(BOOL) closable;

/**
 *  自定义方式1：
 *  AutoLayout
 可选择Bannner所在的位置
 若选择BannerLocateCustom，constraits不能为空，内容为VFL语言
 constraits[0]为水平方向约束
 constraits[1]为垂直方向违约
 */
- (JDBannerAdView*) createBannerAds:(JDAdSize) adSize
                         withParent:(UIView*) parent
                 withViewContorller:(UIViewController*) viewController
                           canClose:(BOOL) closable
                          withTagid:(NSString*) tagid
                       withPosition:(BannerPosition)position
                      andConstraits:(NSArray*) constraits;

/**
 *  自定义方式2：
 *  Frame
 */
- (JDBannerAdView*) createBannerAds:(JDAdSize) adSize
                         withParent:(UIView*) parent
                 withViewContorller:(UIViewController*) viewController
                          withTagid:(NSString*) tagid
                           canClose:(BOOL) closable
                           andFrame:(CGRect) frame;

/**
 *  当closable为NO时，用来移除banner广告，也可使用系统默认方法进行移除
 */
- (void) removeAllBannerAdsFromCurrentView:(UIView*) currentView;
- (void) removeBannerAd:(JDBannerAdView*) bannerView;


// 插屏广告
/**
 *  创建插屏广告
 *
 *  @param adSize         广告尺寸
 *  @param viewController 一个可以presenting的viewContorller，不使用浏览器代理，该值必须合法，用来presnet web页
 *  @param tagid          广告位tagid
 *  @param canClose       是否可以关闭
 *
 *
 *
 *  @return JDModalAdView
 */
- (JDModalAdView*) createModalAds:(JDAdSize) adSize
           withRootViewController:(UIViewController*) viewController
                         canClose:(BOOL)closable
                         andTagid:(NSString*) tagid;

/**
 * 该方法不建议使用SDK自带的关闭按钮，且该方法返回的JDModalView无法使用pop方法。
 */
- (JDModalAdView*) createModalAds:(JDAdSize) adSize
           withRootViewController:(UIViewController*) viewController
                        withFrame:(CGRect) frame
                         canClose:(BOOL)closable
                         andTagid:(NSString*) tagid;

//原生广告

/**
 *  获取原生广告
 *
 *  @param adSize 广告尺寸
 *  @param tagid  广告位tagid
 *  @param counts 请求个数
 *
 *  @return 返回JDNativeAd,获取的原生内容放在Contents中，Content中每个元素为JDNativeAdActor
 */
- (JDNativeAd*) getNativeAdsBySize:(CGSize) adSize
                         withTagid:(NSString*) tagid
                         andCounts:(NSInteger) counts;

@end
