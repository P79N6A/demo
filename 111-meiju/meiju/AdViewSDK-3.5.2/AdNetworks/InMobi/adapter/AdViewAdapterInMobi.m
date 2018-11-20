/*
 adview openapi ad-InMobi.
 */

#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdapterInMobi.h"
#import "AdViewExtraManager.h"
#import "AdViewCommonDef.h"
#import "AdViewExtraManager.h"

@interface AdViewAdapterInMobi ()
@end


@implementation AdViewAdapterInMobi

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeInMobi;
}

+ (void)load {
	if(NSClassFromString(@"IMBanner") != nil) {
		[[AdViewAdNetworkRegistry sharedBannerRegistry] registerClass:self];
	}
}

- (void)getAd {
	Class IMBannerClass = NSClassFromString (@"IMBanner");
	
	if (nil == IMBannerClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no inmobi lib, can not create.");
		return;
	}
    
    Class InMobiClass = NSClassFromString(@"IMSdk");
    [InMobiClass initWithAccountID:[self appId]];
    [InMobiClass setLogLevel:kIMSDKLogLevelNone];
    //添加gps
    BOOL gpsON = NO;
    if ([self.adViewDelegate respondsToSelector:@selector(adGpsMode)]) {
        gpsON = [self.adViewDelegate adGpsMode];
        
    }
    if (gpsON) {
        CLLocation *loc =[[AdViewExtraManager sharedManager] getLocation];
        [InMobiClass setLocation:loc];
    }
    
	[self updateSizeParameter];
    NSString *placementID = self.networkConfig.pubId2;
    //1441661978860
    IMBanner *inmobiBanner = [[IMBanner alloc] initWithFrame:self.rSizeAd placementId:[placementID longLongValue] delegate:self];
    [inmobiBanner shouldAutoRefresh:NO];
//	IMBanner *inmobiBanner = [[IMBanner alloc] initWithFrame:self.rSizeAd appId:[self appId] adSize:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?IM_UNIT_728x90:IM_UNIT_320x50];
    
//    inmobiBanner.additionaParameters = [NSDictionary dictionaryWithObject:@"c_adview" forKey:@"tp"];   //4.0.3 渠道方法
    
//    [inmobiBanner setDelegate:self];
    //添加必传字段
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"c_adview" forKey:@"tp"];
    [dict setObject:ADVIEW_VERSION_STR forKey:@"tp-ver"];
    if (inmobiBanner) {
        [inmobiBanner setExtras:[NSDictionary dictionaryWithDictionary:dict]];
    }
	if (nil == inmobiBanner) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
    
//    [inmobiBanner addAdNetworkExtras:extra];
//    [extra release];
    
    [inmobiBanner load];
    
    self.adNetworkView = inmobiBanner;
 }

- (void)stopBeingDelegate {
    IMBanner *inmobiBanner = (IMBanner *)self.adNetworkView;
    if (inmobiBanner != nil) {
//        [inmobiBanner stopLoading];
        [inmobiBanner setDelegate:nil];
        self.adNetworkView = nil;
    }
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
//    int flagArr[] = {IM_UNIT_320x50,IM_UNIT_728x90,
//        IM_UNIT_320x50,IM_UNIT_300x250,
//        IM_UNIT_468x60,IM_UNIT_728x90};
    CGSize sizeArr[] = {CGSizeMake(320, 50),CGSizeMake(728, 90),
        CGSizeMake(320, 50),CGSizeMake(300, 250),
        CGSizeMake(468, 60),CGSizeMake(728, 90)};
    
    [self setSizeParameter:nil size:sizeArr];
}

- (NSString *) appId {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(inmobiApIDString)]) {
		apID = [adViewDelegate inmobiApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	
	return apID;//@"2589a26b446c415c83211d8d89be199e";
	
#if 0
	return @"4f0acf110cf2f1e96d8eb7ea";		//4028cbff3a6eaf57013a9b2847a004bd
#endif
}

#pragma mark delegate 

-(void)bannerDidFinishLoading:(IMBanner*)banner {
    AWLogInfo(@"inmobi did receive ad");
     [adViewView adapter:self didReceiveAdView:banner];
}

-(void)banner:(IMBanner*)banner didFailToLoadWithError:(IMRequestStatus*)error {
    AWLogInfo(@"inmobi did fail to receive ad %@",error);
    [adViewView adapter:self didFailAd:error];
}

-(void)bannerDidDismissScreen:(IMBanner*)banner{
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

- (void)bannerWillDismissScreen:(IMBanner *)banner {
}

-(void)bannerWillPresentScreen:(IMBanner *)banner {
    [self helperNotifyDelegateOfFullScreenModal];
}

-(void)userWillLeaveApplicationFromBanner:(IMBanner*)banner {
}

@end
