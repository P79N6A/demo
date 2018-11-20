//
//  MopBannerController.h
//  MopanBannerSdk
//
//  Created by xo on 15/9/21.
//  Copyright © 2015年 Lijunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
//插屏尺寸的枚举
typedef enum{
    MopBannerSizeOne = 1,  //320*50
    MopBannerSizeTwo,  //480*75
    MopBannerSizeThree,//640*100
    MopBannerSizeFour, //1088*170
    MopBannerSizeFive, //1242*194
    MopBannerSizeSix,  //1280*200
    MopBannerSizeSeven, //728*90
    MopBannerSizeEight, //1456*180
    MopBannerSizeNigh,//2148*270
   
}MopBannerSize;

@protocol MopBannerDelegate <NSObject>

//广告请求成功时调用
- (void)mopBannerImageLoadSuccess;
//广告请求失败时调用
- (void)mopBannerImageLoadFailure;
//用户点击广告的时候调用
- (void)mopBannerViewbeClicked;
@end
@interface MopBannerController : NSObject

#pragma mark - Banner接口
//在主线程中初始化 应用id和密码可以再www.imopan.com获得 
+(void)initWithProductId:(NSString *)productId
             ProductSecret:(NSString *)productSecret;

//设置banner的尺寸 父视图以及位置,默认自动更换广告。
+ (void)setBannerWithSize:(MopBannerSize)bannerSize AndRootView:(UIView *)rootView addLocation:(CGPoint)location;

//展示banner广告,成功则返回1

+ (BOOL)showMopBanner;

//移除banner广告
+ (void)removeBannerView;


+ (void)setDelegateWithOjc:(id)delegate;
//adviewbanner接口
//开始加载banner
+ (UIView *)beginLoadBanner:(MopBannerSize)bannerSize;
@end



