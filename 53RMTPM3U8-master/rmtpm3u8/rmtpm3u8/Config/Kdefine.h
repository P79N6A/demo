//
//  Kdefine.h
//  Coin3658
//
//  Created by 川何 on 2017/6/27.
//  Copyright © 2017年 hechuan. All rights reserved.
//
/*

 */
#ifndef Kdefine_h
#define Kdefine_h

#define kLtc @"ltc_cny"
#define kBtc @"btc_cny"
#define kEth @"eth_cny"
#define kDepth @"api/v1/depth.do"
#define kTrades @"api/v1/trades.do"
#define kKline @"api/v1/kline.do"


#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define Scale  kScreenW/375.0 //不考虑4s 高度上是几乎合理的
//iPhone X 特殊顶部高度处理
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height   //普通的是20 iPhone X 是40
#define kNavBarHeight 44.0
#define kBottomBarHeight 49.0
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define kNavH (kStatusBarHeight + kNavBarHeight)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define KeyWindow ((AppDelegate*)([UIApplication sharedApplication].delegate)).window


#define kBlackDark [UIColor jk_colorWithHex:0x26363d]
#define kBlackLight [UIColor jk_colorWithHex:0x8b9ea6]

///api/v1/kline.do
#define kBlaBlu [UIColor jk_colorWithHex:0x005d88]
#define kBlue [UIColor jk_colorWithHex:0x0096dc]
#define kred [UIColor jk_colorWithHex:0xe42b00]
#define kcece [UIColor jk_colorWithHex:0xcecece]
#define kyellow [UIColor jk_colorWithHex:0xff9600]
//#define kyellow [UIColor jk_colorWithHex:0x0096dc]
#define kgreen [UIColor jk_colorWithHex:0x00ca98]
#define kgreenS [UIColor jk_colorWithHex:0x00e4ac]
#define kwhite [UIColor whiteColor]
#define kbackground [UIColor jk_colorWithHex:0xf3f3f3]
#define k333 [UIColor jk_colorWithHex:0x333333]
#define k999 [UIColor jk_colorWithHex:0x999999]
#define k666 [UIColor jk_colorWithHex:0x666666]

#define kcolorgb(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]

#define kLocal(key)\
NSLocalizedString(key, nil)

#define kError(error)\
[SVProgressHUD showErrorWithStatus:error.userInfo[@"errMsg"]];\
[SVProgressHUD  setMinimumDismissTimeInterval:1.5];

#define kSuccess(string)\
[SVProgressHUD showSuccessWithStatus:string];\
[SVProgressHUD setMinimumDismissTimeInterval:1.8];

//圆角
#define kRViewBorderRadiusAndCorlor(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

#define kRViewBorderRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\

#define KremoveNotificationCenterObserverDealloc - (void)dealloc{ [[NSNotificationCenter defaultCenter] removeObserver:self];  NSLog(@"死亡dealloc:%@",[[self class] description]);}
//打印
#ifdef DEBUG
#define kLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define kLog(...)
#endif


//GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlock);


#define kRootViewController [UIApplication sharedApplication].keyWindow.rootViewController

#endif /* Kdefine_h */
