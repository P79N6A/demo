//
//  SPReadConfig.h
//  page
//
//  Created by Jay on 9/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPReadConfig : NSObject<NSCoding>

+(instancetype)defaultConfig;

@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic,assign) CGFloat lineSpace;
@property (nonatomic,strong) UIColor *fontColor;
@property (nonatomic,strong) UIColor *themeColor;
@property (nonatomic,assign) NSInteger themeType;

@property (nonatomic,assign) NSInteger fontType;


+ (NSMutableDictionary *)attributeStyle;
@end
