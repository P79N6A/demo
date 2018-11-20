//
//  AdProInterstitial.h
//  AdSDK
//
//  Created by luo on 15/12/2.
//  Copyright © 2015年 Goyoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdProInterstitialDelegate;

@interface AdProInterstitial : NSObject

/// Initializes a AdProInterstitialAd.
- (instancetype)initWithAppID:(NSString *)appID appKey:(NSString *)appKey slotID:(NSString *)slotID;

/// Optional delegate object that receives state change notifications from this AdProInterstitalAd.
/// Remember to nil this property before deallocating the delegate.
@property(nonatomic, weak) id<AdProInterstitialDelegate> delegate;

/// Returns YES if the interstitial is ready to be displayed. The delegate's
/// AdProInterstitialDidReceiveAd: will be called after this property switches from NO to YES.
@property(nonatomic, readonly, assign) BOOL isReady;

/// Download ad data
- (void)loadAd;

/// Presents the interstitial ad which takes over the entire screen until the user dismisses it.
/// This has no effect unless isReady returns YES and/or the delegate's AdProInterstitialDidReceiveAd:
/// has been received.
///
/// Set rootViewController to the current view controller at the time this method is called.
- (void)presentFromRootViewController:(UIViewController *)rootViewController;

- (void)loadAdAndAutoPresentFromRootViewController:(UIViewController *)rootViewController;

@end

/// Delegate for receiving state change messages from a AdProInterstitial such as interstitial ad
/// requests succeeding/failing.
@protocol AdProInterstitialDelegate<NSObject>

@optional

#pragma mark Ad Request Lifecycle Notifications

/// Called when an interstitial ad request succeeded. Show it at the next transition point in your
/// application such as when transitioning between view controllers.
- (void)AdProInterstitialDidReceiveAd:(AdProInterstitial *)ad;

/// Called when an interstitial ad request completed without an interstitial to
/// show. This is common since interstitials are shown sparingly to users.
- (void)AdProInterstitial:(AdProInterstitial *)ad didFailToReceiveAdWithError:(NSError *)error;

#pragma mark Display-Time Lifecycle Notifications

/// Called just before presenting an interstitial. After this method finishes the interstitial will
/// animate onto the screen. Use this opportunity to stop animations and save the state of your
/// application in case the user leaves while the interstitial is on screen (e.g. to visit the App
/// Store from a link on the interstitial).
- (void)AdProInterstitialWillPresentScreen:(AdProInterstitial *)ad;

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)AdProInterstitialDidDismissScreen:(AdProInterstitial *)ad;

/// Called just before the application will background or terminate because the user clicked on an
/// ad that will launch another application (such as the App Store). The normal
/// UIApplicationDelegate methods, like applicationDidEnterBackground:, will be called immediately
/// after this.
- (void)AdProInterstitialWillLeaveApplication:(AdProInterstitial *)ad;

@end



