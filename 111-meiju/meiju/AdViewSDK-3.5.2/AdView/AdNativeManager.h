//
//  AdNativeManager.h
//  AdNativeSDK_iOS
//
//  Created by zhiwen on 12-12-27.
//  Copyright 2012 www.adview.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdNativeManagerDelegate.h"
#import "AdViewNativeAdInfo.h"

@interface AdNativeManager : NSObject {
	id<AdNativeManagerDelegate> __weak delegate;
	
	NSString *adNativeKey;
    NSString *appChannel;
    BOOL autoRoll;
}

/**
 * 托管对象，注意如果要释放AdNativeManager，先将这个值设为nil。
 * 如果要切换托管对象，请确保切换后的对象有效
 */
@property (nonatomic, weak) id<AdNativeManagerDelegate> delegate;

@property (nonatomic, retain) NSString *adNativeKey;		//same as adviewKey.
@property (nonatomic, retain) NSString *appChannel;   //like appstore, cydia, 91Store, etc.

/**
 * 如果加载插屏广告失败，则是否自动切换到下一个插屏广告平台的标志。显示失败不会自动切换。
 * 缺省为YES
 */
@property (nonatomic, assign) BOOL autoRoll;

+ (id)managerWithAdNativeKey:(NSString*)key
		   WithDelegate:(id<AdNativeManagerDelegate>)_delegate;

/**
 * 预加载广告
 * 如果要改变delegate，请在调用本函数前设置delegate
 */
- (void)loadNativeAd:(int)count;

/**
 * 单个加载广告平台
 */
- (void)loadSingleAdNative:(int)count withIndex:(int)index;

/**
 * 当前广告平台名称
 */
- (NSString *)currentNetworkName;

/**
 * 获取当前的渠道号
 */
- (NSString *)marketChannel;

@end
