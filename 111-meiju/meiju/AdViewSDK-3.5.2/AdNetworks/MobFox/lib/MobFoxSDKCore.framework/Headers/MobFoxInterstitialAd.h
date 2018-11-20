//
//  MobFoxInterstitialVideo.h
//  MobFoxSDKSource
//
//  Created by Itamar Nabriski on 8/12/15.
//
//

#ifndef MobFoxSDKSource_MobFoxInterstitialVideo_h
#define MobFoxSDKSource_MobFoxInterstitialVideo_h

#include "MobFoxAd.h"
#import "MobFoxInterstitialCustomEvent.h"


@class MobFoxInterstitialAd;


@protocol MobFoxInterstitialAdDelegate <NSObject>


@required

- (void)MobFoxInterstitialAdDidLoad:(MobFoxInterstitialAd *)interstitial;

@optional

- (void)MobFoxInterstitialAdDidFailToReceiveAdWithError:(NSError *)error;

- (void)MobFoxInterstitialAdWillShow:(MobFoxInterstitialAd *)interstitial;

- (void)MobFoxInterstitialAdClosed;

- (void)MobFoxInterstitialAdClicked;

- (void)MobFoxInterstitialAdFinished;

@end


@interface MobFoxInterstitialAd : NSObject<MobFoxAdDelegate,MobFoxInterstitialCustomEventDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate>


@property (nonatomic, weak) id<MobFoxInterstitialAdDelegate> delegate;
@property (nonatomic, weak) UIViewController* rootViewController;

@property BOOL ready;


@property (nonatomic, strong) MFLocationServicesManager *locationServicesManager;


-(id) init:(NSString*)invh;
-(id) init:(NSString*)invh withRootViewController:(UIViewController*)root;
-(void) loadAd;
-(void) show;
+ (void)locationServicesDisabled:(BOOL)disabled;
- (void)dismissAd;

@property (nonatomic, strong) NSString* invh;

@property (nonatomic, copy) NSString* longitude;
@property (nonatomic, copy) NSString* latitude;
@property (nonatomic, copy) NSString* demo_gender; //"m/f"
@property (nonatomic, copy) NSString* demo_age;
@property (nonatomic, copy) NSString* s_subid;
@property (nonatomic, copy) NSString* sub_name;
@property (nonatomic, copy) NSString* sub_domain;
@property (nonatomic, copy) NSString* sub_storeurl;
@property (nonatomic, copy) NSString* r_floor;

//set this (in seconds) to make the ad refresh
@property (nonatomic, assign) NSNumber* refresh;
@property (nonatomic, copy) NSNumber* v_dur_min;
@property (nonatomic, copy) NSNumber* v_dur_max;

@property (nonatomic, assign) BOOL autoplay;

@end

#endif
