//
//  JDAdDeviceInfo.h
//  JDAdSDKDemo
//
//  Created by Ben Miao on 15/11/7.
//  Copyright © 2015年 com.jd.dm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
@interface JDAdDeviceInfo : NSObject

@property(nonatomic,copy) NSString* ifa;  //idfa
@property(nonatomic,copy) NSString* osv;  //iOS系统版本
@property(nonatomic,copy) NSString* os;   //iOS
@property(nonatomic,copy) NSString* carrier;  //运营商
@property(nonatomic,copy) NSString* ua;  //user agent
@property(nonatomic,copy) NSString* ip;  //ip
@property(nonatomic,copy) NSString* model;  //机型
@property(nonatomic,assign) NSInteger w;  //屏幕宽度
@property(nonatomic,assign) NSInteger h;  //屏幕高度

+ (instancetype)device;

@end
