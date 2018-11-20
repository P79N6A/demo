/*
 *  AdInstlManagerImpl.h
 *  AdInstlSDK_iOS
 *
 *  Created by zhiwen on 12-9-27.
 *  Copyright 2012 www.adview.cn. All rights reserved.
 *
 */

#import "AdInstlManager.h"
#import "AdInstlManagerDelegate.h"
#import "AdViewDeviceCollector.h"

@class AdViewConfigStore;

@interface AdInstlManager(PRIVATE)
- (void)startGetConfig;
- (void)adapter:(AdInstlAdNetworkAdapter *)adapter didGetEvent:(InstlEventType)eType error:(NSError*)error;

- (void)adapter:(AdInstlAdNetworkAdapter *)adapter requestString:(NSString *)type;

@end

@interface AdInstlManagerImpl : AdInstlManager<AdViewConfigDelegate, AdViewDeviceCollectorDelegate>
{
	AdViewConfig *config;
	AdViewConfig *config_backgroud;	//config fetch in backgroud
	
	NSMutableArray *prioritizedAdNetCfgs;
	
	AdViewConfigStore *configStore;
	NSUInteger configFetchAttempts;
	BOOL		gotConfig;
	
    BOOL        isNeedHangUp;//第一次如果没有配置，挂起请求方法。
                             //等配置请求成功会自动调用生成广告，从而取消挂起；
    
	double		totalPercent;
    
    NSMutableDictionary *pendingAdapters;
	
	AdInstlAdNetworkAdapter *lastAdapter;
	AdInstlAdNetworkAdapter *currAdapter;
	
	NSArray *testDarts;
	NSUInteger testDartIndex;
    
    BOOL        bWaitPresent;
    
    NSDate              *lastRequestTime;
    UIViewController  __weak  *lastController;
    BOOL        bLoadingAd;
    BOOL        singleLoading;//是否为单个平台演示
    
}

@property (nonatomic, retain) AdViewConfig *config;
@property (nonatomic, retain) AdViewConfig *config_backgroud;

@property (nonatomic, retain) NSMutableArray *prioritizedAdNetCfgs;

@property (nonatomic, retain) NSTimer *configTimer;

@property (nonatomic, retain) AdInstlAdNetworkAdapter *lastAdapter;
@property (nonatomic, retain) AdInstlAdNetworkAdapter *currAdapter;

@property (nonatomic, weak) UIViewController *lastController;

@property (nonatomic, retain) NSArray *testDarts;

- (id)initWithAdInstlKey:(NSString*)key
		   WithDelegate:(id<AdInstlManagerDelegate>)_delegate;

- (void)notifyDelegateOfError:(NSError *)error;

- (void)buildPrioritizedAdNetCfgs;

@end