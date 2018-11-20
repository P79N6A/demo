//
//  MopSpotController.h
//  mopanSdk0_4_0v
//
//  Created by xo on 15/5/6.
//  Copyright (c) 2015年 Lijunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NoneError,   //没有错误
    NoneNetError,//网络链接错误
    PleaseWait,  //广告加载中或者展示中,请稍后展示
    NoOriginal,   //初始化错误,您没有调用初始化函数进行初始化操作
    UnKnowError  //未知错误,账号密码输入不正确或者应用没有通过审核或其他
}MopError;
@protocol MopSpotDelegate <NSObject>
//插屏加载成功时调用
- (void)mopSpotLoadSuccess;
//插屏加载失败时调用
- (void)mopSpotLoadFailure;
//用户点击插屏时候调用
- (void)mopSpotClickAd;

@end

@interface MopSpotController : NSObject
#pragma mark - 初始化接口
//在主线程中初始化 应用id和密码可以再www.imopan.com获得
+(void)initWithProductId:(NSString *)productId
            ProductSecret:(NSString *)productSecret;

#pragma mark - 插屏接口
//设置插屏是否允许预加载,如果允许则开启预加载功能,需设置BOOL值为YES.注意:一个应用只支持一种加载方式
+(void)loadDataWithReloadSwitch:(BOOL)reloadSwitch;

//返回值为广告加载是否成功,返回值只有在开启预加载功能时才可用,显示广告 flag为MopError类型
+(BOOL)showMopPlaque:(void(^)(MopError flag))resultAction;

//关闭广告的回调 如果不使用 可以传入nil
+(void)clickCloseButton:(void(^)())clickBlock;
//需要设置代理调用此方法,注意:只有允许预加载时才可以使用
+ (void)setDelegateWithObj:(id)delegate;

@end
