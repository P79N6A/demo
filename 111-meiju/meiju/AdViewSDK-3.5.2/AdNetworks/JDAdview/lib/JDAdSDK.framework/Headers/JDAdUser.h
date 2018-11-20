//
//  JDAdUser.h
//  JDAdSDKDemo
//
//  Created by Ben Miao on 15/11/7.
//  Copyright © 2015年 com.jd.dm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDAdConfigration.h"
/**
 *  keywords:
        用户关键字，体现用户所感兴趣的领域，如游泳，唱歌等
    yob:
        设置用户出生年，如1990
    gender:
        男:JDAdGenderMale 女:JDAdGenderFemale
    segments：
        若贵司有用户segments,且希望使用，请私下联系。
 */

@interface JDAdUser : NSObject

@property(nonatomic,assign) JDAdDefineGender gender;
@property(nonatomic,copy) NSString* yob;

@property(nonatomic,strong) NSString* keywords;
@property(nonatomic,strong) NSString* segments;

- (instancetype) initJDAdUserWithGender:(JDAdDefineGender) gender
                                    yob:(NSString*) yob
                               keywords:(NSString*) keywords
                               segments:(NSString*) segments;

@end
