//
//  TTT.h
//  BackgroundDownloadDemo
//
//  Created by Jay on 19/9/18.
//  Copyright © 2018年 hkhust. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface T : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign)  NSInteger age;
@property (nonatomic, strong)  NSDictionary *dict;
@end

@interface TT : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign)  NSInteger age;
@property (nonatomic, strong)  NSDictionary *dict;
@property (nonatomic, strong)  T *model;
//@property (nonatomic, assign)  NSInteger mid;

@end
@interface TTT : NSObject

@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *title2;

@property (nonatomic, strong) NSArray <TT *>*models;
@property (nonatomic, strong) NSMutableArray <NSString *>*strings;
@property (nonatomic, assign)  CGFloat socre;
@property (nonatomic, assign)  NSInteger mid;

@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) NSMutableDictionary *info1;

@property (nonatomic, strong)  TT *model;

@end

NS_ASSUME_NONNULL_END
