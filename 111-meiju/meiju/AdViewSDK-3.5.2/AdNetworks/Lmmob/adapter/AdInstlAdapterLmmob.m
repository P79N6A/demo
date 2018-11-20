//
//  AdInstlAdapterLmmob.m
//  AdInstlSDK_iOS
//
//  Created by Ma ming on 13-5-8.
//
//

#import "AdInstlAdapterLmmob.h"
#import "AdViewAdNetworkConfig.h"
#import "AdInstlManagerDelegate.h"
#import "adViewLog.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdInstlManagerImpl.h"

@implementation AdInstlAdapterLmmob

@synthesize parent;
@synthesize immobInstl;

+ (AdInstlAdNetworkType)networkType {
    return AdInstlAdNetWorkTypeLmmob;
}

+ (void)load {
    if(NSClassFromString(@"MMediaView") != nil) {
		[[AdViewAdNetworkRegistry sharedInstlRegistry] registerClass:self];
	}
}

- (BOOL)loadAdInstl:(UIViewController *)controller {
    Class LmmobInstlClass = NSClassFromString(@"MMediaView");
    if (LmmobInstlClass == nil) return NO;
    if (nil == controller) return NO;
    self.parent = controller;
    NSString * appID = self.networkConfig.pubId;
    self.immobInstl = [[MBJoyView alloc] initWithId:appID mMediatype:MBJoyTypeMediumRectangle rootViewController:self.parent userInfo:nil];
    self.immobInstl.delegate = self;
    [self.adInstlManager adapter:self requestString:@"req"];
    [self.immobInstl mBJoyRequest];
    [self.parent.view addSubview:immobInstl];
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
    if ([self.immobInstl isReady]) {
        [self.adInstlManager adapter:self requestString:@"show"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_WillPresentAd error:nil];
        [self.immobInstl mBJoyDisplay];
    } else {
        [self.adInstlManager adapter:self requestString:@"fail"];
        [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:nil];
        return NO;
    }
    
    return YES;
}

- (void) didLoad
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidLoadAd error:nil];
}
#pragma mark - 
#pragma mark Lmmob delegate

- (UIViewController *)immobViewController {
    return self.parent;
}

- (void)mBJoyViewDidReceiveAd:(MBJoyView*)mBJoyView
{
    [self.adInstlManager adapter:self requestString:@"suc"];
    [self performSelector:@selector(didLoad) withObject:self afterDelay:1];
}

- (void)mBJoyView: (MBJoyView*) mBJoyView didFailToReceiveMBJoyAdWithError: (NSInteger) errorCode
{
     NSError *errorMessage = [NSError errorWithDomain:[NSString stringWithFormat:@"error:%ld",(long)errorCode] code:errorCode userInfo:nil];
    [self.adInstlManager adapter:self requestString:@"fail"];
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_FailLoadAd error:errorMessage];
}

- (void)mBJoyOnLeaveApplication:(MBJoyView *)mBJoyView
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidClickAd error:nil];
    [self.adInstlManager adapter:self requestString:@"click"];
}


- (void)mBJoyOnDismissScreen:(MBJoyView *)mBJoyView
{
    [self.adInstlManager adapter:self didGetEvent:InstlEventType_DidDismissAd error:nil];
    [self.immobInstl mBJoyDestroy];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"Lmmob stop being delegate");
    if (self.immobInstl) {
        self.immobInstl.delegate = nil;
        self.immobInstl = nil;
    }
    self.parent = nil;
}

@end
