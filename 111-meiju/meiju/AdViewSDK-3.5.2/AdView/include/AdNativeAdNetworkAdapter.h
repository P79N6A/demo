/*
 
 AdNativeAdNetworkAdapter.h
 
 Copyright 2010 www.adview.cn
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */

#import <Foundation/Foundation.h>
#import "AdNativeManagerDelegate.h"
#import "AdViewConfig.h"
#import "AdViewCommonDef.h"
#import "AdViewNativeAdInfo.h"

@class AdNativeManager;
@class AdViewConfig;
@class AdViewAdNetworkConfig;

@interface AdNativeAdNetworkAdapter : NSObject {
	id<AdNativeManagerDelegate> __weak adNativeDelegate;
	AdNativeManager __weak *adNativeManager;
	AdViewConfig *adNativeConfig;
	AdViewAdNetworkConfig *networkConfig;
	UIViewController *adNativeController;
    
    AdNativeLoadType loadType;
}

/**
 * Subclasses must implement +networkType to return an AdNativeAdNetworkType enum.
 */
+ (AdNativeAdNetworkType)networkType;

/**
 * Subclasses must add itself to the AdViewAdNetworkRegistry. One way
 * to do so is to implement the +load function and register there.
 */
//+ (void)load;

/**
 * Default initializer. Subclasses do not need to override this method unless
 * they need to perform additional initialization. In which case, this
 * method must be called via the super keyword.
 */
- (id)initWithAdNativeDelegate:(id<AdNativeManagerDelegate>)delegate
                      manager:(AdNativeManager *)manager
                       config:(AdViewConfig *)config
                networkConfig:(AdViewAdNetworkConfig *)netConf;

/**
 * Ask the adapter to load an adinstl. This must be implemented by subclasses.
 */
- (void)loadNativeAd:(int)adcount;

/**
 * Ask the adapter to show an adinstl. This must be implemented by subclasses.
 */
- (void)showNativeAd:(UIView*)view withNativeData:(AdViewNativeAdInfo*)adInfo;

/**
 * When called, the adapter must remove itself as a delegate or notification
 * observer from the underlying ad network SDK. Subclasses must implement this
 * method, even if the underlying SDK doesn't have a way of removing delegate
 * (in which case, you should contact the ad network). Note that this method
 * will be called in dealloc at AdNativeAdNetworkAdapter, before adNativeController
 * is released. Care must be taken if you also keep a reference of your ad view
 * in a separate instance variable, as you may have released that variable
 * before this gets called in AdNativeAdNetworkAdapter's dealloc. Use
 * adNativeController, defined in this class, instead of your own instance variable.
 * This function should also be idempotent, i.e. get called multiple times and
 * not crash.
 */
- (void)stopBeingDelegate;

- (void)clickNativeAd:(AdViewNativeAdInfo *)adInfo withClickPoint:(CGPoint)point;

- (void)reportNativeAd:(AdViewNativeAdInfo *)adInfo withStatus:(AdViewNativeVideoStatus)videoStatus withDataAcquisitionObject:(AdViewNativeVideoDataAcquisitionObject*)dataAcquistionObj;


/**
 * Subclasses return YES to ask AdNativeManager to send metric requests to the
 * AdNative server for ad impressions. Default is YES.
 */
- (BOOL)shouldSendExMetric;

/**
 * Tell the adapter that the interface orientation changed or is about to change
 */
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;


/**
 * Some ad transition types may cause issues with particular ad networks. The
 * adapter should know whether the given animation type is OK. Defaults to
 * YES.
 */
- (BOOL)isBannerAnimationOK:(AWBannerAnimationType)animType;

@property (nonatomic,weak) id<AdNativeManagerDelegate> adNativeDelegate;
@property (nonatomic,weak) AdNativeManager *adNativeManager;
@property (nonatomic,retain) AdViewConfig *adNativeConfig;
@property (nonatomic,retain) AdViewAdNetworkConfig *networkConfig;
@property (nonatomic,retain) UIViewController *adNativeController;

@property (nonatomic,assign) BOOL bWaitAd;
@property (nonatomic,assign) AdNativeLoadType loadType;

#pragma mark util method.
- (BOOL) isTestMode;

- (BOOL) isOpenGps;

@end
