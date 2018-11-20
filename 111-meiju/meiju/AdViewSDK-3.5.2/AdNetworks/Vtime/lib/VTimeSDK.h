//
//  VTimeSDK.h
//  VT_SDK
//
//  Created by Joey on 13-5-8.
//  Copyright (c) 2013年 VTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol VTimeSDKDelegate;

@interface VTimeSDK : NSObject

@property (nonatomic, retain) id<VTimeSDKDelegate> vTimeSDKDelegate;

+ (VTimeSDK *)sharedInstance;

#pragma mark AD Request
- (UIViewController *)requestAdWithAppKey:(NSString *)appKey appSecret:(NSString *)appsecret inLevel:(int)level delegate:(id<VTimeSDKDelegate>)delegate;

#pragma mark USER Request
- (UIViewController *)requestUserWithAppKey:(NSString *)appKey appSecret:(NSString *)appsecret delegate:(id<VTimeSDKDelegate>)delegate;

@end

@protocol VTimeSDKDelegate <NSObject>

@optional

- (void)onReceivedAd;
- (void)onFaidedReceivedAd;

- (void)onReceivedUserInfo;
- (void)onFaidedReceivedUserInfo;

@end
