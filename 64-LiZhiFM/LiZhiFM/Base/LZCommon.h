//
//  LZCommon.h
//  LiZhiFM
//
//  Created by czljcb on 2018/4/18.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#ifndef LZCommon_h
#define LZCommon_h

#define cachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject]
#define IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kViewRadius(View,Radius)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

#define kViewBorderRadius(View,Radius,Width,Color)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]


#define kRandomColor kRGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define kColorWithHexString(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
#define kCommonColor  kRGBColor(255, 201, 56)
#define kBackgroundColor  kRGBColor(236, 237, 238)
#define kRGBColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]
#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]

#define kScreenSize  [UIScreen mainScreen].bounds.size
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

// iPhone X
#define  iPhoneX (kScreenW == 375.f && kScreenH == 812.f ? YES : NO)

// #define  StatusBarHeight      (iPhoneX ? 44.f : 20.f)
#define  kStatusBarHeight      [[UIApplication sharedApplication] statusBarFrame].size.height

// Navigation bar height.
#define  kNavigationBarHeight  44.f

// Tabbar height.
#define  kTabbarHeight         (iPhoneX ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define  kTabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)

// Status bar & navigation bar height.
#define  kStatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)


#ifdef DEBUG

#define NSLog(...) NSLog(__VA_ARGS__)

#define XCID @"9314623159490cb60f3466088aec311d98ac2977"
// 测试 应用ID
#define kGoogleMobileAdsAppID @"ca-app-pub-3940256099942544~1458002511"

//激励视频广告ID
#define kGoogleMobileAdsVideoID  @"ca-app-pub-3940256099942544/1712485313"

//插页式广告ID
#define kGoogleMobileAdsInterstitialID @"ca-app-pub-3940256099942544/4411468910"

//横幅广告ID
#define kGoogleMobileAdsBannerID  @"ca-app-pub-3940256099942544/6300978111"

#else

#define NSLog(...)

#define XCID @""
// 应用ID
#define kGoogleMobileAdsAppID @"ca-app-pub-8803735862522697~2763745746"

//插页式广告ID
#define kGoogleMobileAdsInterstitialID @"ca-app-pub-8803735862522697/9520671880"

//横幅广告ID
#define kGoogleMobileAdsBannerID @"ca-app-pub-8803735862522697/4188508056"

#endif


#endif /* LZCommon_h */
