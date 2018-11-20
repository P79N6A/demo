/*
 *  AdVideoManagerImpl.h
 *  AdVideoSDK_iOS
 *
 *  Created by zhiwen on 12-9-27.
 *  Copyright 2012 www.adview.cn. All rights reserved.
 *
 */

#import "AdVideoManager.h"
#import "AdVideoManagerDelegate.h"
#import "AdViewDeviceCollector.h"

@class AdViewConfigStore;

@interface AdVideoManager(PRIVATE)
- (void)startGetConfig;
- (void)adapter:(AdVideoAdNetworkAdapter *)adapter didGetEvent:(VideoEventType)eType error:(NSError*)error;
@end

@interface AdVideoManagerImpl : AdVideoManager<AdViewConfigDelegate, AdViewDeviceCollectorDelegate>
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
	
	AdVideoAdNetworkAdapter *lastAdapter;
	AdVideoAdNetworkAdapter *currAdapter;
	
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

@property (nonatomic, retain) AdVideoAdNetworkAdapter *lastAdapter;
@property (nonatomic, retain) AdVideoAdNetworkAdapter *currAdapter;

@property (nonatomic, weak) UIViewController *lastController;

@property (nonatomic, retain) NSArray *testDarts;

- (id)initWithAdVideoKey:(NSString*)key
		   WithDelegate:(id<AdVideoManagerDelegate>)_delegate;

- (void)notifyDelegateOfError:(NSError *)error;

- (void)buildPrioritizedAdNetCfgs;

@end