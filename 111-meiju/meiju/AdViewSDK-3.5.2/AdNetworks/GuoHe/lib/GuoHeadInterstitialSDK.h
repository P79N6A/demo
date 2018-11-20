//
//  GuoHeadInterstitialSDK.h
//  GuoHeadInterstitialSDK-Project-Master
//
//  Created by keith.liu on 3/4/16.
//  Copyright © 2016 keith.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - The GuoHead Interstitial Delegate Protocol.

@protocol GuoHeadInterstitialSDKDelegate <NSObject>

/**
 *  预加载成功的回调
 */
- (void)ghInterstitialSDKDidCacheSuccessWithPlace:(NSString *)place;

/**
 *  预加载失败的回调
 */
- (void)ghInterstitialSDKDidCacheFailureWithPlace:(NSString *)place;

/**
 *  展示插屏成功的回调
 *  可以在此时暂停游戏声音等游戏界面的操作
 */
- (void)ghInterstitialSDKDidShowSuccessWithPlace:(NSString *)place;

/**
 *  展示插屏失败的回调
 */
- (void)ghInterstitialSDKDidShowFailureWithPlace:(NSString *)place;

/**
 *  点击插屏内容触发跳转的回调
 */
- (void)ghInterstitialSDKDidClickedWithPlace:(NSString *)place;

/**
 *  被广告被关闭的回调，有两个时机：
 *  1、插屏展示成功之后，点击了关闭按钮触发
 *  2、点击了插屏内容跳转之后，再返回您的界面的时候触发
 *
 *  可以在此时重新开启游戏声音等游戏界面的操作
 */
- (void)ghInterstitialSDKDidClosedWithPlace:(NSString *)place;

/**
 *  没有插屏活动可展示了的回调
 */
- (void)ghInterstitialSDKNoActivityWithPlace:(NSString *)place;

@end



#pragma mark - GuoHead Interstitial Class.

@interface GuoHeadInterstitialSDK : NSObject

/**
 *  初始化配置SDK
 *
 *  @param appKey 您的应用唯一标示，请在果合官网http://www.guohead.com/注册为开发者获取
 *
 *  @return 插屏实例对象
 */
+ (GuoHeadInterstitialSDK *)configInterstitialSDKWithAppKey:(NSString *)appKey;

/**
 *  预加载插屏
 *
 *  @param delegate 委托对象，设置为当前viewController对象即可
 *  @param place    触发位，如果没有设置请填写nil，默认会触发为default
 */
+ (void)preloadInterstitialWithDelegate:(id<GuoHeadInterstitialSDKDelegate>)delegate withPlace:(NSString *)place;

/**
 *  触发展示插屏的方法
 *
 *  @param delegate       委托对象，设置为当前viewController对象即可
 *  @param place          您的触发位
 *  @param viewController 游戏打成Xcode工程一般可传入nil或者[UIApplication sharedApplication].keyWindow.rootViewController
 */
+ (void)displayInterstitialWithDelegate:(id<GuoHeadInterstitialSDKDelegate>)delegate
                              withPlace:(NSString *)place
              withCurrentViewController:(UIViewController *)viewController;

/**
 *  调用关闭当前的插屏方法
 */
+ (void)dismissInterstitial;

@end
