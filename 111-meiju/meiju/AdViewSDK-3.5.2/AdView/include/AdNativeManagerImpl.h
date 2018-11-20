/*
 *  AdNativeManagerImpl.h
 *  AdNativeSDK_iOS
 *
 *  Created by zhiwen on 12-9-27.
 *  Copyright 2012 www.adview.cn. All rights reserved.
 *
 */

#import "AdNativeManager.h"
#import "AdNativeManagerDelegate.h"
#import "AdViewDeviceCollector.h"

@class AdViewConfigStore;

@interface AdNativeManager(PRIVATE)
- (void)startGetConfig;
- (void)adapter:(AdNativeAdNetworkAdapter *)adapter report:(AdNativeReportType)eType;
- (void)adapter:(AdNativeAdNetworkAdapter *)adapter didReceivedNativeAd:(NSArray*)array;
- (void)adapter:(AdNativeAdNetworkAdapter *)adapter failedRequestNativeAd:(NSError*)error;

@end

@interface AdNativeManagerImpl : AdNativeManager<AdViewConfigDelegate, AdViewDeviceCollectorDelegate>
{
	AdViewConfig *config;
	AdViewConfig *config_backgroud;	//config fetch in backgroud
	
	NSMutableArray *prioritizedAdNetCfgs;
	
	AdViewConfigStore *configStore;
	NSUInteger configFetchAttempts;
    
	BOOL		gotConfig;
    BOOL        isNeedHangUp;
	double		totalPercent;
    
    NSMutableDictionary *pendingAdapters;
	
	AdNativeAdNetworkAdapter *lastAdapter;
	AdNativeAdNetworkAdapter *currAdapter;
	
	NSArray *testDarts;
	NSUInteger testDartIndex;
    
    BOOL        bWaitPresent;
    
    NSDate              *lastRequestTime;
    int         adCount;
    BOOL        bLoadingAd;
    BOOL        singleLoading;//是否为单个平台演示
    
}

@property (nonatomic, retain) AdViewConfig *config;
@property (nonatomic, retain) AdViewConfig *config_backgroud;

@property (nonatomic, retain) NSMutableArray *prioritizedAdNetCfgs;

@property (nonatomic, retain) NSTimer *configTimer;

@property (nonatomic, retain) AdNativeAdNetworkAdapter *lastAdapter;
@property (nonatomic, retain) AdNativeAdNetworkAdapter *currAdapter;

@property (nonatomic, retain) NSArray *testDarts;

- (id)initWithAdNativeKey:(NSString*)key
		   WithDelegate:(id<AdNativeManagerDelegate>)_delegate;

- (void)notifyDelegateOfError:(NSError *)error;

- (void)buildPrioritizedAdNetCfgs;

@end