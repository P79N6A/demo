/*
 
 AdInstlAdNetworkAdapter.h
 
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
#import "AdInstlManagerDelegate.h"
#import "AdViewConfig.h"
#import "AdViewCommonDef.h"

@class AdInstlManager;
@class AdViewConfig;
@class AdViewAdNetworkConfig;

@interface AdInstlAdNetworkAdapter : NSObject {
	id<AdInstlManagerDelegate> __weak adInstlDelegate;
	AdInstlManager __weak *adInstlManager;
	AdViewConfig *adInstlConfig;
	AdViewAdNetworkConfig *networkConfig;
	UIViewController *adInstlController;
    
    AdInstlLoadType loadType;
}

/**
 * Subclasses must implement +networkType to return an AdInstlAdNetworkType enum.
 */
+ (AdInstlAdNetworkType)networkType;

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
- (id)initWithAdInstlDelegate:(id<AdInstlManagerDelegate>)delegate
                      manager:(AdInstlManager *)manager
                       config:(AdViewConfig *)config
                networkConfig:(AdViewAdNetworkConfig *)netConf;

/**
 * Ask the adapter to load an adinstl. This must be implemented by subclasses.
 */
- (BOOL)loadAdInstl:(UIViewController*)controller;

/**
 * Ask the adapter to show an adinstl. This must be implemented by subclasses.
 */
- (BOOL)showAdInstl:(UIViewController*)controller;

/**
 * When called, the adapter must remove itself as a delegate or notification
 * observer from the underlying ad network SDK. Subclasses must implement this
 * method, even if the underlying SDK doesn't have a way of removing delegate
 * (in which case, you should contact the ad network). Note that this method
 * will be called in dealloc at AdInstlAdNetworkAdapter, before adInstlController
 * is released. Care must be taken if you also keep a reference of your ad view
 * in a separate instance variable, as you may have released that variable
 * before this gets called in AdInstlAdNetworkAdapter's dealloc. Use
 * adInstlController, defined in this class, instead of your own instance variable.
 * This function should also be idempotent, i.e. get called multiple times and
 * not crash.
 */
- (void)stopBeingDelegate;

/**
 * Subclasses return YES to ask AdInstlManager to send metric requests to the
 * AdInstl server for ad impressions. Default is YES.
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

@property (nonatomic,weak) id<AdInstlManagerDelegate> adInstlDelegate;
@property (nonatomic,weak) AdInstlManager *adInstlManager;
@property (nonatomic,retain) AdViewConfig *adInstlConfig;
@property (nonatomic,retain) AdViewAdNetworkConfig *networkConfig;
@property (nonatomic,retain) UIViewController *adInstlController;

@property (nonatomic,assign) BOOL bWaitAd;
@property (nonatomic,assign) AdInstlLoadType loadType;

@property (nonatomic, assign)BOOL preRender;

#pragma mark util method.
- (BOOL) isTestMode;

- (BOOL) isOpenGps;

@end
