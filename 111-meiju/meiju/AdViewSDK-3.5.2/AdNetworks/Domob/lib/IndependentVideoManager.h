//
//  IndependentVideoVideoManager.h
//  IndependentVideoSDK
//
//  Created by Domob on 13/1/17.
//  Copyright (c) 2017 domob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class IndependentVideoManager;

@protocol IndependentVideoManagerDelegate <NSObject>
@optional
#pragma mark - independent video present callback 视频广告展现回调

/**
 *  开始加载视频。
 *  Independent video starts to fetch info.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerDidStartLoad:(IndependentVideoManager *)manager;
/**
 *  视频是否下载完成。
 *
 *  isFinished YES/NO
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerDidFinishLoad:(IndependentVideoManager *)manager finished:(BOOL)isFinished;
/**
 *  加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
 *   Failed to load independent video.
 
 *
 *  @param manager IndependentVideoManager
 *  @param error   error
 */
- (void)ivManager:(IndependentVideoManager *)manager
failedLoadWithError:(NSError *)error;
/**
 *  被呈现出来时，回调该方法。
 *  Called when independent video will be presented.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerWillPresent:(IndependentVideoManager *)manager;
/**
 *  页面关闭。
 *  Independent video closed.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerDidClosed:(IndependentVideoManager *)manager;
/**
 *  当视频播放完成后，回调该方法。
 *  Independent video complete play
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerCompletePlayVideo:(IndependentVideoManager *)manager;

/**
 *  播放视频失败
 *  Paly independent video failed.
 *
 *  @param manager IndependentVideoManager
 *  @param error
 */

- (void)ivManagerPlayIndependentVideo:(IndependentVideoManager *)manager
                            withError:(NSError *)error;

/**
 *  checkVideoAvailable的回调方法,服务端是否有视频广告可以下载。
 *  Called after check independent video available.
 *
 *  @param IndependentVideoManager
 *  @param available YES/NO
 */
- (void)ivManager:(IndependentVideoManager *)manager
isIndependentVideoAvailable:(BOOL)available;

@end

@interface IndependentVideoManager : NSObject {
    
}

@property(nonatomic,assign)id<IndependentVideoManagerDelegate>delegate;

/**
 *禁用StoreKit库提供的应用内打开store页面的功能，采用跳出应用打开OS内置AppStore。默认为NO，即使用StoreKit。
 */
@property (nonatomic, assign) BOOL disableStoreKit;

/**
 *是否在播放完成后弹出弹框，默认为弹出
 */
@property (nonatomic, assign) BOOL disableShowAlert;
/**
 *4G网络是否直接下载，默认YES,为下载(表示不弹出提示)
 */
@property (nonatomic, assign) BOOL should4GDownload;
/**
 *  用于展示sotre或者展示类广告
 */
@property(nonatomic,assign)UIViewController *rootViewController;

#pragma mark - init 初始化相关方法
/**
 *  使用Publisher ID初始化积分墙
 *  Create IndependentVideoManager with your own Publisher ID
 *
 *  @param publisherID 媒体ID
 *
 *  @return IndependentVideoManager
 */
- (instancetype)initWithPublisherID:(NSString *)publisherID;
/**
 *  使用Publisher ID和应用当前登陆用户的User ID初始化IndependentVideoManager
 *   Create IndependentVideoManager with your own Publisher ID and User ID.
 *
 *  @param publisherID 媒体ID
 *  @param userID      应用中唯一标识用户的ID
 *
 *  @return IndependentVideoManager
 */
- (instancetype)initWithPublisherID:(NSString *)publisherID andUserID:(NSString *)userID;

/**
 *  更新登陆用户的User ID
 *  Update User ID.
 *
 *  @param userID      应用中唯一标识用户的ID
 */
- (void)updateUserID:(NSString *)userID;

#pragma mark - independent video present 积分墙展现相关方法
/**
 *  使用App的rootViewController来弹出并显示列表积分墙。
 *  Present independent video in ModelView way with App's rootViewController.
 *
 *  @param type 积分墙类型
 */
- (void)presentIndependentVideo;
/**
 *  使用开发者传入的UIViewController来弹出显示积分墙。
 *  Present IndependentVideo with developer's controller.
 *
 *  @param controller UIViewController
 *  @param type 积分墙类型
 */
- (void)presentIndependentVideoWithViewController:(UIViewController *)controller;

#pragma mark - independent video status 检查视频是否可用
/**
 *  检查服务端是否有视频广告可下载
 *  check independent video available.
 */
- (void)checkVideoAvailable;

@end

