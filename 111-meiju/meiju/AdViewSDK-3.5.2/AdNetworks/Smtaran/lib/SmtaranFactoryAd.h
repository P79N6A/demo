//
//  SmtaranAdFactory.h
//
//
//  Created by fwang.work on 14/7/16.
//  Copyright (c) 2014年 fwang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SmtaranAdFactoryCompletionCallBack)(NSArray* adViews);

@class SmtaranFactoryAd;

@protocol SmtaranAdFactoryDelegate<NSObject>

/**
 *  adFactory请求成功
 *  @param adNative
 */
-(void)smtaranAdFactorySuccessToRequest:(SmtaranFactoryAd*) adFactory;

/**
 *  adFactory请求失败
 *  @param adFactory
 */
-(void)smtaranAdFactoryFaildToRequest:(SmtaranFactoryAd*) adFactory withError:(NSError*) error;

@end

@interface SmtaranFactoryAd : UIView

/**
 *  SmtaranAdFactoryDelegate
 *  @param delegate
 */
@property (nonatomic, assign) id<SmtaranAdFactoryDelegate> delegate;

/**
 *  请求adNative广告数量,最多10个
 *  @param capacity
 */
@property (nonatomic, assign) NSInteger capacity;

/**
 *  广告模板类型(@"classic", @"image", @"simple1", @"simple2")
 *  @param style
 */
@property (nonatomic, strong) NSString *style;

/**
 * 轮播时间
 * 广告模板类型,选择simple1轮播模板的轮播时间
 * @param adViews
 */
@property (nonatomic, assign) NSInteger intervaltime;

/**
 *  包含native对象的数组
 *  @param adViews
 */
@property (nonatomic, readonly) NSArray *adViews;

/**
 *  高级可选控制项
 * (disableClickPic:YES 设置广告图片不能点击)
 * @param adViews
 */
@property (nonatomic,strong)  NSMutableDictionary* options;

/**
 *  请求广告组资源.
 *  @param width 期望广告view的宽度.我们会根据width,等比缩放广告view,并返回给你height
 *  @param slotToken 广告位
 *  @param completion
 */
-(void) requestWithWidth:(CGFloat) width
               slotToken:(NSString *)slotToken
              completion:(SmtaranAdFactoryCompletionCallBack)completion;

/**
 *  请求广告组资源.
 *  @param height=期望广告view的宽度.我们会根据height,等比缩放广告view,并返回给你width
 *  @param slotToken 广告位
 *  @param completion
 */
-(void) requestWithHeight:(CGFloat) height
                slotToken:(NSString *)slotToken
               completion:(SmtaranAdFactoryCompletionCallBack)completion;

/**
 *  请求广告组资源.
 *  @param size=期望广告view的size.我们会自适应填充广告内容.宽高比在0.5-2之间为有效size
 *  @param slotToken 广告位
 *  @param completion
 */
-(void) requestWithSize:(CGSize) size
              slotToken:(NSString *)slotToken
             completion:(SmtaranAdFactoryCompletionCallBack)completion;

/**
 *  设置请求广告的分类.
 *  @param tag 分类名称以英文","为分割符
 *  @param inverse inverse=NO,表示请求分类中的广告;inverse=YES,表示剔除分类中的广告
 */
-(void) setAdTag:(NSString*) tag inverse:(BOOL) inverse;

/**
 *  customtag的内容详见说明文档
 *  @param tag
 */
-(void) setCustomTag:(NSDictionary*) tag;

@end




