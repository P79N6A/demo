//
//  AdInstlAdapterGuomob.m
//  AdInstlSDK_iOS
//
//  Created by Ma ming on 13-5-2.
//
//

#import "AdInstlAdapterGuomob.h"

#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"

@implementation AdInstlAdapterGuomob

@synthesize guomobInstl;
@synthesize parent;
@synthesize closeButton;

+ (AdInstlAdNetworkType)networkType {
    return AdInstlAdNetWorkTypeGuomob;
}

+ (void)load {
	if(NSClassFromString(@"GMInterstitialAD") != nil) {
        [[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
	}
}

- (BOOL)loadAdInstl:(UIViewController *)controller {
    Class GMInterstitialClass = NSClassFromString(@"GMInterstitialAD");
    if (nil == GMInterstitialClass) return NO;
    if (nil == controller) return NO;
    
    self.parent = controller;
    NSString *appID = self.networkConfig.pubId;
    
    GMInterstitialAD * GuomobInstl = [[GMInterstitialClass alloc] initWithId:appID];
    self.guomobInstl = GuomobInstl;
    self.guomobInstl.delegate = self;
    
    [self.adInstlManager adapter:self requestString:@"req"];
    //用户可设置是否支持旋转 NO - 不旋转 YES - 旋转
    [self.guomobInstl loadInterstitialAd:YES];
    if([self.guomobInstl superview])
    {
        [self.guomobInstl removeFromSuperview];
        
    }
    [self.parent.view addSubview:self.guomobInstl];

    return YES;
}

- (BOOL)showAdInstl:(UIViewController *)controller
{
    if (nil == self.parent)
    {
        AWLogInfo(@"No inmobi instl exist!");
        return NO;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    if (nil == controller || ![controller isViewLoaded] || [controller isBeingDismissed]) {
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
#else
    if (nil == controller || ![controller isViewLoaded]) {
      [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
#endif

    [self.adInstlManager adapter:self requestString:@"show"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
    
    
    return YES;
}

#pragma mark -
#pragma mark Guomob delegate

-(void)loadInterstitialAdSuccess:(BOOL)success
{
    if (success)
    {
        [self.adInstlManager adapter:self requestString:@"suc"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
    }
}

- (void)closeInterstitialAD
{
    if (self.parent) {
        self.parent = nil;
    }
    if (self.guomobInstl.delegate) {
        self.guomobInstl.delegate = nil;
    }
    if (self.guomobInstl) {
        self.guomobInstl = nil;
    }
   [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

//请求内容返回的错误
- (void)InterstitialConnectionDidFailWithError:(NSError *)error
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:error];
    [self.adInstlManager adapter:self requestString:@"fail"];
    AWLogInfo(@"Guomeng error is %@",error);
}

- (void)stopBeingDelegate {
    AWLogInfo(@"Guomob dealloc");
    if (self.parent) {
        self.parent = nil;
    }
    if (self.guomobInstl.delegate) {
        self.guomobInstl.delegate = nil;
    }
    if (self.guomobInstl) {
        self.guomobInstl = nil;
    }
}

@end
