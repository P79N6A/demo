//
//  CSVideoAD.h
//  CSVideoADSDK
//
//  Created by Chance_yangjh on 15/1/8.
//  Copyright (c) 2015年 ChuKong-Inc. All rights reserved.
//

#ifndef CSVideoAD_h
#define CSVideoAD_h
#import <Foundation/Foundation.h>
#import "CSError.h"

typedef NS_ENUM(unsigned int, CSVideoEvent) {
    CSVideoEvent_ExitWhenLoading, // 视频广告加载过程中的退出播放
    CSVideoEvent_FileError, // 视频广告因视频文件错误导致的取消播放
    CSVideoEvent_ShowFailed, // 视频广告展现失败
    CSVideoEvent_ShowSuccess, // 视频广告展现成功，即开始播放视频广告
    CSVideoEvent_ClickCloseButton, // 提前点击关闭按钮
};

typedef NS_ENUM(unsigned int, CSVideoStatus) {
    CSVideoStatus_None,
    CSVideoStatus_Expired,
    CSVideoStatus_FileNotExist,
    CSVideoStatus_IsReady,
};


@protocol CSVideoADDelegate;

@interface CSVideoAD : NSObject

// 广告位ID
@property (nonatomic, copy) NSString *placementID;
// 查看视频广告状态
@property (nonatomic, readonly) CSVideoStatus videoStatus;
// 是否隐藏金币相关的文本提示（只激励模式有效）
@property (nonatomic, assign) BOOL hideCoinLabel;
// 服务器对接时，积分回调时转发的信息。长度限制80（不建议使用中文符号）
@property (nonatomic, copy) NSString *userInfo;

@property (nonatomic, weak) UIViewController *rootViewController;

@property (nonatomic, weak) id <CSVideoADDelegate> delegate;

+ (CSVideoAD *)sharedInstance;

/**
 *  加载视频广告
 *
 *  @param portrait 视频广告方向
 *  @param onlyWifi 是否只在wifi情况下预加载视频文件
 */
- (void)loadVideoADWithOrientation:(BOOL)portrait
          andDownloadVideoOnlyWifi:(BOOL)onlyWifi;

/**
 *    @brief    展现视频广告
 *
 *  @param portrait 视频广告方向
 */
- (void)showVideoADWithOrientation:(BOOL)portrait;

@end


@protocol CSVideoADDelegate <NSObject>

@optional

// 视频广告请求成功
- (void)csVideoADRequestVideoADSuccess:(CSVideoAD *)csVideoAD;

// 视频广告请求失败
- (void)csVideoAD:(CSVideoAD *)csVideoAD requestVideoADError:(CSError *)csError;

// 视频文件准备好了（不播放视频广告时才会有回调）
// isCache为YES表示视频文件为缓存
- (void)csVideoAD:(CSVideoAD *)csVideoAD videoFileIsReady:(BOOL)isCache;

// 视频广告将要播放
// 返回YES表示播放视频广告，返回NO表示暂不播放。未实现按YES处理
- (BOOL)csVideoADWillPlayVideoAD:(CSVideoAD *)csVideoAD;

// 播放事件回调（event事件参考枚举,replay为YES表示重播）
- (void)csVideoAD:(CSVideoAD *)csVideoAD event:(CSVideoEvent)csVideoEvent replay:(BOOL)replay error:(NSError *)csError;

// 视频广告播放完成（广告不会自动关闭）（replay为YES表示重播）
- (void)csVideoAD:(CSVideoAD *)csVideoAD playVideoFinished:(BOOL)replay;

// 视频广告播放过程中点击了下载按钮（replay为YES表示重播）
- (void)csVideoAD:(CSVideoAD *)csVideoAD clickDownload:(BOOL)replay;

// 视频广告关闭
- (void)csVideoADClosed:(CSVideoAD *)csVideoAD;

// 互动页展示
- (void)csVideoADInteractPageShow:(CSVideoAD *)csVideoAD;

// 互动页关闭
- (void)csVideoADInteractPageClose:(CSVideoAD *)csVideoAD;

@end
#endif

