//
//  GDTMob.h
//  GDTMobDemo
//
//  Created by Jay on 21/5/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface GDTMob : NSObject

+ (instancetype)sharedMod;

+ (void)loadLaunchAD;

+(void)loadBannerAd:(UIViewController *)vc
             adView:(UIView *)view;

+ (void)loadBannerAdNoTabbar:(UIViewController *)vc;
+ (void)loadBannerAdHasTabbar:(UIViewController *)vc;


- (void)loadGDTMobInterstitial:(UIViewController *)vc;
- (void)loadGDTMobInterstitial;
@end
