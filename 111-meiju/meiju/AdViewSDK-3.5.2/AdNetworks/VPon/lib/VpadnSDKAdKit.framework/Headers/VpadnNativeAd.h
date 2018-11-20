//
//  VpadnNativeAd.h
//  iphone-vpon-sdk
//
//  Created by vpon-MI on 2014/7/2.
//  Copyright (c) 2014年 com.vpon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VpadnBanner.h"

NS_ASSUME_NONNULL_BEGIN

@class VpadnNativeAd, VpadnAdImage;

@protocol VpadnNativeAdDelegate <NSObject>

@optional
- (void)onVpadnNativeGetAd:(VpadnNativeAd *)nativeAd;
- (void)onVpadnNativeAdReceived:(VpadnNativeAd *)nativeAd;
- (void)onVpadnNativeAd:(VpadnNativeAd *)nativeAd didFailToReceiveAdWithError:(NSError *)error;
- (void)onVpadnNativeAdPresent:(VpadnNativeAd *)nativeAd;
- (void)onVpadnNativeAdLeaveApplication:(VpadnNativeAd *)nativeAd;
- (void)onVpadnNativeAdDismiss:(VpadnNativeAd *)nativeAd;

@end

@interface VpadnNativeAd : NSObject<VpadnNativeAdDelegate>

@property (nonatomic, copy, readonly) NSString *strBannerId;
@property (nonatomic, copy, readonly) NSString *platform;
@property (nonatomic, weak) id<VpadnNativeAdDelegate> delegate;

@property (nonatomic, strong, readonly) VpadnAdImage *icon;
@property (nonatomic, strong, readonly) VpadnAdImage *coverImage;
@property (nonatomic, assign, readonly) struct VpadnAdStarRating starRating;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *body;
@property (nonatomic, copy, readonly) NSString *callToAction;
@property (nonatomic, copy, readonly) NSString *socialContext;

- (id)initWithBannerID:(NSString *)bannerID; // Uses TW as default platform
- (id)initWithBannerID:(NSString *)bannerID platform:(NSString *)platform;
- (void)registerViewForInteraction:(UIView *)view
                withViewController:(UIViewController *)viewController;
- (void)registerViewForInteraction:(UIView *)view
                withViewController:(UIViewController *)viewController
                withClickableViews:(NSArray *)clickableViews;
- (void)unregisterView;
- (void)loadAd;
- (void)loadAdWithTestIdentifiers:(NSArray *)arrayTestIdentifiers;
//- (void)setNativeAdData:(NSDictionary*)dicNativeInfo withViewController:(id)viewController;

#pragma mark Log Switch (Default YES)
- (void)showTestLog:(BOOL)bShow;
- (void)setLocationOnOff:(BOOL)isOn;
- (BOOL)isReady;

#pragma mark - UserInfomation
#pragma mark 設定使用者資訊-年齡
- (void)setUserInfoAge:(NSInteger)age;
#pragma mark 設定使用者資訊-生日
- (void)setUserInfoBirthdayWithYear:(NSInteger)year Month:(NSInteger)month andDay:(NSInteger)day;
#pragma mark 設定使用者資訊-性別
- (void)setUserInfoGender:(UserInfoGender)gender;
#pragma mark 設定使用者資訊-關鍵字
- (void)addKeyword:(NSString*)keyword;
@end

typedef struct VpadnAdStarRating {
    CGFloat value;
    NSInteger scale;
} VpadnAdStarRating;

@interface VpadnAdImage : NSObject

@property (nonatomic, copy, readonly, nonnull) NSURL *url;
@property (nonatomic, assign, readonly) NSInteger width;
@property (nonatomic, assign, readonly) NSInteger height;

- (instancetype)initWithURL:(NSURL *)url
                      width:(NSInteger)width
                     height:(NSInteger)height NS_DESIGNATED_INITIALIZER;

- (void)loadImageAsyncWithBlock:(nullable void (^)(UIImage * __nullable image))block;
@end

NS_ASSUME_NONNULL_END
