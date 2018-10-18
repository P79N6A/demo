//
//  UIView+Layout.h
//  podtest
//
//  Created by Jay on 18/10/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LayoutModel : NSObject
/** 相对于谁布局*/
@property (nonatomic, weak) id relativeToView;
/** 相对于那个属性 （上下...）*/
@property (nonatomic, assign) NSLayoutAttribute layoutAtt;

@property (nonatomic, assign) NSLayoutRelation layoutRel;
/** 多少倍*/
@property (nonatomic, assign) CGFloat multiplier;
/** 相差多少*/
@property (nonatomic, assign) CGFloat constant;
@end

@interface UIView (Layout)

- (NSLayoutConstraint *)lyHeight;
- (NSLayoutConstraint *)lyWidth;

- (NSLayoutConstraint *)lyCenterX;
- (NSLayoutConstraint *)lyCenterY;

- (NSLayoutConstraint *)lyRight;
- (NSLayoutConstraint *)lyleft;
- (NSLayoutConstraint *)lyTop;
- (NSLayoutConstraint *)lyButtom;



- (void)setLyHeight:(void (^)(LayoutModel *__autoreleasing * layout))lyHeight;
- (void)setLyWidth:(void (^)(LayoutModel *__autoreleasing *))lyWidth;

- (void)setLyCenterX:(void (^)(LayoutModel *__autoreleasing *))lyCenterX;
- (void)setLyCenterY:(void (^)(LayoutModel *__autoreleasing *))lyCenterY;

- (void)setLyRight:(void (^)(LayoutModel *__autoreleasing *))lyRight;
- (void)setLyleft:(void (^)(LayoutModel *__autoreleasing *))lyleft;
- (void)setLyTop:(void (^)(LayoutModel *__autoreleasing *))lyTop;
- (void)setLyButtom:(void (^)(LayoutModel *__autoreleasing *))lyButtom;



////////////

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGSize size;

@end

NS_ASSUME_NONNULL_END
