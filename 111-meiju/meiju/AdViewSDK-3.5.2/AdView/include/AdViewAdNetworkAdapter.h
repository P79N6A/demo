/*

 AdViewAdNetworkAdapter.h

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

#import "AdViewDelegateProtocol.h"
#import "adViewConfig.h"
#import "AdViewCommonDef.h"

typedef enum {
    AdViewAdNetworkWaitFlag_None = 0,
    AdViewAdNetworkWaitFlag_BannerAd = 0x01,
    AdViewAdNetworkWaitFlag_PresentScreen = 0x02,
} AdViewAdNetworkWaitFlag;

typedef enum {
    AdViewAdNetworkBlockFlag_None = 0,
    AdViewAdNetworkBlockFlag_BannerAd = 0x01,
    AdViewAdNetworkBlockFlag_PresentScreen = 0x02,      //For Present, should not dealloc
} AdViewAdNetworkBlockFlag;

@class AdViewView;
@class AdViewConfig;
@class AdViewAdNetworkConfig;

@interface AdViewAdNetworkAdapter : NSObject {
  id<AdViewDelegate> __weak adViewDelegate;
  AdViewView __weak *adViewView;
  AdViewConfig *adViewConfig;
  AdViewAdNetworkConfig *networkConfig;
  UIView *adNetworkView;
    UIView *actAdView;
    
    NSTimer* dummyHackTimer;
    
    int        nAdWaitFlag;
    int        nAdBlockFlag;
    
    
}

/**
 * Subclasses must implement +networkType to return an AdViewAdNetworkType enum.
 */
+ (AdViewAdNetworkType)networkType;

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
- (id)initWithAdViewDelegate:(id<AdViewDelegate>)delegate
                         view:(AdViewView *)view
                       config:(AdViewConfig *)config
                networkConfig:(AdViewAdNetworkConfig *)netConf;

/**
 * Ask the adapter to get an ad. This must be implemented by subclasses.
 */
- (void)getAd;

/**
 * When called, the adapter must remove itself as a delegate or notification
 * observer from the underlying ad network SDK. Subclasses must implement this
 * method, even if the underlying SDK doesn't have a way of removing delegate
 * (in which case, you should contact the ad network). Note that this method
 * will be called in dealloc at AdViewAdNetworkAdapter, before adNetworkView
 * is released. Care must be taken if you also keep a reference of your ad view
 * in a separate instance variable, as you may have released that variable
 * before this gets called in AdViewAdNetworkAdapter's dealloc. Use
 * adNetworkView, defined in this class, instead of your own instance variable.
 * This function should also be idempotent, i.e. get called multiple times and
 * not crash.
 */
- (void)stopBeingDelegate;

/**
 * Subclasses return YES to ask AdViewView to send metric requests to the
 * AdView server for ad impressions. Default is YES.
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

/**
 * Update size paramter of ad banner.
 */
- (void)updateSizeParameter;
//array: auto for iphone, auto for ipad, 320x50, 300x250, 480x60, 728x90
- (void)setSizeParameter:(int*)flags size:(CGSize*)sizes;
//array: auto for iphone, auto for ipad, 320x50, 300x250, 480x60, 728x90
- (void)setSizeParameter:(int*)flags rect:(CGRect*)rects;
//get index of size in size parameter array.
- (int)getSizeIndex;

- (void) setupDummyHackTimer:(NSTimeInterval)interval;
- (void) setupDefaultDummyHackTimer; //
- (void) cleanupDummyHackTimer;
- (void) dummyHackTimerHandler;

- (void) cleanupDummyRetain;

- (BOOL) canClearDelegate;                  //can set adViewView and adViewDelegate as nil.
- (BOOL) canMultiBeingDelegate;             //can being delegate even more than one instances being delegate.

+ (void) setDummyHackTimeInterval:(int)interval;

/**
 * Get image of act ad view, add to show, and remove act ad view.
 */
- (void)getImageOfActAdViewForRemove;

/**
 * Added act ad view by a contain view as adNetWorkView.
 */
- (void)addActAdViewInContain:(UIView*)actView rect:(CGRect)rect;

@property (nonatomic,weak) id<AdViewDelegate> adViewDelegate;
@property (nonatomic,weak) AdViewView *adViewView;
@property (nonatomic,retain) AdViewConfig *adViewConfig;
@property (nonatomic,retain) AdViewAdNetworkConfig *networkConfig;
@property (nonatomic,retain) UIView *adNetworkView;
@property (retain) UIView *actAdView;

@property (nonatomic,assign) BOOL		bWaitAd;

@property (nonatomic,assign) int        nAdWaitFlag;
@property (nonatomic,assign) int        nAdBlockFlag;

@property (nonatomic,assign) BOOL		bGotView;       //got view and added to AdViewView.

@property (nonatomic,assign) int		nSizeAd;
@property (nonatomic,assign) CGRect		rSizeAd;
@property (nonatomic,assign) CGSize		sSizeAd;

@property (nonatomic, retain) NSTimer* dummyHackTimer;

@property (nonatomic, assign)BOOL preRender;

@end
