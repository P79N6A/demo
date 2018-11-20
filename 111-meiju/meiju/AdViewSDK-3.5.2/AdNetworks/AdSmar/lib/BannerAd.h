//
//  BannerAd.h
//
//  Created by 张程 on 14/10/20.
//  Copyright (c) 2014年 faf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdError.h"
#import "AdDelegate.h"

@interface BannerAd : NSObject <AdDelegate>
/**
 *  横幅广告代理
 */
@property ( nonatomic, weak ) id<AdDelegate> bannerAdDelegate;
/**
 *  父视图
 *  需设置为显示广告的UIViewController
 */
@property (nonatomic, assign) UIViewController *currentViewController;
/**
 *  设置横幅广告位置
 *
 *  @param origin 横幅广告坐标点
 *
 *  @return 返回横幅广告对象
 */
- (id) initWithOrigin:(CGPoint)origin;
/**
 *  获取横幅view
 *
 *  @return 返回横幅view
 */
- (UIView *) getAdview;
/**
 *  请求横幅广告
 *
 *  @param adUnitId 广告位
 *  @param appid    appid
 *  @param autoRequest    是否轮播 (如需聚合讯飞SDK，请设置为NO)
 */
- (void) loadAdWithAdUnitId:(NSString *) adUnitId AppId:(NSString *) appid IsAutoRequest:(BOOL) autoRequest;
/**
 *  清除广告
 */
- (void) destroy;
@end
