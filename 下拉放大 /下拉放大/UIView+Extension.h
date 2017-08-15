//
//  UIView+Extension.h
//  extension
//
//  Created by czljcb on 2017/8/12.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
/** x */
@property (assign, nonatomic) CGFloat x;
/** y */
@property (assign, nonatomic) CGFloat y;
/** width */
@property (assign, nonatomic) CGFloat width;
/** height */
@property (assign, nonatomic) CGFloat height;
/** size */
@property (assign, nonatomic) CGSize size;
/** centerX */
@property (assign, nonatomic) CGFloat centerX;
/** centerY */
@property (assign, nonatomic) CGFloat centerY;


@property (nonatomic, readonly) UIViewController *viewController;


+ (instancetype)viewFromXib;
/**
 Converts a point from the receiver's coordinate system to that of the specified view or window.
 
 @param point A point specified in the local coordinate system (bounds) of the receiver.
 @param view  The view or window into whose coordinate system point is to be converted.
 If view is nil, this method instead converts to window base coordinates.
 @return The point converted to the coordinate system of view.
 */
- (CGPoint)convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view;

/**
 Converts a point from the coordinate system of a given view or window to that of the receiver.
 
 @param point A point specified in the local coordinate system (bounds) of view.
 @param view  The view or window with point in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The point converted to the local coordinate system (bounds) of the receiver.
 */
- (CGPoint)convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view;

/**
 Converts a rectangle from the receiver's coordinate system to that of another view or window.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of the receiver.
 @param view The view or window that is the target of the conversion operation. If view is nil, this method instead converts to window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)convertRect:(CGRect)rect toViewOrWindow:(UIView *)view;

/**
 Converts a rectangle from the coordinate system of another view or window to that of the receiver.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of view.
 @param view The view or window with rect in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view;



@end
