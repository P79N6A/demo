//
//  ZSDK.h
//  UITest
//
//  Created by Wen Yunlong on 14-8-8.
//  Copyright (c) 2014年 YuJie. All rights reserved.
//

#import <Foundation/Foundation.h>

/**********************************************/
/*BANNER的位置，默认是下方                       */
/*BANNER_LOCATION                             */
/**********************************************/

typedef NS_ENUM(NSUInteger, BANNER_LOCATION) {
    BANNER_DEFAULT,
    BANNER_TOP,
    BANNER_BOTTOM
};

#define AD_INSERSCREEN  3   //插播广告
#define AD_FULLSCREEN   4   //全屏广告
#define AD_BANNER       5   //BANNER
#define AD_MEDIA_INSERT 7   //视频插屏

/**********************************************/
/*初始化接口，必须初始化                          */
/*key   :applicationKey                       */
/*value :是否开启定位                           */
/*userid:用户id一般游戏的角色id                  */
/**********************************************/
#define AD_INIT(key, isuse, userid, t) [ZSDK Initialize:key Location:isuse Appuserid:userid type:t];


/*********************************************************************************/
/*显示广告                                                                        */
/*type  : 广告类型  类如 AD_OFFERWALL 、AD_INSERSCREEN                             */
/*vc    : 广告显示的目标VC                                                         */
/*dg    : 代理人 实现一些回调用的 如果用不到 传空就行                                   */
/*tag   : 如果同时植入多种广告，在回调的view是哪个广告，可以通过tag判断，默认tag是type类型  */
/*autoresize    : 控制广告横竖屏自动适配                                             */
/*bl    : banner的显示位置                                                       */
/*********************************************************************************/

#define AD_SHOW_TAG_AUTO(type, view, dg, tag, auto, bl) [ZSDK Show:type On:view Delegate:dg Tag:tag Autoresize:auto BannerLoc:bl];
#define AD_SHOW_AUTO(type, view, dg, auto)  AD_SHOW_TAG_AUTO(type, view, dg, type, auto, BANNER_DEFAULT)
#define AD_SHOW_TAG(type, view, dg, tag)    AD_SHOW_TAG_AUTO(type, view, dg, tag, true, BANNER_DEFAULT)
#define AD_SHOW(type, view, dg)             AD_SHOW_AUTO(type, view, dg, true)

/*********************************************************************************/
/*创建广告                                                                         */
/*type  : 广告类型  类如 AD_OFFERWALL                                               */
/*dg    : 代理人 实现一些回调用的 如果用不到 传空就行                                    */
/*tag   : 如果同时植入多种广告，在回调的view是哪个广告，可以通过tag判断，默认tag是type类型   */
/*autoresize    : 控制广告横竖屏自动适配                                              */
/*bl    : banner的显示位置                                                       */
/**********************************************************************************/

#define AD_CREATE_TAG_AUTO(type, dg, tag, autoresize, bl) [ZSDK Create:type Delegate:dg Tag:tag Autoresize:autoresize BannerLoc:bl];
#define AD_CREATE_TAG(type, dg, tag)    AD_CREATE_TAG_AUTO(type, dg, tag, true, BANNER_DEFAULT)
#define AD_CREATE_AUTO(type, dg, auto)  AD_CREATE_TAG_AUTO(type, dg, type, auto, BANNER_DEFAULT)
#define AD_CREATE(type, dg)             AD_CREATE_AUTO(type, dg, true)


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ZDelegate <NSObject>
@optional

/**
 *  数据列表回调
 *
 *  @param object 回调的对象，如果通过AD_CREATE创建或者广告类型是banner，object就是view。否则object就是viewController
 *  @param code 广告条数大于0，那么code=0，代表成功 反之code = -1
 */
- (void)DidDataReceived:(id)object Code:(int)code;

/**
 *  请求广告列表失败
 *
 *  @param object 回调的对象，如果通过AD_CREATE创建或者广告类型是banner，object就是view。否则object就是viewController
 */
- (void)DidLoadFail:(id)object;

/**
 *  点击广告
 *
 *  @param object 广告详细信息
 */
- (void)DidViewClick:(id)object data:(id)data;

/**
 *  关闭回调
 *
 *  @param object 回调的对象，如果通过AD_CREATE创建或者广告类型是banner，object就是view。否则object就是viewController
 */
- (void)DidViewClose:(id)object;


/**
 *  广告销毁
 *
 *  @param object 回调的对象，如果通过AD_CREATE创建或者广告类型是banner，object就是view。否则object就是viewController
 */
- (void)DidViewDestroy:(id)object;

@end


@interface ZSDK : NSObject<NSURLConnectionDelegate>

+(void)Initialize:(NSString *)key
         Location:(BOOL)value
        Appuserid:(NSString *)appuserid
             type:(NSInteger)type;

+(void)Show:(NSInteger)space
         On:(UIViewController *)vc
   Delegate:(id<ZDelegate>)delegate
        Tag:(int)tag
 Autoresize:(BOOL)value
  BannerLoc:(BANNER_LOCATION)loc;

+(void)Create:(NSInteger)space
     Delegate:(id<ZDelegate>)delegate
          Tag:(int)tag
   Autoresize:(BOOL)value
    BannerLoc:(BANNER_LOCATION)loc;



@end
