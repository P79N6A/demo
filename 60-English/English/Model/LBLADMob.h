


#import <Foundation/Foundation.h>

#import <GoogleMobileAds/GoogleMobileAds.h>

@interface LBLADMob : NSObject

/** 0 | 1->免广告 */
@property (nonatomic, assign) BOOL isRemoveAd;

+ (instancetype)sharedInstance;

/** 初次化Ad Id */
+ (void)initAdMob;

/** 预加载插屏广告 */
-(void)GADLoadInterstitial;

/** 插屏广告 */
-(void)GADInterstitialWithVC:(UIViewController *)VC;

/** 横幅广告 */
+(void)GADBannerViewWithVC:(UIViewController *)VC
                   AddView:(UIView *)view;
/** 横幅广告---没有TabBar */
+(void)GADBannerViewNoTabbarHeightWithVC:(UIViewController *)VC;
+(void)GADBannerViewTabbarHeightWithVC:(UIViewController *)VC;
@end
