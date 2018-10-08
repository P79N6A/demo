//
//  const.h
//  page
//
//  Created by Jay on 8/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#ifndef const_h
#define const_h



// MARK: -- 屏幕属性


#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define  isX (ScreenWidth == 375.f && ScreenHeight == 812.f ? YES : NO)

#define  NavgationBarHeight (isX? 88 : 64)

#define  TabBarHeight 49


#define  StatusBarHeight (isX? 44 : 20)


// iPhone X
#define  iPhoneX (kStatusBarHeight>20 ? YES : NO)
// Status bar height.
#define  kStatusBarHeight      [[UIApplication sharedApplication] statusBarFrame].size.height
// Navigation bar height.
#define  kNavigationBarHeight  44.f
// Tabbar height.
#define  kTabbarHeight         (iPhoneX ? (49.f+34.f) : 49.f)
// Tabbar safe bottom margin.
#define  kTabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)
#define  kNavigationBarSafeTopMargin         (iPhoneX ? 44.f : 0.f)

// Status bar & navigation bar height.
#define  kStatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)
#define  kScreenWidth [UIScreen mainScreen].bounds.size.width
#define  kScreenHeight [UIScreen mainScreen].bounds.size.height



// MARK: -- 颜色支持
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

/// 灰色
#define DZMColor_1 RGB(51,51,51)


/// 粉红色
#define DZMColor_2 RGB(253,85,103)

/// 阅读上下状态栏颜色
#define DZMColor_3 RGB(127,136,138)

/// 小说阅读上下状态栏字体颜色
#define DZMColor_4 RGB(127,136,138)

/// 小说阅读颜色
#define DZMColor_5 RGB(145,145,145)

/// LeftView文字颜色
#define DZMColor_6 RGB(200,200,200)


/// 阅读背景颜色支持
#define DZMReadBGColor_1 RGB(238,224,202)
#define DZMReadBGColor_2 RGB(205,239,205)
#define DZMReadBGColor_3 RGB(206,233,241)
#define DZMReadBGColor_4 RGB(251,237,199)  // 牛皮黄
#define DZMReadBGColor_5 RGB(51,51,51)

/// 菜单背景颜色
#define DZMMenuUIColor  [[UIColor blackColor] colorWithAlphaComponent:0.85]

// MARK: -- 字体支持
#define DZMFont_10  [UIFont systemFontOfSize:10]
#define DZMFont_12  [UIFont systemFontOfSize:12]
#define DZMFont_18  [UIFont systemFontOfSize:18]


// MARK: -- 间距支持
#define DZMSpace_1 15
#define DZMSpace_2 25
#define DZMSpace_3  1
#define DZMSpace_4 10
#define DZMSpace_5 20
#define DZMSpace_6 5

// MARK: 拖拽触发光标范围
#define DZMCursorOffset  -20


/// 阅读最小阅读字体大小
#define DZMReadMinFontSize  12

/// 阅读最大阅读字体大小
#define DZMReadMaxFontSize  25


#define DZReaderContentFrame (CGRectMake(DZMSpace_1, DZMSpace_2+kNavigationBarSafeTopMargin, ScreenWidth - 2 * DZMSpace_1, ScreenHeight - 2 * DZMSpace_2 - kTabbarSafeBottomMargin - kNavigationBarSafeTopMargin))

#define NovelsSettingViewH  (isX ? 250 : 218)


#define DZMSizeW(w) ((w) * (ScreenWidth / 375))
#define DZMSizeH(h) ((h) * (ScreenWidth / 667))

#define TopSpacing 40.0f
#define BottomSpacing 40.0f
#define LeftSpacing 20.0f
#define RightSpacing  20.0f

#define lightButtonWH 84.f
// MARK: -- Key

/// 是夜间还是日间模式   true:夜间 false:日间
#define DZMKey_IsNighOrtDay @"isNightOrDay"

/// ReadView 手势开启状态
#define DZMKey_ReadView_Ges_isOpen  @"isOpen"

// MARK: 通知名称

/// ReadView 手势通知
#define DZMNotificationName_ReadView_Ges  @"ReadView_Ges"

#define DZMNotificationNameProgressValueChange  @"DZMNotificationNameProgressValueChange"
#define DZMNotificationNameFontSizeChange  @"DZMNotificationNameFontSizeChange"
#define DZMNotificationNameThemeColorChange  @"DZMNotificationNameThemeColorChange"
#define DZMNotificationNameFontChange  @"DZMNotificationNameFontChange"
#define DZMNotificationNamePageWillScroll  @"DZMNotificationNamePageWillScroll"

#define DZMNotificationNameChapterChange  @"DZMNotificationNameChapterChange"


#endif /* const_h */
