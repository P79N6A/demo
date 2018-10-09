//
//  ViewController.m
//  InMobiSDK
//
//  Created by Jay on 2018/3/21.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

#import <InMobiSDK/InMobiSDK.h>

@interface ViewController ()<IMBannerDelegate,IMInterstitialDelegate,IMNativeDelegate>
@property (nonatomic, strong) IMBanner *banner;
@property (nonatomic, strong) IMInterstitial *interstitial;
@property(nonatomic,strong) IMNative *InMobiNativeAd;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self initBanner];
//    [self initInterstitial];
    [self initNative];
    
    
    

}



- (void)initNative{
    // test 1501663239052
    // my 1522583826709
    self.InMobiNativeAd = [[IMNative alloc] initWithPlacementId:1501663239052];
    self.InMobiNativeAd.delegate = self;
    [self.InMobiNativeAd load];

}

- (void)initInterstitial{
    //test 1446377525790
    //my 1519886897623
    self. interstitial = [[IMInterstitial alloc] initWithPlacementId:1446377525790];
    self. interstitial.delegate = self;
    [self.interstitial load];

}

- (void)initBanner{
    // test 1447912324502
    // my 1519467465173
    self.banner = [[IMBanner alloc] initWithFrame:CGRectMake(0, 100, 373, 50)
                                      placementId:1447912324502];
    self.banner.delegate = self;
    [self.view addSubview:self.banner];
    [self.banner load];
    //[self.banner shouldAutoRefresh:YES];
    //[self.banner setRefreshInterval:90];

}

#pragma mark IMNativeDelegate

-(void)nativeDidFinishLoading:(IMNative*)native{
//    [self.tableData insertObject:native atIndex:IM_AD_INSERTION_POSITION];
//    [self.tableView reloadData];
    NSLog(@"Native Ad did finish loading");
    
    NSLog(@"%@",native.customAdContent);
    NSLog(@"%@",native.adTitle);
    NSLog(@"%@",native.adDescription);
    NSLog(@"%@",native.adIcon);
    NSLog(@"%@",native.adCtaText);
    NSLog(@"%@",native.adRating);
    NSLog(@"%@",native.adLandingPageUrl);

}

-(void)native:(IMNative*)native didFailToLoadWithError:(IMRequestStatus*)error{
    NSLog(@"Native Ad load Failed"); // No Fill or error
}
-(void)nativeWillPresentScreen:(IMNative*)native{
    NSLog(@"Native Ad will present screen"); //Full Screen experience is about to be presented
}
-(void)nativeDidPresentScreen:(IMNative*)native{
    NSLog(@"Native Ad did present screen"); //Full Screen experience has been presented
}
-(void)nativeWillDismissScreen:(IMNative*)native{
    NSLog(@"Native Ad will dismiss screen"); //Full Screen experience is going to be dismissed
}
-(void)nativeDidDismissScreen:(IMNative*)native{
    NSLog(@"Native Ad did dismiss screen"); //Full Screen experience has been dismissed
}
-(void)userWillLeaveApplicationFromNative:(IMNative*)native{
    NSLog(@"User leave"); //User is about to leave the app on clicking the ad
}
-(void)native:(IMNative *)native didInteractWithParams:(NSDictionary *)params{
    NSLog(@"User clicked"); // Called when the user clicks on the ad.
}
-(void)nativeAdImpressed:(IMNative *)native{
    NSLog(@"User viewed the ad"); // Called when impression event is fired.
}
-(void)nativeDidFinishPlayingMedia:(IMNative*)native{
    NSLog(@"The Video has finished playing"); // Called when the video has finished playing. Used for preroll use-case
}
-(void)native:(IMNative *)native rewardActionCompletedWithRewards:(NSDictionary *)rewards{
    NSLog(@"Rewarded"); // Called when the user is rewarded to watch the ad.
}

#pragma mark IMInterstitialDelegate
/*Indicates that the interstitial is ready to be shown */
- (void)interstitialDidFinishLoading:(IMInterstitial *)interstitial {
    NSLog(@"interstitialDidFinishLoading");
    if (interstitial.isReady) {
        [interstitial showFromViewController:self];
    }
}
/* Indicates that the interstitial has failed to receive an ad. */
- (void)interstitial:(IMInterstitial *)interstitial didFailToLoadWithError:(IMRequestStatus *)error {
    NSLog(@"Interstitial failed to load ad");
    NSLog(@"Error : %@",error.description);
}
/* Indicates that the interstitial has failed to present itself. */
- (void)interstitial:(IMInterstitial *)interstitial didFailToPresentWithError:(IMRequestStatus *)error {
    NSLog(@"Interstitial didFailToPresentWithError");
    NSLog(@"Error : %@",error.description);
}
/* indicates that the interstitial is going to present itself. */
- (void)interstitialWillPresent:(IMInterstitial *)interstitial {
    NSLog(@"interstitialWillPresent");
}
/* Indicates that the interstitial has presented itself */
- (void)interstitialDidPresent:(IMInterstitial *)interstitial {
    NSLog(@"interstitialDidPresent");
}
/* Indicates that the interstitial is going to dismiss itself. */
- (void)interstitialWillDismiss:(IMInterstitial *)interstitial {
    NSLog(@"interstitialWillDismiss");
}
/* Indicates that the interstitial has dismissed itself. */
- (void)interstitialDidDismiss:(IMInterstitial *)interstitial {
    NSLog(@"interstitialDidDismiss");
}
/* Indicates that the user will leave the app. */
- (void)userWillLeaveApplicationFromInterstitial:(IMInterstitial *)interstitial {
    NSLog(@"userWillLeaveApplicationFromInterstitial");
}
/* interstitial:didInteractWithParams: Indicates that the interstitial was interacted with. */
- (void)interstitial:(IMInterstitial *)interstitial didInteractWithParams:(NSDictionary *)params {
    NSLog(@"InterstitialDidInteractWithParams");
}
/* Not used for direct integration. Notifies the delegate that the ad server has returned an ad but assets are not yet available. */
- (void)interstitialDidReceiveAd:(IMInterstitial *)interstitial {
    NSLog(@"interstitialDidReceiveAd");
}


#pragma mark IMBannerDelegate

/*Indicates that the banner has received an ad. */
- (void)bannerDidFinishLoading:(IMBanner *)banner {
    NSLog(@"bannerDidFinishLoading");
}
/* Indicates that the banner has failed to receive an ad */
- (void)banner:(IMBanner *)banner didFailToLoadWithError:(IMRequestStatus *)error {
    NSLog(@"banner failed to load ad");
    NSLog(@"Error : %@", error.description);
}
/* Indicates that the banner is going to present a screen. */
- (void)bannerWillPresentScreen:(IMBanner *)banner {
    NSLog(@"bannerWillPresentScreen");
}
/* Indicates that the banner has presented a screen. */
- (void)bannerDidPresentScreen:(IMBanner *)banner {
    NSLog(@"bannerDidPresentScreen");
}
/* Indicates that the banner is going to dismiss the presented screen. */
- (void)bannerWillDismissScreen:(IMBanner *)banner {
    NSLog(@"bannerWillDismissScreen");
}
/* Indicates that the banner has dismissed a screen. */
- (void)bannerDidDismissScreen:(IMBanner *)banner {
    NSLog(@"bannerDidDismissScreen");
}
/* Indicates that the user will leave the app. */
- (void)userWillLeaveApplicationFromBanner:(IMBanner *)banner {
    NSLog(@"userWillLeaveApplicationFromBanner");
}
/*  Indicates that the banner was interacted with. */
-(void)banner:(IMBanner *)banner didInteractWithParams:(NSDictionary *)params{
    NSLog(@"bannerdidInteractWithParams");
}
/*Indicates that the user has completed the action to be incentivised with .*/
-(void)banner:(IMBanner*)banner rewardActionCompletedWithRewards:(NSDictionary*)rewards{
    NSLog(@"rewardActionCompletedWithRewards");
}


@end
