//
//  HCTools.h
//  zhonghaijinchao
//
//  Created by 川何 on 16/8/16.
//  Copyright © 2016年 WLJF. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^actionHandler)(UIAlertAction *action, NSUInteger index);
typedef void(^textFieldHandler)(UITextField *textField, NSUInteger index);
typedef void(^actionText)(UIAlertAction *action,NSString *text, NSUInteger index);

@interface HCTools : NSObject
@property(nonatomic,copy) NSString *textString;

+(instancetype) newTools;
- (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
       textFieldNumber:(NSUInteger)textFieldNumber
          actionNumber:(NSUInteger)actionNumber
          actionTitles:(NSArray *)actionTitle
      textFieldHandler:(textFieldHandler)textFieldHandler
         actionHandler:(actionText)actionText;
//字符串json类型的转换成array
+(NSArray *)stringToJSONarray:(NSString *)jsonStr;
//限制英文字符为最小尾数到最大位数
+(BOOL) limitEnglishWithStr:(NSString*)str Max:(int)max Min:(int)min ;
//验证座机号
+(BOOL)validateLocalPhoneNumber:(NSString *)localphone;
//验证手机号
+ (BOOL) validatePhoneNumber: (NSString *)phoneNumber;
//验证身份证
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//验证邮编
+ (BOOL) validatePostCode: (NSString *)postCode;
//验证电子邮箱
+ (BOOL) validateEamilAddrr: (NSString *)email;
//限制数字整数位,小数位位数 dicimal:小数
+(NSString*) limitNumberWithStr:(NSString*)str Round:(int)round Dicimal:(int)dicimal;
//json str 转换成array
+ (NSArray *)jsonStringToArray:(NSString *)jsonStr;
//合并pdf
+ (NSString *)joinPDF:(NSArray *)listOfPaths;
//密码
+(BOOL)validatePasswordString:(NSString *)password;

//rect 坐标系转化

+ (CGRect) fromRect:(CGRect)fromrect To:(CGRect)torect;

+(NSString *)stringFromTimeStemp:(double)longtime;

+ (void)callAction:(NSString*)number;

//数组类型safe guard
+(NSArray*)jsonorarrayGaurd:(id)item;


+(void)setoldtext:(NSString *)str;
+(UIView*)lineviewWithHeight:(CGFloat)height Width:(CGFloat)width Color:(UIColor *)color;

+(UIButton*)buttonNormalWithFrame:(CGRect)frame title:(NSString*)title titleColor:(UIColor*)titlecolor titleFount:(UIFont*)titlefont backgroundColor:(UIColor*)bccolor corner:(CGFloat)corner;
+(UIButton*)buttonEnableWithFrame:(CGRect)frame title:(NSString*)title titleFount:(UIFont*)titlefont disTitle:(NSString*)distitle titleColor:(UIColor*)titlecolor distitleColor:(UIColor*)distitlecolor backgroundColor:(UIColor*)bccolor disBcColor:(UIColor*)disbccolor corner:(CGFloat)corner;
+(UILabel*)labelWithFrame:(CGRect)frame textAlignment:(NSTextAlignment)alignment titleColor:(UIColor *)color title:(NSString*)title titlefont:(NSNumber*)fontnum  ;

+(UIButton*)buttonSelectFrame:(CGRect)frame titlenormalColor:(UIColor*)norColor titleselColor:(UIColor*)selColor boardColor:(UIColor*)boardcolor boardWith:(CGFloat)boardwith normalBackgroundColor:(UIColor*)normalBColor selBackgroundColor:(UIColor*)selBColor titleFont:(UIFont *)titlefont corner:(CGFloat)corner title:(NSString*)title selTitle:(NSString*)seltitle;
+(UIButton*)buttonNormalEasyFrame:(CGRect)frame titleColor:(UIColor*)titlecolor titleFountFloat:(CGFloat)fontFloat backgroundColor:(UIColor*)bccolor corner:(CGFloat)corner  title:(NSString*)title ;


/**
 *  按钮--中间
 *
 *  @param title            提示标题
 *  @param message          提示信息
 *  @param textFieldNumber  输入框个数
 *  @param actionNumber     按钮个数
 *  @param actionTitle      按钮标题，数组
 *  @param textFieldHandler 输入框响应事件
 *  @param actionHandler    按钮响应事件
 */
+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
       textFieldNumber:(NSUInteger)textFieldNumber
          actionNumber:(NSUInteger)actionNumber
          actionTitles:(NSArray *)actionTitle
      textFieldHandler:(textFieldHandler)textFieldHandler
         actionHandler:(actionHandler)actionHandler;

/**
 *  按钮--底部
 *
 *  @param title            提示标题
 *  @param message          提示信息
 *  @param actionNumber     按钮个数
 *  @param actionTitle      按钮标题，数组
 *  @param actionHandler    按钮响应事件
 */
+ (void)actionSheettWithTitle:(NSString *)title
                      message:(NSString *)message
                 actionNumber:(NSUInteger)actionNumber
                 actionTitles:(NSArray *)actionTitle
                actionHandler:(actionHandler)actionHandler;


+(CGSize)labeSizeWithString:(NSString*)string Font:(CGFloat)font;
+ (float) heightForString:(NSString *)value andWidth:(float)width;
+ (float) heightForString:(NSString *)value andWidth:(float)width font:(float)font;
+(NSString *)changeFloat:(NSString *)stringFloat;

+ (void)nslogPropertyWithDic:(id)obj;
//不进行四舍五入
//需要传入一个数字的字符串,由于系统使用的是科学计数法,所以可以适当的吧转字符串弄得长一些也没有关系
+(NSString*)makestr:(NSString*)amount Point:(int)point;
//下面这个方法不是很好用,容易出现一些问题
+(NSString *)notRounding:(double)price afterPoint:(int)position;

+(void)showAlertError:(NSString *)errorMsg;
+(NSString *)notRoundingStr:(NSString*)price afterPoint:(int)position;

+(NSString*)hideEmail:(NSString*)email;

+(NSString*)hideString:(NSString*)hideString;

@end
     
