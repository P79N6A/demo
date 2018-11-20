//
//  MMUSDK.h
//  MraidLib
//
//  Created by liuyu on 12/23/14.
//  Updated by liu yu on 06/10/15.
//  Copyright 2007-2015 Alimama.com. All rights reserved.
//  Version 5.6.1
//
//  Support Email: mobilesupport@list.alibaba-inc.com

#import <Foundation/Foundation.h>

typedef enum
{
    MMUShareTypeMail = 0,             //邮件分享
    MMUShareTypeSMS = 1,              //短信分享
    MMUShareTypeAirPrint = 2,         //打印
    MMUShareTypeCopy = 3,             //拷贝
    MMUShareTypeWeibo = 4,            //新浪微博
    MMUShareTypeQQ = 5,               //QQ
    MMUShareTypeQzone = 6,            //QQ空间
    MMUShareTypeWXSession = 7,        //微信好友
    MMUShareTypeWXTimeline = 8,       //微信朋友圈
    MMUShareTypeWXFav = 9,            //微信收藏
    MMUShareTypeOther = -1,           //其它
    MMUShareTypeCancel = -2,          //打开分享列表后，直接取消了分享
} MMUShareType;

@protocol MMUSDKDelegate;

@interface MMUSDK : NSObject

@property (nonatomic, weak) id<MMUSDKDelegate> delegate;

+ (MMUSDK *)sharedInstance;

/**
 
 广告全局初始化，请在App启动时调用
 
 */

- (void)globalInitialize;

/**
 
 用于处理从其它App回跳当前App的case
 
 @return 是否经过了MMUSDK的处理
 
 */

- (BOOL)handleOpenURL:(NSURL *)url;

/**
 
 当前版本SDK的版本信息，示例：5.6.0.20150520
 
 @return 返回SDK版本号
 
 */

- (NSString *)sdkVersionStr;

/**
 
 将分享的结果同步给SDK
 @param  shareType 选择的分享平台
 @param  completed 分享的结果，成功 or 失败
 
 */

- (void)handleShareResult:(MMUShareType)shareType result:(BOOL)completed;

@end

@protocol MMUSDKDelegate <NSObject>

@optional

/**

@return 是否响应来自SDK的分享请求，响应时：返回YES；不响应时：返回NO

 */

- (BOOL)shouldHandleShareRequestFromSDK;

/**
 
 用于处理来自SDK的分享请求
 
 @param  titleToShare 本次分享的标题
 @param  contentToShare 本次分享的文本内容
 @param  urlToShare 本次分享对应的url
 @param  imageToShare 需要分享的图片信息
 @param  controller 需哟使用分享功能的页面
 
 */

- (void)handleShareRequestWithTitle:(NSString *)titleToShare
                            content:(NSString *)contentToShare
                                url:(NSURL *)urlToShare
                              image:(UIImage *)imageToShare
                 withViewController:(UIViewController *)controller;

@end
