//
//  JDAd.h
//  JDAdSDKDemo
//
//  Created by Ben Miao on 15/11/7.
//  Copyright © 2015年 com.jd.dm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDAdConfigration.h"
@class JDAd;
@class JDAdView;
@class JDAdUser;
@class JDAdAppInfo;
@class JDAdDeviceInfo;
@class JDNativeAd;
@protocol JDAdDelegate <NSObject>
/**
 *  获取Native Ads
 *
 *  @param nativeAd
 */
- (void)nativeAd:(JDNativeAd*)nativeAd;
- (void)ad:(JDAd*)ad networkErrorState:(JDAdURLResponseStatus)state;
- (void)ad:(JDAd*)ad loadWithError:(JDAdError)error;

@end

@interface JDAd : NSObject
@property(nonatomic,assign) JDAdType adType; //广告类型
@property(nonatomic,strong) NSString* tagId; //广告位密钥
@property(nonatomic,weak) JDAdView *adView; //广告视图

@property(nonatomic,strong) JDAdUser *user;
@property(nonatomic,strong) JDAdDeviceInfo *device;
@property(nonatomic,strong) JDAdAppInfo *app;

@property(nonatomic,strong) id<JDAdDelegate> delegate;

- (void)loadAdView;

@end
