//
//  AdInstlAdapterSmtaran.m
//  AdInstlSDK_iOS
//
//  Created by Ma ming on 13-5-31.
//
//

#import "AdInstlAdapterSmtaran.h"

#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"
#define Entire_screen_is_On  1
#define Entire_screen_is_Off 0

@interface AdInstlAdapterSmtaran ()
@end

@implementation AdInstlAdapterSmtaran

@synthesize SmtaranView;
@synthesize parent;
@synthesize isStatusHidden;

+ (AdInstlAdNetworkType)networkType {
    return AdInstlAdNetworkTypeSmtaran;
}

+ (void)load {
    if(NSClassFromString(@"SmtaranSDKManager") != nil) {
		[[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
	}
}

- (BOOL)loadAdInstl:(UIViewController *)controller {
//    Class SmtaranPosterClass = NSClassFromString(@"SmtaranAdPoster");
    Class SmtaranManagerClass = NSClassFromString(@"SmtaranSDKManager");
    
//    if (SmtaranPosterClass == nil) return NO;
    if (SmtaranManagerClass ==nil) return NO;
    if (controller == nil) return NO;
    self.parent = controller;
    isStatusHidden = NO;
    
    NSString * appId = self.networkConfig.pubId2;
    NSString * slotToken = self.networkConfig.pubId3;
    
    //[[SmtaranManagerClass getInstance] setPublisherID:appId deployChannel:[self.adInstlManager marketChannel]];
    [[SmtaranSDKManager getInstance] setPublisherID:appId withChannel:[self.adInstlManager marketChannel] auditFlag:MS_Test_Audit_Flag];
    

    //Float_size_3为全屏；Float_size_0为半屏
        self.SmtaranView =[[SmtaranInterstitialAd alloc]initInterstitialAdSize:SmtaranInterstitialAdSizeNormal delegate:self slotToken:slotToken];
    
    [self.adInstlManager adapter:self requestString:@"req"];
   
    if (self.SmtaranView == nil) {
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
      
    return YES;
}

- (BOOL)showAdInstl:(UIViewController *)controller {
   
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    if (nil == controller || ![controller isViewLoaded] || [controller isBeingDismissed]) {
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
#else
    if (nil == controller || ![controller isViewLoaded]) {
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
#endif
    if (![UIApplication sharedApplication].statusBarHidden) {
        //若请求广告尺寸为全屏则需要隐藏statusBar
        [UIApplication sharedApplication].statusBarHidden = YES;
        isStatusHidden = YES;
    }
    
    [self.adInstlManager adapter:self requestString:@"show"];

    [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
    [self.SmtaranView showInterstitialAd];

    return YES;
}

#pragma mark -
#pragma mark delegate

-(void)smtaranInterstitialAdSuccessToRequest:(SmtaranInterstitialAd *)adInterstitial
{
    AWLogInfo(@"SmtaranFloatSuccessToRequest");
    [self.adInstlManager adapter:self requestString:@"suc"];
     [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}

-(void)smtaranInterstitialAdClick:(SmtaranInterstitialAd *)adInterstitial
{
    AWLogInfo(@"SmtaranFloatClick");
    [self.adInstlManager adapter:self requestString:@"click"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
}

-(void)smtaranInterstitialAdClose:(SmtaranInterstitialAd *)adInterstitial
{
    //若请求广告之前有statusBar并且请求的广告为全屏广告，则需要在此处显示statusBar
    if (isStatusHidden) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
     [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

-(void)smtaranInterstitialAdFaildToRequest:(SmtaranInterstitialAd *)adInterstitial withError:(NSError *)error
{
    AWLogInfo(@"SmtaranFloatFaildToRequest");
    [self.adInstlManager adapter:self requestString:@"fail"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
}

- (UIViewController *)viewControllerToPresent {
    return self.parent;
}

- (void)stopBeingDelegate {
    AWLogInfo(@"Smtaran delloced");
    self.SmtaranView.delegate = nil;
    self.SmtaranView = nil;
    self.parent = nil;
}

@end
