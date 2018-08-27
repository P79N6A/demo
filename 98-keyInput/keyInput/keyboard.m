//
//  keyboard.m
//  keyInput
//
//  Created by Jay on 27/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "keyboard.h"

@interface keyboard()

@property (nonatomic, strong)NSMutableString * innerText;

@property (nonatomic, strong)NSMutableArray  *dotsLayers;

@property (nonatomic, strong)NSMutableArray *subTextLayers;

@property (nonatomic, assign)BOOL didLayoutSubview;
@end

@implementation keyboard

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    _innerText = [NSMutableString new];
    _dotsLayers = [NSMutableArray arrayWithCapacity:6];
    _subTextLayers = [NSMutableArray arrayWithCapacity:6];
    _dotRadius = 5.f;
    _dotFillColor = [UIColor blackColor];
    _font = [UIFont systemFontOfSize:14];
    _textColor = [UIColor blackColor];
    _septaLineColor = [UIColor darkGrayColor];
    _septaLineWidth = 1.f;
    _keyboardType = UIKeyboardTypeNumberPad;
    _returnKeyType = UIReturnKeyDone;
    _secureTextEntry = YES;
    _passwordLength = 6;
    _secureTextEntry = YES;
    self.backgroundColor = [UIColor whiteColor];
    
}
- (void)layoutSubviews {
    if (_didLayoutSubview) {
        return;
    }
    [super layoutSubviews];
    CGSize  size = self.bounds.size;
    CGFloat gridWith = size.width*1.0/_passwordLength;
    CAShapeLayer *gridLayer = [CAShapeLayer layer];
    gridLayer.frame = self.bounds;
    gridLayer.strokeColor = _septaLineColor.CGColor;
    gridLayer.lineWidth = _septaLineWidth;
    UIBezierPath *gridPath = [UIBezierPath bezierPath];
    [gridPath moveToPoint:CGPointMake(0, _septaLineWidth/2.0)];
    [gridPath addLineToPoint:CGPointMake(size.width, _septaLineWidth/2.0)];
    [gridPath moveToPoint:CGPointMake(size.width, size.height-_septaLineWidth/2.0)];
    [gridPath addLineToPoint:CGPointMake(0, size.height-_septaLineWidth/2.0)];
    [gridPath moveToPoint:CGPointMake(_septaLineWidth/2.0, _septaLineWidth)];
    [gridPath addLineToPoint:CGPointMake(_septaLineWidth/2.0, size.height-_septaLineWidth)];
    for (int i = 1; i<= _passwordLength; ++i) {
        [gridPath moveToPoint:CGPointMake(gridWith*i-_septaLineWidth/2.0, _septaLineWidth/2)];
        [gridPath addLineToPoint:CGPointMake(gridWith*i-_septaLineWidth/2.0, size.height-_septaLineWidth/2)];
    }
    gridLayer.path = gridPath.CGPath;
    [self.layer addSublayer:gridLayer];
    _didLayoutSubview = YES;
}
/**
 *  生成小黑点
 *
 *  @param index 第几个
 *
 *  @return 当前小黑点
 */
- (CAShapeLayer *)makeBlackDotLayerAtIndex:(NSUInteger)index {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = _dotFillColor.CGColor;
    CGSize  size = self.bounds.size;
    CGFloat gridWith = size.width*1.0/_passwordLength;
    layer.path = [self circlePathWithCenter:CGPointMake(gridWith*0+gridWith/2.0, size.height/2.0)].CGPath;
    return layer;
}

/**
 *  生成text 文本 注意 这种方式不适成大量文本
 *
 *  @param index 第几个
 *
 *  @return 当前文本
 */
- (CATextLayer *)makeTextLayerAtIndex:(NSUInteger)index {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.wrapped = YES;
    textLayer.string = [_innerText substringWithRange:NSMakeRange(index, 1)];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef fontName = (__bridge CFStringRef)_font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = _font.pointSize;
    textLayer.foregroundColor = _textColor.CGColor;
    CGFontRelease(fontRef);
    
    return textLayer;
}

/**
 *  计算实心小圆点
 *
 *  @param center 圆心
 *
 *  @return 圆的路径
 */
- (UIBezierPath *)circlePathWithCenter:(CGPoint)center{
    return [UIBezierPath bezierPathWithArcCenter:center radius:_dotRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
}


- (NSString *)text {
    return [_innerText copy];
}


//- (void)setSeptaLineWidth:(CGFloat)septaLineWidth {
//    _septaLineWidth = septaLineWidth;
//    [self.layer setNeedsDisplay];
//}



#pragma mark -
#pragma mark Respond to touch and become first responder.

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark -
#pragma mark UIKeyInput Protocol Methods
- (BOOL)hasText {
    return (self.innerText.length >0);
}

- (void)insertText:(NSString *)theText {
    if (_innerText.length == _passwordLength) {
        return;
    }
    [self.innerText appendString:theText];
    [self addBlackDotOrTextAtIndex:_innerText.length-1];
}
/**
 *  添加小圆点或文本到相应的框内
 *
 *  @param index 位置
 */
- (void)addBlackDotOrTextAtIndex:(NSUInteger)index {
    if (_secureTextEntry) {
        CAShapeLayer *layer = [self makeBlackDotLayerAtIndex:index];
        CGSize  size = self.bounds.size;
        CGFloat gridWith = size.width*1.0/_passwordLength;
        layer.frame = CGRectMake(gridWith*index, 0, gridWith, size.height);
        [self.layer addSublayer:layer];
        [_dotsLayers addObject:layer];
    }else{
        CATextLayer *layer = [self makeTextLayerAtIndex:index];
        CGSize  size = self.bounds.size;
        CGFloat gridWith = size.width*1.0/_passwordLength;
        layer.frame = CGRectMake(gridWith*index, (size.height-_font.pointSize-2)/2.0, gridWith,_font.pointSize+2);
        [self.layer addSublayer:layer];
        [_subTextLayers addObject:layer];
    }
    
}
/**
 *  删除文本
 */
- (void)deleteText {
    if (_secureTextEntry) {
        CAShapeLayer *layer = [_dotsLayers lastObject];
        [layer removeFromSuperlayer];
        [_dotsLayers removeLastObject];
    }else{
        CATextLayer *layer = [_subTextLayers lastObject];
        [layer removeFromSuperlayer];
        [_subTextLayers removeLastObject];
    }
}


- (void)deleteBackward {
    if (_innerText.length == 0) {
        return;
    }
    [_innerText deleteCharactersInRange:NSMakeRange(_innerText.length-1, 1)];
    [self deleteText];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self becomeFirstResponder];
}

- (BOOL)isSecureTextEntry {
    return _secureTextEntry;
}

@end
