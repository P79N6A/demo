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


// MARK: -- 颜色支持
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

/// 灰色
#define DZMColor_1 RGB(51, g: 51, b: 51)


/// 粉红色
#define DZMColor_2 RGB(253, g: 85, b: 103)

/// 阅读上下状态栏颜色
#define DZMColor_3 RGB(127, g: 136, b: 138)

/// 小说阅读上下状态栏字体颜色
#define DZMColor_4 RGB(127, g: 136, b: 138)

/// 小说阅读颜色
#define DZMColor_5RGB(145, g: 145, b: 145)

/// LeftView文字颜色
#define DZMColor_6 RGB(200, g: 200, b: 200)


/// 阅读背景颜色支持
#define DZMReadBGColor_1 RGB(238, g: 224, b: 202)
#define DZMReadBGColor_2 RGB(205, g: 239, b: 205)
#define DZMReadBGColor_3 RGB(206, g: 233, b: 241)
#define DZMReadBGColor_4 RGB(251, g: 237, b: 199)  // 牛皮黄
#define DZMReadBGColor_5 RGB(51, g: 51, b: 51)

/// 菜单背景颜色
#define DZMMenuUIColor  [[UIColor blackColor] colorWithAlphaComponent:0.85]

// MARK: -- 字体支持
let DZMFont_10:UIFont = UIFont.systemFont(ofSize: 10)
let DZMFont_12:UIFont = UIFont.systemFont(ofSize: 12)
let DZMFont_18:UIFont = UIFont.systemFont(ofSize: 18)


// MARK: -- 间距支持
#define DZMSpace_1 15
#define DZMSpace_2:CGFloat = 25
#define DZMSpace_3:CGFloat = 1
#define DZMSpace_4:CGFloat = 10
#define DZMSpace_5:CGFloat = 20
#define DZMSpace_6:CGFloat = 5

// MARK: 拖拽触发光标范围
let DZMCursorOffset:CGFloat = -20


// MARK: -- Key

/// 是夜间还是日间模式   true:夜间 false:日间
let DZMKey_IsNighOrtDay:String = "isNightOrDay"

/// ReadView 手势开启状态
let DZMKey_ReadView_Ges_isOpen:String = "isOpen"

// MARK: 通知名称

/// ReadView 手势通知
let DZMNotificationName_ReadView_Ges = "ReadView_Ges"



#endif /* const_h */
