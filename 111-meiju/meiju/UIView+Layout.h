//
//  UIView+Layout.h
//  podtest
//
//  Created by Jay on 18/10/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


//view1.att1 =（以等号举栗子，layoutRel可> < ≥≤）relativeToView.layoutAtt * multiplier + constant;

@interface LayoutModel : NSObject
/** 相对于谁布局 (除了hight/width（默认是nil） 外默认是父控件)*/
@property (nonatomic, weak) id relativeToView;
/** 相对于那个属性 （上下...）*/
@property (nonatomic, assign) NSLayoutAttribute layoutAtt;

@property (nonatomic, assign) NSLayoutRelation layoutRel;
/** 多少倍*/
@property (nonatomic, assign) CGFloat multiplier;
/** 相差多少*/
@property (nonatomic, assign) CGFloat constant;
@end

@interface NSLayoutConstraint (Layout)
- (void)remove;
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



- (void)setLyHeight:(void (^__nullable)(LayoutModel *layout))lyHeight;
- (void)setLyWidth:(void (^__nullable)(LayoutModel  *layout))lyWidth;

- (void)setLyCenterX:(void (^__nullable)(LayoutModel  *layout))lyCenterX;
- (void)setLyCenterY:(void (^__nullable)(LayoutModel  *layout))lyCenterY;

- (void)setLyRight:(void (^__nullable)(LayoutModel  *layout))lyRight;
- (void)setLyleft:(void (^__nullable)(LayoutModel  *layout))lyleft;
- (void)setLyTop:(void (^__nullable)(LayoutModel  *layout))lyTop;
- (void)setLyButtom:(void (^__nullable)(LayoutModel  *layout))lyButtom;



////////////

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGSize size;


@property (assign, nonatomic) CGFloat maxX;

@property (assign, nonatomic) CGFloat maxY;

@end

NS_ASSUME_NONNULL_END
