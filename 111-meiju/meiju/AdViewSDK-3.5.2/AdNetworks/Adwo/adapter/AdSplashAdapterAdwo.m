//
//  AdSplashAdapterBaidu.m
//  AdViewDevelop
//
//  Created by maming on 14-11-14.
//  Copyright (c) 2014年 maming. All rights reserved.
//

#import "AdSplashAdapterAdwo.h"
#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "adViewAdNetworkRegistry.h"
#import "AdSpreadScreenManagerImpl.h"
#import "adViewLog.h"

static NSString* const adwoResponseErrorInfoList[] = {
    @"操作成功",
    @"广告初始化失败",
    @"当前广告已调用了加载接口",
    @"不该为空的参数为空",
    @"参数值非法",
    @"非法广告对象句柄",
    @"代理为空或adwoGetBaseViewController方法没实现",
    @"非法的广告对象句柄引用计数",
    @"意料之外的错误",
    @"已创建了过多的Banner广告，无法继续创建",
    @"广告加载失败",
    @"全屏广告已经展示过",
    @"全屏广告还没准备好来展示",
    @"全屏广告资源破损",
    @"开屏全屏广告正在请求",
    @"当前全屏已设置为自动展示",
    
    @"服务器繁忙",
    @"当前没有广告",
    @"未知请求错误",
    @"PID不存在",
    @"PID未被激活",
    @"请求数据有问题",
    @"接收到的数据有问题",
    @"当前IP下广告已经投放完",
    @"当前广告都已经投放完",
    @"没有低优先级广告",
    @"开发者在Adwo官网注册的Bundle ID与当前应用的Bundle ID不一致",
    @"服务器响应出错",
    @"设备当前没连网络，或网络信号不好",
    @"请求URL出错",
    @"初始化出错"
};

@implementation AdSplashAdapterAdwo

+ (AdSpreadScreenAdNetworkType)networkType {
    return AdSpreadScreenAdNetworkTypeAdwo;
}

+ (void)load {
    [[AdViewAdNetworkRegistry sharedSpreadScreenRegistry] registerClass:self];
}

- (BOOL)loadAdSpreadScreen:(UIViewController *)controller {
    
    adWoSplash = AdwoAdGetFullScreenAdHandle(self.networkConfig.pubId, YES, self, ADWOSDK_FSAD_SHOW_FORM_LAUNCHING);//self.networkConfig.pubId
    
    if ([self.adSpreadScreenDelegate respondsToSelector:@selector(adSpreadScreenOpenGps)]&&[self.adSpreadScreenDelegate adSpreadScreenOpenGps]) {
        //            adView.disableGPS = NO;
        AdwoAdSetAdAttributes(adWoSplash, &(struct AdwoAdPreferenceSettings){
            .disableGPS = NO                                       // 禁用GPS导航功能
        });
    }else{
        //            adView.disableGPS = YES;
        AdwoAdSetAdAttributes(adWoSplash, &(struct AdwoAdPreferenceSettings){
            .disableGPS = YES                                       // 禁用GPS导航功能
        });
    }
    
    // 这里设置动画形式为无动画模式。如果不设置则由系统自动给出
    AdwoAdSetAdAttributes(adWoSplash, &(const struct AdwoAdPreferenceSettings){
        .animationType = ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_NONE
    });
    NSLog(@"%@",adWoSplash);
    // 开始加载全屏广告，并不锁定方向旋转
    mCanShowAd = AdwoAdLoadFullScreenAd(adWoSplash, YES, NULL);
    
    if (!mCanShowAd) {
        int errCode = AdwoAdGetLatestErrorCode();
        NSLog(@"Adwo request splash failed, because: %@", adwoResponseErrorInfoList[errCode]);
        NSLog(@"error %@", adwoResponseErrorInfoList[errCode]);
    }
    
    [self.adSpreadScreenManager adapter:self requestString:@"req"];
    
    return YES;
}

- (void)failGetAd{
    adWoSplash = nil;
    [self.adSpreadScreenManager adapter:self requestString:@"fail"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_FailLoadAd error:nil];
    int errCode = AdwoAdGetLatestErrorCode();
    NSLog(@"Adwo request splash failed, because: %@", adwoResponseErrorInfoList[errCode]);
    NSLog(@"error %@", adwoResponseErrorInfoList[errCode]);
}
- (void)sunccessGetAd{
    mCanShowAd = NO;
    [self.adSpreadScreenManager adapter:self requestString:@"suc"];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidLoadAd error:nil];
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_WillPresentAd error:nil];
    // 成功

}
#pragma mark -  splash delegate

- (void)stopBeingDelegate {
    AWLogInfo(@"anwo splash stop being delegate");
    adWoSplash = nil;
}

- (UIViewController*)adwoGetBaseViewController{
    
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (viewController == NULL) {
        viewController = [self.adSpreadScreenDelegate adSpreadScreenWindow].rootViewController;
    }
    return viewController;
}

/**
 * 描述：捕获当前加载广告失败通知。当你所创建的广告视图对象请求广告失败后，SDK将会调用此接口来通知。参数adView指向当前请求广告的AWAdview对象。开发者可以通过errorCode属性来查询失败原因。
 */
- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView{
    [self failGetAd];
}

/**
 * 描述：捕获广告加载成功通知。当你广告加载成功时，SDK将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这个接口对于全屏广告展示而言，一般必须实现以捕获可以展示全屏广告的时机。
 */
- (void)adwoAdViewDidLoadAd:(UIView*)adView{
    if(adWoSplash != adView){
        [self failGetAd];
        return;
    }
    
    if (!mCanShowAd) {
         [self failGetAd];
    }else{
       
        BOOL status=AdwoAdShowFullScreenAd(adWoSplash);
        if (status) {
            [self sunccessGetAd];
        }else{
            [self failGetAd];
        }
    }
}

/**
 * 描述：当全屏广告被关闭时，SDK将调用此接口。一般而言，当全屏广告被用户关闭后，开发者应当释放当前的AWAdView对象，因为它的展示区域很可能发生改变。如果再用此对象来请求广告的话，展示可能会成问题。参数adView指向当前请求广告的AWAdView对象。
 */
- (void)adwoFullScreenAdDismissed:(UIView*)adView{
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidDismissAd error:nil];
    
}

/**
 * 描述：当SDK弹出自带的全屏展示浏览器时，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里需要注意的是，当adView弹出全屏展示浏览器时，此adView不允许被释放，否则会导致SDK崩溃。
 */
- (void)adwoDidPresentModalViewForAd:(UIView*)adView{
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_WillPresentModal error:nil];
}

/**
 * 描述：当SDK自带的全屏展示浏览器被用户关闭后，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里允许释放adView对象。
 */
- (void)adwoDidDismissModalViewForAd:(UIView*)adView{
    [self.adSpreadScreenManager adapter:self didGetEvent:SpreadScreenEventType_DidDismissModal error:nil];
}

@end
