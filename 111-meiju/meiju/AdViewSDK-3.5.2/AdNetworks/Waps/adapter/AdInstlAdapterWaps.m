//
//  AdInstlAdapterWaps.m
//  AdInstlSDK_iOS
//
//  Created by Ma ming on 13-3-18.
//
//

#import "AdInstlAdapterWaps.h"
#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"
#import "JOYConnect.h"


@interface AdInstlAdapterWaps()<JOYConnectDelegate>

@end

@implementation AdInstlAdapterWaps

+ (AdInstlAdNetworkType)networkType {
    return AdInstlAdNetworkTypeWaps;
}

+ (void)load {
	if(NSClassFromString(@"JOYConnect") != nil) {
		[[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
	}
}

- (BOOL)loadAdInstl:(UIViewController *)controller {
    Class WapsInstlClass = NSClassFromString(@"JOYConnect");
	if(nil == WapsInstlClass) return NO;
    if (controller == nil) return NO;
    
    NSString *appID = self.networkConfig.pubId;
    
    [JOYConnect getConnect:appID pid:[self.adInstlManager marketChannel]];
    [JOYConnect sharedJOYConnect].delegate=self;
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
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
#endif
    
    [JOYConnect showPop:nil];
    
    return YES;
}

#pragma mark Notification

- (void)onConnectSuccess
{
    AWLogInfo(@"Wap's Instl did load success");
    [self.adInstlManager adapter:self requestString:@"suc"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}

- (void)onConnectFailed:(NSString *)error
{
	AWLogInfo(@"Wap's Instl did load failed");
 
    NSError *errorMessage = [NSError errorWithDomain:error code:0 userInfo:nil];
    [self.adInstlManager adapter:self requestString:@"fail"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:errorMessage];
}
- (void)onPopShowFailed:(NSString *)error{
    AWLogInfo(@"Wap's Instl did load failed");
    
    NSError *errorMessage = [NSError errorWithDomain:error code:0 userInfo:nil];
    [self.adInstlManager adapter:self requestString:@"fail"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:errorMessage];
}
- (void)onPopClose{
    AWLogInfo(@"Wap's Instl did closed");
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

- (void)onPopShow {
    AWLogInfo(@"Wap's Instl did show");
    [self.adInstlManager adapter:self requestString:@"show"];
    [adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
    [adInstlManager adapter:self didGetEvent:InstlEventType_DidShowAd error:nil];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--Waps--stopBeingDelegate");
}

@end
