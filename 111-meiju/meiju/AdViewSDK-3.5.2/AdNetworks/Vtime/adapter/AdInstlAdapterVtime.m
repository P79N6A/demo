//
//  AdInstlAdapterVtime.m
//  AdInstlSDK_iOS
//
//  Created by adview on 13-9-2.
//
//

#import "AdInstlAdapterVtime.h"

#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"

@implementation AdInstlAdapterVtime
@synthesize parent;
@synthesize userView;

+(AdInstlAdNetworkType)networkType
{
    return AdInstlAdNetworkTypeVtime;
    
}

+ (void)load {
    if(NSClassFromString(@"VTimeSDK") != nil) {
		[[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
	}
}

- (BOOL)loadAdInstl:(UIViewController *)controller {
    Class VtimeSDKClass = NSClassFromString(@"VTimeSDK");
    if (VtimeSDKClass == nil) return NO;
    if (nil == controller) return NO;
    
    NSString * appID = self.networkConfig.pubId;
    NSString * appsecret = self.networkConfig.pubId2;
    
    UIViewController * VTimeView = [[VtimeSDKClass sharedInstance] requestAdWithAppKey:appID appSecret:appsecret inLevel:10 delegate:self];
    
    UIViewController *UserView = [[VtimeSDKClass sharedInstance] requestUserWithAppKey:appID appSecret:appsecret delegate:self];

    self.parent = VTimeView.view;
    self.userView = UserView.view;

    [self.adInstlManager adapter:self requestString:@"req"];
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

    [self.adInstlManager adapter:self requestString:@"show"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
  
    [controller.view addSubview:self.parent];
    
    self.parent.frame = CGRectMake(self.parent.frame.origin.x, self.parent.frame.origin.y-5, self.parent.frame.size.width, self.parent.frame.size.height+5);
    
    return YES;
}

#pragma mark VTimeSDKDelegate

- (void)onReceivedAd {
    AWLogInfo(@"广告数据请求成功！");
    
    [self.adInstlManager adapter:self requestString:@"suc"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error: nil];
 
}
- (void)onFaidedReceivedAd {
    AWLogInfo(@"广告数据请求失败！");
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
    [self.adInstlManager adapter:self requestString:@"fail"];
    
}

- (void)onReceivedUserInfo {
    AWLogInfo(@"用户数据请求成功！");
    
}

- (void)onFaidedReceivedUserInfo {
   AWLogInfo(@"用户数据请求失败！");
    
}

-(void)stopBeingDelegate
{
    AWLogInfo(@"Vtime is stopdelegate!!!!!!");
    self.parent = nil;
    self.userView = nil;
}

@end
