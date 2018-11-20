//
//  AdVideoManager.h
//  AdViewDevelop
//
//  Created by maming on 16/9/8.
//  Copyright © 2016年 maming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdVideoManagerDelegate.h"

@interface AdVideoManager : NSObject {
    id<AdVideoManagerDelegate> __weak delegate;
    NSString *adVideoKey;
    NSString *appChannel;
    BOOL autoRoll;
}

@property (nonatomic, weak) id<AdVideoManagerDelegate> delegate;
@property (nonatomic, retain) NSString *adVideoKey;	  //same as adviewKey.
@property (nonatomic, retain) NSString *appChannel;   //like appstore, cydia, 91Store, etc.

/**
 * 如果加载视频广告失败，则是否自动切换到下一个视频广告平台的标志。显示失败不会自动切换。
 * 缺省为YES
 */
@property (nonatomic, assign) BOOL autoRoll;

/**
 *  是否在播放完成后弹出提示框，默认值为NO（弹出提示框）
 */
@property (nonatomic, assign) BOOL disableShowAlert;

+ (instancetype)managerWithAdVideoKey:(NSString*)key
                           WithDelegate:(id<AdVideoManagerDelegate>)delegate;;

/**
 *  刷新登陆用户的User ID
 *  Update User ID.
 *
 *  @param userID      应用中唯一标识用户的ID
 */
- (void)updateUserID:(NSString*)userID;

- (BOOL)loadVideoAd:(UIViewController*)controller;

- (BOOL)showVideoAdWithController:(UIViewController*)controller;

/**
 * 广告是否已经加载完成
 */
- (BOOL)isReady;

/**
 * 当前广告平台名称
 */
- (NSString *)currentNetworkName;

/**
 * 获取当前的渠道号
 */
- (NSString *)marketChannel;

/**
 * 设置支持方向(部分平台不支持设置)
 */
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;


@end
