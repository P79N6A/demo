/*
 *  AdSpreadScreenManagerImpl.h
 *  AdSpreadScreenSDK_iOS
 *
 *  Created by zhiwen on 12-9-27.
 *  Copyright 2012 www.adview.cn. All rights reserved.
 *
 */

#import "AdSpreadScreenManager.h"
#import "AdSpreadScreenManagerDelegate.h"
#import "AdViewDeviceCollector.h"

@class AdViewConfigStore;

@interface AdSpreadScreenManager(PRIVATE)
- (void)startGetConfig;
- (void)adapter:(AdSpreadScreenAdNetworkAdapter *)adapter didGetEvent:(SpreadScreenEventType)eType error:(NSError*)error;

- (void)adapter:(AdSpreadScreenAdNetworkAdapter *)adapter requestString:(NSString *)type;

@end

@interface AdSpreadScreenManagerImpl : AdSpreadScreenManager<AdViewConfigDelegate, AdViewDeviceCollectorDelegate>
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
	
	AdSpreadScreenAdNetworkAdapter *lastAdapter;
	AdSpreadScreenAdNetworkAdapter *currAdapter;
	
	NSArray *testDarts;
	NSUInteger testDartIndex;
    
    BOOL        bWaitPresent;
    
    NSDate              *lastRequestTime;
    UIViewController    __weak *lastController;
    BOOL        bLoadingAd;
    BOOL        singleLoading;//是否为单个平台演示
    
}

@property (nonatomic, retain) AdViewConfig *config;
@property (nonatomic, retain) AdViewConfig *config_backgroud;

@property (nonatomic, retain) NSMutableArray *prioritizedAdNetCfgs;

@property (nonatomic, retain) NSTimer *configTimer;

@property (nonatomic, retain) AdSpreadScreenAdNetworkAdapter *lastAdapter;
@property (nonatomic, retain) AdSpreadScreenAdNetworkAdapter *currAdapter;

@property (nonatomic, weak) UIViewController *lastController;

@property (nonatomic, retain) NSArray *testDarts;

- (id)initWithAdSpreadScreenKey:(NSString*)key
		   WithDelegate:(id<AdSpreadScreenManagerDelegate>)_delegate;

- (void)notifyDelegateOfError:(NSError *)error;

- (void)buildPrioritizedAdNetCfgs;

@end