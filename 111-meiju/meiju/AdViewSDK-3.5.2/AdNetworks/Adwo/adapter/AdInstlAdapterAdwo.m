/*
 adview.
 */
#import "AdInstlAdapterAdwo.h"

#import "adViewConfig.h"
#import "adViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "adViewAdNetworkRegistry.h"
#import "AdViewExtraManager.h"
#import "AdInstlManagerImpl.h"

@interface AdInstlAdapterAdwo ()
@end

@implementation AdInstlAdapterAdwo
@synthesize awView;
@synthesize parent;

+ (AdInstlAdNetworkType)networkType {
	return AdInstlAdNetworkTypeAdwo;
}

+ (void)load {
    
    [[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
}

- (BOOL)loadAdInstl:(UIViewController*)controller
{
    if (nil == controller) return NO;
    
    NSString *appID = self.networkConfig.pubId;
    
    if (awView == nil) {
        hasLoaded = NO;
        awView = AdwoAdGetFullScreenAdHandle(appID,![self isTestMode], self, ADWOSDK_FSAD_SHOW_FORM_APPFUN_WITH_BRAND);
    }
    
    if (awView == nil) {
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error: nil];
        [self.adInstlManager adapter:self requestString:@"fail"];
    }
    //    [awView performSelector:@selector(setAGGChannel:) withObject:[NSNumber numberWithInteger:ADWOSDK_AGGREGATION_CHANNEL_ADVIEW]];
    //    awView.tag = AWVIEW_TAG;
    
    self.parent = controller;
    
    //设置广告属性
    if(!AdwoAdSetAdAttributes(awView, &(const struct AdwoAdPreferenceSettings){.adSlotID = 0,.disableGPS = [self isOpenGps],.animationType = ADWO_ANIMATION_TYPE_AUTO,.spreadChannel = ADWOSDK_SPREAD_CHANNEL_APP_STORE}))
    {
        AWLogInfo(@"set adwoAd attributes is");
        
    }
    
    [self.adInstlManager adapter:self requestString:@"req"];
    AdwoAdLoadFullScreenAd(awView, NO, NULL);//adwo 加载
    
    //    if (!isTure) {
    //        [self.adInstlManager adapter:self requestString:@"fail"];
    //        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
    //    }
	return YES;
}

- (BOOL)showAdInstl:(UIViewController*)controller
{
    if (nil == self.parent) {
        AWLogInfo(@"No instl controller exist!");
        return NO;
    }
    if (AdInstlLoadType_DidLoadAd != self.loadType) {
        AWLogInfo(@"Fail load or in loading!");
        return NO;
    }
    if (hasLoaded && awView) {
        // 广告加载成功，可以把全屏广告展示上去
        BOOL bRet = AdwoAdShowFullScreenAd(awView);
        if (bRet) {
            [self.adInstlManager adapter:self requestString:@"show"];
            [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil]; }else{
                awView = nil;
                [self.adInstlManager adapter:self requestString:@"fail"];
                [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
                return NO;
            }
    }
    
    return YES;
}

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
    @"当前事件触发型广告已被禁用",
    @"没找到相应合法尺寸的事件触发型广告",
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
    @"请求URL出错"
};

#pragma mark delegate
- (UIViewController*)adwoGetBaseViewController
{
    return self.parent;
}

- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView
{
    AWLogInfo(@"Failed to load ad! Because: %@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
    
    awView = nil;
    hasLoaded = NO;
    
    NSError *errorMessage = [NSError errorWithDomain:adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()] code:0 userInfo:nil];
    [self.adInstlManager adapter:self requestString:@"fail"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:errorMessage];
}

- (void)adwoAdViewDidLoadAd:(UIView*)adView
{
    hasLoaded = YES;
    [self.adInstlManager adapter:self requestString:@"suc"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}

- (void)adwoFullScreenAdDismissed:(UIView*)adView
{
    hasLoaded = NO;
    self.parent = nil;
    awView=nil;
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

- (void)adwoDidDismissModalViewForAd:(UIView*)adView
{
    
}

- (void)adwoDidPresentModalViewForAd:(UIView*)adView
{
    [self.adInstlManager adapter:self requestString:@"click"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
}

- (void)adwoUserClosedImplantAd:(UIView*)adView
{

}
- (void)stopBeingDelegate {
//    AdInstlLogInfo(@"Adwo stopBeingDelegate, controller retain:%d", [self.parent retainCount]);
    //  self.parent = nil;
}

@end
