//
//  common.h
//  WebPlayer
//
//  Created by czljcb on 2018/3/6.
//  Copyright © 2018年 Jay. All rights reserved.
//

#ifndef common_h
#define common_h

#define kColorWithHexString(hex)    [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
#define kRGBColor(r, g, b)          [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]

#define kCommonColor        kColorWithHexString(0x1296db)
#define kBackgroundColor    kRGBColor(236, 237, 238)
#define kRandomColor        kRGBColor(arc4random_uniform(256), arc4random_uniform(256),arc4random_uniform(256))

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height


#define  IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
#define  iPhoneX (kScreenW == 375.f && kScreenH == 812.f ? YES : NO)

#define  kStatusBarHeight      [[UIApplication sharedApplication] statusBarFrame].size.height

#define  kNavigationBarHeight  44.f

#define  kTabbarHeight         (iPhoneX ? (49.f+34.f) : 49.f)

#define  kTabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)

#define  kStatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)

#define kViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})


//#import "UIView+Loading.h"
//#import "UIView+Extension.h"
//#import "UIView+PulseView.h"
//#import "UIColor+Image.h"
//#import "UIImage+Radius.h"
//#import "YPNetService.h"


//View圆角和加边框

#define kViewBorderRadius(View,Radius,Width,Color)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View圆角

#define kViewRadius(View,Radius)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]




#endif /* common_h */
