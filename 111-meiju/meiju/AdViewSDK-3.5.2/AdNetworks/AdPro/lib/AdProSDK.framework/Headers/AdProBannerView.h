//
//  AdProBannerView.h
//  AdSDK
//
//  Created by luo on 15/12/2.
//  Copyright © 2015年 Goyoo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ADPRO_AD_SIZE_320x50    CGSizeMake(320, 50) // For iPhone
#define ADPRO_AD_SIZE_468x60    CGSizeMake(468, 60) // For iPad
#define ADPRO_AD_SIZE_768x90    CGSizeMake(768, 90) // For iPad
#define ADPRO_AD_SIZE_FULL_WIDTH_WITH_HEIGHT(height)    CGSizeMake([UIScreen mainScreen].bounds.size.width, height)

@protocol AdProBannerViewDelegate;

@interface AdProBannerView : UIView

/// Initializes a AdProBannerView and sets it to the specified size, and specifies its placement
/// within its superview bounds. Returns nil if |adSize| is an invalid ad size.
- (instancetype)initWithAppID:(NSString *)appID appKey:(NSString *)appKey slotID:(NSString *)slotID adSize:(CGSize)adSize origin:(CGPoint)origin;

/// Optional delegate object that receives state change notifications from this AdProBannerView.
/// Remember to nil this property before deallocating the delegate.
@property (nonatomic, weak) IBOutlet id <AdProBannerViewDelegate> delegate;

/// Required reference to the current view controller.
@property (nonatomic, weak) IBOutlet UIViewController *rootViewController;

/// Download ad data
- (void)loadAd;

@end

/// Delegate methods for receiving AdProBannerView state change messages such as ad request status
/// and ad click lifecycle.
@protocol AdProBannerViewDelegate <NSObject>
@optional

#pragma mark Ad Request Lifecycle Notifications

/// Tells the delegate that an ad request successfully received an ad. The delegate may want to add
/// the banner view to the view hierarchy if it hasn't been added yet.
- (void)AdProBannerViewDidReceiveAd:(AdProBannerView *)bannerView;

/// Tells the delegate that an ad request failed. The failure is normally due to network
/// connectivity or ad availablility (i.e., no fill).
- (void)AdProBannerView:(AdProBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error;

#pragma mark Click-Time Lifecycle Notifications

/// Tells the delegate that a full screen view will be presented in response to the user clicking on
/// an ad. The delegate may want to pause animations and time sensitive interactions.
- (void)AdProBannerViewWillPresentScreen:(AdProBannerView *)bannerView;

/// Tells the delegate that the full screen view has been dismissed. The delegate should restart
/// anything paused while handling AdProBannerViewWillPresentScreen:.
- (void)AdProBannerViewDidDismissScreen:(AdProBannerView *)bannerView;

/// Tells the delegate that the user click will open another app, backgrounding the current
/// application. The standard UIApplicationDelegate methods, like applicationDidEnterBackground:,
/// are called immediately after this method is called.
- (void)AdProBannerViewWillLeaveApplication:(AdProBannerView *)bannerView;

@end

