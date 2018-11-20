//
//  AdInstlAdapterPingcoo.m
//  AdInstlSDK_iOS
//
//  Created by adview on 13-9-2.
//
//

#import "AdInstlAdapterPingcoo.h"

#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"

@implementation AdInstlAdapterPingcoo
@synthesize parent;

+ (AdInstlAdNetworkType)networkType {
    return AdInstlAdNetWorkTypePingcoo;
}

+ (void)load {
    if(NSClassFromString(@"pingcooSDK") != nil) {
		[[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
	}
}

- (BOOL)loadAdInstl:(UIViewController *)controller {
    Class pingcooSDKClass = NSClassFromString(@"pingcooSDK");
    if (pingcooSDKClass == nil) return NO;
    if (nil == controller) return NO;
    self.parent = controller;
    NSString * appID = self.networkConfig.pubId;
    pingcoo = [pingcooSDKClass initWithKey:appID];
    
    pingcoo.delegate = self;
//    pingcoo.isTest = [self isTestMode];
//    
//    pingcoo.rootViewController = self.parent;
    [self.adInstlManager adapter:self requestString:@"req"];
//    [pingcoo pauseShow];
    [pingcoo PauseAdShow:@"1"];
    [pingcoo popShow:self.parent.view showTime:10];
    
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
     
    return YES;
}

-(void)show:(pingcooSDK *)show didFailWithError:(NSError *)error
{
    if (!error.code == -3310) {
        [self.adInstlManager adapter:self requestString:@"fail"];
    }
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:error];
    AWLogInfo(@"%@",error);
}

-(void)show:(pingcooSDK *)show didFinishDisappearWithResult:(id)result
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
}

-(void)show:(pingcooSDK *)show didFinishAppearWithResult:(id)result
{
    [self.adInstlManager adapter:self requestString:@"suc"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"pingcoo stop being delegate");
    self.parent = nil;
    pingcoo.delegate = nil;
    pingcoo = nil;
}

@end
