//
//  JDAdAppInfo.h
//  JDAdSDKDemo
//
//  Created by Ben Miao on 15/11/7.
//  Copyright © 2015年 com.jd.dm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDAdAppInfo : NSObject
/**
    若是添加了keywords和cat内容，推荐将会更精确
    keywords：
        应用特征关键字，体现APP所属板块或领域特征，如新闻，军事等
    cat:
        该字段映射您的应用的分类，因为不同的应用对相同的内容会有自己不同的分类体系， 例如：A应用用tag=10010代表‘经济’，而京东对‘经
        济’的分类有‘手机，钟表，奢侈品等’，对应了不同的tagid（如21001,21002,21003等），为了可以为您投放更精准的广告，给您带的利益最
        大化，所以才需要和您下沟通，关联映射您的tagid。
 */
@property(nonatomic,copy) NSString* cat;
@property(nonatomic,copy) NSString* keywords;
@property(nonatomic,copy) NSString* context;

@end
