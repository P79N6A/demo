//
//  TextAdView.h
//  OPAdplayerSDK
//
//  Created by LW on 16/8/26.
//  Copyright © 2016年 Mr Li. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * textAd 尺寸
 */
typedef NS_ENUM(NSInteger,OperaTextAdSize){
    OperaTextAdSizeNormol = 0,  // 正常尺寸320X50
    OperaTextAdSizeLarge,       // 大尺寸 屏幕宽度X60
};


@class TextAdView;
@protocol OperaTextAdDelegate <NSObject>
@optional


/**
 * @brief textAd  广告请求成功
 * @param textAd
 */
-(void)operaTextAdRequestSuccessed:(TextAdView *)textAd;
/**
 * @brief textAd  广告请求成功
 * @param textAd
 */
-(void)operaTextAdRequestFailure:(TextAdView *)textAd error:(NSString *)error;
/**
 * @brief textAd  展示成功
 * @param textAd
 */
-(void)operaTextAdShowSuccessed:(TextAdView *)textAd;
/**
 * @brief textAd  展示失败
 * @param textAd
 */
-(void)operaTextAdShowFailure:(TextAdView *)textAd;
/**
 * @brief textAd  广告被点击
 * @param textAd
 */
-(void)operaTextAdClick:(TextAdView *)textAd;

///**
// * @brief textAd  广告被关闭
// * @param textAd
// */
//-(void)operaTextAdClose:(TextAdView *)textAd;



@end


@interface TextAdView : NSObject
@property (nonatomic,weak) id<OperaTextAdDelegate> delegate;



/**
 * @brief 初始化文字广告
 * @param frame 是广告banner展示的位置和大小(目前大小是固定的)
 * @param slotToken 广告位id
 */

-(instancetype)initWithFrame:(CGRect)frame
                   slotToken:(NSString *)slotToken;



@end
