//
//  UIView+Layout.m
//  podtest
//
//  Created by Jay on 18/10/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "UIView+Layout.h"
#import <objc/runtime.h>

@implementation LayoutModel
{
     BOOL _relativeToViewBak;
}
@synthesize relativeToView  = _relativeToView;
- (void)setRelativeToView:(id)relativeToView{
    _relativeToViewBak = YES;
    _relativeToView = relativeToView;
}
- (id)relativeToView{
    if (_relativeToViewBak) {
        return _relativeToView;
    }
    
    return [NSNull null];
}

@end
@implementation NSLayoutConstraint (Layout)

- (void)remove{
    UIView *Self = self.firstItem;
    if([Self isKindOfClass:[UIView class]]) [Self.superview removeConstraint:self];
}
@end
@implementation UIView (Layout)



- (NSLayoutConstraint *)lyHeight{
    return objc_getAssociatedObject(self, @"lyHeight");
}

- (void)setLyHeight:(void (^)(LayoutModel * layout))lyHeight{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    LayoutModel *model = [LayoutModel new];
    !(lyHeight)? : lyHeight(model);
    
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        //model.relativeToView = self.superview;
        model.relativeToView = nil;
    }
    
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeHeight;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }
    

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:model.relativeToView
                                 attribute:model.layoutAtt
                                multiplier:model.multiplier
                                constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyHeight", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSLayoutConstraint *)lyWidth{
    return objc_getAssociatedObject(self, @"lyWidth");
}
- (void)setLyWidth:(void (^)(LayoutModel *))lyWidth{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    LayoutModel *model = [LayoutModel new];
    !(lyWidth)? : lyWidth(model);
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        //model.relativeToView = self.superview;
        model.relativeToView = nil;
    }
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeWidth;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:model.relativeToView
                                 attribute:model.layoutAtt
                                multiplier:model.multiplier
                                  constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyWidth", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)lyCenterX{
    return objc_getAssociatedObject(self, @"lyCenterX");
}
- (void)setLyCenterX:(void (^)(LayoutModel *))lyCenterX{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    LayoutModel *model = [LayoutModel new];
    !(lyCenterX)? : lyCenterX(model);
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        model.relativeToView = self.superview;
    }
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeCenterX;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:model.relativeToView
                                                              attribute:model.layoutAtt
                                                             multiplier:model.multiplier
                                                               constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyCenterX", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSLayoutConstraint *)lyCenterY{
    return objc_getAssociatedObject(self, @"lyCenterY");
}
- (void)setLyCenterY:(void (^)(LayoutModel  *))lyCenterY{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    LayoutModel *model = [LayoutModel new];
    !(lyCenterY)? : lyCenterY(model);
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        model.relativeToView = self.superview;
    }
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeCenterY;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:model.relativeToView
                                                              attribute:model.layoutAtt
                                                             multiplier:model.multiplier
                                                               constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyCenterY", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)lyTop{
    return objc_getAssociatedObject(self, @"lyTop");
}

- (void)setLyTop:(void (^)(LayoutModel *))lyTop{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    LayoutModel *model = [LayoutModel new];
    !(lyTop)? : lyTop(model);
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        model.relativeToView = self.superview;
    }
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeTop;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:model.relativeToView
                                                              attribute:model.layoutAtt
                                                             multiplier:model.multiplier
                                                               constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyTop", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)lyleft{
    return objc_getAssociatedObject(self, @"lyleft");
}
-(void)setLyleft:(void (^)(LayoutModel *))lyleft{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    LayoutModel *model = [LayoutModel new];
    !(lyleft)? : lyleft(model);
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        model.relativeToView = self.superview;
    }
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeLeft;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:model.relativeToView
                                                              attribute:model.layoutAtt
                                                             multiplier:model.multiplier
                                                               constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyleft", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSLayoutConstraint *)lyRight{
    return objc_getAssociatedObject(self, @"lyRight");
}
- (void)setLyRight:(void (^)(LayoutModel *))lyRight{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    LayoutModel *model = [LayoutModel new];
    !(lyRight)? : lyRight(model);
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        model.relativeToView = self.superview;
    }
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeRight;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:model.relativeToView
                                                              attribute:model.layoutAtt
                                                             multiplier:model.multiplier
                                                               constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyRight", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSLayoutConstraint *)lyButtom{
    return objc_getAssociatedObject(self, @"lyButtom");
}
- (void)setLyButtom:(void (^)(LayoutModel *))lyButtom{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    LayoutModel *model = [LayoutModel new];
    !(lyButtom)? : lyButtom(model);
    if ([model.relativeToView isKindOfClass:[NSNull class]] ) {
        model.relativeToView = self.superview;
    }
    if(model.relativeToView && model.layoutAtt == NSLayoutAttributeNotAnAttribute){
        model.layoutAtt = NSLayoutAttributeBottom;
    }
    if(model.relativeToView && model.multiplier == 0){
        model.multiplier = 1.0;
    }

    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:model.relativeToView
                                                              attribute:model.layoutAtt
                                                             multiplier:model.multiplier
                                                               constant:model.constant];
    [self.superview addConstraint:layout];
    objc_setAssociatedObject(self, @"lyButtom", layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


////////////////////
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    
    frame.origin.x = x;
    
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    
    frame.origin.y = y;
    
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    
    center.x = centerX;
    
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    
    center.y = centerY;
    
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    
    frame.size.width = width;
    
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    
    frame.size.height = height;
    
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    
    frame.size = size;
    
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    
    frame.origin = origin;
    
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setMaxX:(CGFloat)maxX{
    CGRect frame = self.frame;
    
    frame.origin.x = maxX - frame.size.width;
    
    self.frame = frame;
}

- (CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxY:(CGFloat)maxY{
    
    CGRect frame = self.frame;
    
    frame.origin.y = maxY - frame.size.height;
    
    self.frame = frame;
}

- (CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}
@end
