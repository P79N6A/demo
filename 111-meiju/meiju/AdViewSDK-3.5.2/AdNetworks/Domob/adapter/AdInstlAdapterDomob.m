/*
 adview.
 */
#import "AdInstlAdapterDomob.h"

#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"

@interface AdInstlAdapterDomob ()
@end

@implementation AdInstlAdapterDomob

@synthesize rootController = _rootController;


+ (AdInstlAdNetworkType)networkType {
	return AdInstlAdNetworkTypeDomob;
}

+ (void)load {
	if(NSClassFromString(@"DMInterstitialAdController") != nil) {
		[[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];	
	}
}

- (BOOL)loadAdInstl:(UIViewController*)controller
{
	Class instlCtrllerClass = NSClassFromString(@"DMInterstitialAdController");
	if(nil == instlCtrllerClass) return NO;
    
    NSString *appID = self.networkConfig.pubId;
    NSString *placementId = self.networkConfig.pubId2;
    
    DMInterstitialAdController *instlCtrller = [[instlCtrllerClass alloc] initWithPublisherId:appID placementId:placementId rootViewController:controller];
    
    instlCtrller.delegate = self;
    self.adInstlController = instlCtrller;
    self.rootController = controller;
    [self.adInstlManager adapter:self requestString:@"req"];
    [instlCtrller loadAd];
	return YES;
}

- (BOOL)showAdInstl:(UIViewController*)controller
{
    if (nil == self.adInstlController) {
        AWLogInfo(@"No instl controller exist!");
        return NO;
    }
    DMInterstitialAdController *instlCtrller = (DMInterstitialAdController*)self.adInstlController;
    if ([instlCtrller isReady])
    {
        [self.adInstlManager adapter:self requestString:@"show"];
#if 1   //For Domob, should post viewController when load.
        if (self.rootController)
            [instlCtrller present];
        else
            return NO;
        return YES;
#else
        [instlCtrller present];
        return YES;
#endif
    }
    return NO;
}

#pragma mark delegate

- (BOOL)judgeInstlController:(UIViewController*)instlController
{
    if (self.adInstlController != instlController) {//stale instl.
        AWLogInfo(@"stale instl controller!");
        return NO;
    }
    return YES;
}

//当插屏广告被成功加载后，回调该方法
- (void)dmInterstitialSuccessToLoadAd:(DMInterstitialAdController *)dmInterstitial
{
    if (![self judgeInstlController:dmInterstitial]) return;
    [self.adInstlManager adapter:self requestString:@"suc"];
    
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
    
    
}

//当插屏广告加载失败后，回调该方法
- (void)dmInterstitialFailToLoadAd:(DMInterstitialAdController *)dmInterstitial withError:(NSError *)err
{
    if (![self judgeInstlController:dmInterstitial]) return;
    
    [adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:err];
    [self.adInstlManager adapter:self requestString:@"fail"];
}

//当插屏广告要被呈现出来前，回调该方法
- (void)dmInterstitialWillPresentScreen:(DMInterstitialAdController *)dmInterstitial
{
    if (![self judgeInstlController:dmInterstitial]) return;
    
    [adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
    

   }

//当插屏广告被关闭后，回调该方法
- (void)dmInterstitialDidDismissScreen:(DMInterstitialAdController *)dmInterstitial
{
    if (![self judgeInstlController:dmInterstitial]) return;
    
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

//当将要呈现出 Modal View 时，回调该方法。如打开内置浏览器。
- (void)dmInterstitialWillPresentModalView:(DMInterstitialAdController *)dmInterstitial
{
    [self.adInstlManager adapter:self requestString:@"click"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
}

//当呈现的 Modal View 被关闭后，回调该方法。如内置浏览器被关闭。
- (void)dmInterstitialDidDismissModalView:(DMInterstitialAdController *)dmInterstitial
{
}

//当因用户的操作（如点击下载类广告，需要跳转到Store），需要离开当前应用时，回调该方法
- (void)dmInterstitialApplicationWillEnterBackground:(DMInterstitialAdController *)dmInterstitial {
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
    [self.adInstlManager adapter:self requestString:@"click"];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"Domob stopBeingDelegate, controller");    
    
    DMInterstitialAdController *instlCtrller = (DMInterstitialAdController*)self.adInstlController;
    instlCtrller.delegate = nil;
    self.adInstlController = nil;
    
    self.rootController = nil;
}

@end
