//
//  GDTMob.m
//  GDTMobDemo
//
//  Created by Jay on 21/5/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "GDTMob.h"
#import "AppDelegate.h"

#import <GDTMobSDK/GDTSDKConfig.h>
#import <GDTMobSDK/GDTSplashAd.h>
#import <GDTMobSDK/GDTMobBannerView.h>
#import <GDTMobSDK/GDTMobInterstitial.h>


#ifdef DEBUG
// 测试 应用ID
#define kGDTMobSDKAppId @"1105344611"
//插页式广告ID
#define kGDTMobSDKInterstitialId @"2030814134092814"
//横幅广告ID
#define kGDTMobSDKBannerId  @"4090812164690039"
//开屏广告ID
#define kGDTMobSDKSplashId  @"9040714184494018"

#else
// 应用ID
#define kGDTMobSDKAppId @"1106795321"
//插页式广告ID
#define kGDTMobSDKInterstitialId @"3030838451522909"
//横幅广告ID
#define kGDTMobSDKBannerId  @"3080534441034040"
//开屏广告ID
#define kGDTMobSDKSplashId  @"5070231491510944"

#endif

#define IS_IPHONEX (([[UIScreen mainScreen] nativeBounds].size.height-2436)?NO:YES)



static GDTMob *instance = nil;

@interface GDTMob()<GDTSplashAdDelegate,GDTMobBannerViewDelegate,GDTMobInterstitialDelegate>

@property (strong, nonatomic) GDTSplashAd *splash;
@property (nonatomic, strong) GDTMobInterstitial *interstitial;


@end


@implementation GDTMob

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [super allocWithZone:zone];
        
    });
    
    return instance;
}


+ (instancetype)sharedMod{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        
    });
    
    return instance;
}



+ (void)initialize{
    [GDTSDKConfig setHttpsOn];
}

+ (UIImage *)imageResize:(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (void)loadLaunchAD{
    
    //开屏广告初始化并展示代码
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        GDTSplashAd *splash = [[GDTSplashAd alloc] initWithAppId:kGDTMobSDKAppId placementId:kGDTMobSDKSplashId];
        splash.delegate = GDTMob.sharedMod;
        UIImage *splashImage = [UIImage imageNamed:@"SplashNormal"];
        if (IS_IPHONEX) {
            splashImage = [UIImage imageNamed:@"SplashX"];
        } else if ([UIScreen mainScreen].bounds.size.height == 480) {
            splashImage = [UIImage imageNamed:@"SplashSmall"];
        }
        UIImage *backgroundImage = [GDTMob imageResize:splashImage
                                                andResizeTo:[UIScreen mainScreen].bounds.size];
        splash.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        splash.fetchDelay = 3;
        AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        [splash loadAdAndShowInWindow:delegate.window];
        GDTMob.sharedMod.splash = splash;
        
    }

}


- (void)loadGDTMobInterstitial {
    
    
    if (self.interstitial.isReady) return;
    
    if(self.interstitial) {
        self.interstitial.delegate = nil;
    }
    
    self.interstitial = [[GDTMobInterstitial alloc] initWithAppId:kGDTMobSDKAppId placementId:kGDTMobSDKInterstitialId];
    self.interstitial.delegate = self;
    
    [self.interstitial loadAd];
    
}

- (void)GADInterstitialWithVC:(UIViewController *)vc {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.interstitial.isReady) {
            [self.interstitial presentFromRootViewController:vc];
            
        } else {
            
            NSLog(@"Ad wasn't ready");
            
            [self loadGDTMobInterstitial];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (vc && self.interstitial.isReady) {
                    
                    [self.interstitial presentFromRootViewController:vc];
                }
            });
        }
    });
}


+(void)loadBannerAd:(UIViewController *)vc
             adView:(UIView *)view{

    
    GDTMobBannerView *bannerView = [[GDTMobBannerView alloc] initWithAppId:kGDTMobSDKAppId placementId:kGDTMobSDKBannerId];
    bannerView.currentViewController = vc;
    //bannerView.interval = ;
    //bannerView.isAnimationOn = ;
    //bannerView.showCloseBtn = ;
    //bannerView.isGpsOn = ;
    bannerView.delegate = GDTMob.sharedMod;
    
    [view addSubview:bannerView];
    
    bannerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
    [bannerView loadAdAndShow];

}

+(void)loadBannerAdNoTabbar:(UIViewController *)vc{
    
    
    GDTMobBannerView *bannerView = [[GDTMobBannerView alloc] initWithAppId:kGDTMobSDKAppId placementId:kGDTMobSDKBannerId];
    bannerView.currentViewController = vc;
    //bannerView.interval = ;
    //bannerView.isAnimationOn = ;
    //bannerView.showCloseBtn = ;
    //bannerView.isGpsOn = ;
    bannerView.delegate = GDTMob.sharedMod;
    
    [vc.view addSubview:bannerView];
    
    CGFloat y = [UIScreen mainScreen].bounds.size.height - 50 - (IS_IPHONEX? 34: 0);
    bannerView.frame = CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, 50);
    [bannerView loadAdAndShow];
}

+(void)loadBannerAdHasTabbar:(UIViewController *)vc {
    
    GDTMobBannerView *bannerView = [[GDTMobBannerView alloc] initWithAppId:kGDTMobSDKAppId placementId:kGDTMobSDKBannerId];
    bannerView.currentViewController = vc;
    //bannerView.interval = ;
    //bannerView.isAnimationOn = ;
    //bannerView.showCloseBtn = ;
    //bannerView.isGpsOn = ;
    bannerView.delegate = GDTMob.sharedMod;
    
    [vc.view addSubview:bannerView];
    
    CGFloat y = [UIScreen mainScreen].bounds.size.height - 50 - 49 - (IS_IPHONEX? 34: 0);
    bannerView.frame = CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, 50);
    [bannerView loadAdAndShow];
}



@end
