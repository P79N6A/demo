//
//  JDNativeAd.h
//  JDAdSDKDemo
//
//  Created by Ben Miao on 15/11/11.
//  Copyright © 2015年 com.jd.dm. All rights reserved.
//

#import "JDAd.h"
#import <CoreGraphics/CGGeometry.h>

@interface JDNativeAd : JDAd

@property(nonatomic,assign) NSInteger counts;

@property(nonatomic,assign) JDAdNativeType nativeType;

@property(nonatomic,copy) NSArray *contents;

@property(nonatomic,assign) CGSize adSize;

@property (nonatomic,copy) NSArray* filter;

@end
