//
//  AdViewController.h
//  AdViewANESDK
//
//  Created by the user on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdViewView.h"

#define AD_POS_CENTER      -1           //center in horizontal or vertical
#define AD_POS_REWIND      -2           //right or bottom

#define IS_VIEWCONTROLLER             0

#if IS_VIEWCONTROLLER
#define CONTROLLER_SUPER_CLASS      UIViewController
#else
#define CONTROLLER_SUPER_CLASS      NSObject
#endif

@protocol AdViewControllerDelegate <NSObject>

@required
- (void)didGotNotify:(NSString*)code Info:(NSString*)content;
@end

@interface AdViewController : CONTROLLER_SUPER_CLASS <AdViewDelegate> {
    AdViewView          *adView_;
    CGFloat             ad_x;         //-1 means center in horizontal
    CGFloat             ad_y;         //-1 means center in vertical
    BOOL                ad_hidden;      //YES for hidden    
    
    BOOL                adTestMode;
    BOOL                adLogMode;
    NSString            *adviewKey;
    int                 nOrientationSupport;
    
    int                 nOrientation;
    
    BOOL                bSuperOrientFix;        //like game, super view is fixed as (320, 480)
}

@property (nonatomic,retain) AdViewView         *adView;
@property (nonatomic,assign) AdviewBannerSize   adBannerSize;
@property (nonatomic,weak) UIViewController   *adRootController;
@property (nonatomic,weak) id<AdViewControllerDelegate> notifyDelegate;

@property (nonatomic,assign) BOOL bSuperOrientFix;

+ (AdViewController*) sharedController;             //单例，存在直接返回，否则新建返回
+ (AdViewController*) sharedControllerIfExists;     //单例，检查是否存在，存在则返回，否则返回nil
+ (void) deleteController;

//以下为允许多个banner条存在，nId必须为[0, 10)之间，其他值直接失败。
+ (AdViewController*) sharedControllerById:(int)nId;             //多个实例之一，存在直接返回，否则新建返回
+ (AdViewController*) sharedControllerIfExistsById:(int)nId;     //多个实例之一，检查是否存在，存在则返回，否则返回nil
+ (void) deleteControllerById:(int)nId;

+ (void)setAllAdProviders:(BOOL)bVal Except:(int)type;

- (void)setAdViewKey:(NSString*)key;
- (void)setModeTest:(BOOL)bTest Log:(BOOL)bLog;

- (void)setAdPosition:(CGPoint)start;           //x = -1, means center in horizontal
//y = -1, means center in vertical

- (CGPoint)getAdPosition;                       //for restore.

- (void)loadView;

- (void)setAdHidden:(BOOL)bHidden;
- (void)setOrientationUp:(BOOL)bUp Down:(BOOL)bDown Left:(BOOL)bLeft Right:(BOOL)bRight;

- (void)addAdView;
- (void)adjustAdSize;

- (void)rollOver;
- (void)requestNewAd;

@end

#ifdef __cplusplus
#define BEGIN_C_LINKAGE extern "C" {
#define END_C_LINKAGE }
#else
#define BEGIN_C_LINKAGE
#define END_C_LINKAGE
#endif

BEGIN_C_LINKAGE
void setAdViewAdVLog(BOOL bLog);
void _AdViewAdVLogInfo(NSString *format, ...);

#define AdVLogInfo _AdViewAdVLogInfo

void doAdViewNotifyApp(NSString *code, NSString *content);       //call to app.
END_C_LINKAGE