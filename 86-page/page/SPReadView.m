//
//  SPReadView.m
//  page
//
//  Created by Jay on 7/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPReadView.h"
#import "SPTopView.h"
#import <CoreText/CoreText.h>


// iPhone X
#define  iPhoneX (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)
// Status bar height.
#define  kStatusBarHeight      [[UIApplication sharedApplication] statusBarFrame].size.height
// Navigation bar height.
#define  kNavigationBarHeight  44.f
// Tabbar height.
#define  kTabbarHeight         (iPhoneX ? (49.f+34.f) : 49.f)
// Tabbar safe bottom margin.
#define  kTabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)
// Status bar & navigation bar height.
#define  kStatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)
#define  kScreenWidth [UIScreen mainScreen].bounds.size.width
#define  kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface SPReadView ()
@property (nonatomic,assign) CTFrameRef frameRef;
@property (nonatomic, weak) SPTopView *topView;
@property (nonatomic, assign) BOOL statusBarHidden;
@end


@implementation SPReadView


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self addGestureRecognizer:({
            UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolView:)];
            pan;
        })];
        
        [self addSubview:({
            SPTopView *topView = [[SPTopView alloc] initWithFrame:CGRectMake(0, -kStatusBarAndNavigationBarHeight, kScreenWidth, kStatusBarAndNavigationBarHeight)];
            topView.hidden = YES;
            topView.backgroundColor = [UIColor lightGrayColor];
            _topView = topView;
            topView;
        })];
        
    }
    return self;
}

//FIXME:  -  隐藏状态栏
- (void)setStatusBarHidden:(BOOL)statusBarHidden{
    _statusBarHidden = statusBarHidden;
    if(statusBarHidden) [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelStatusBar + 1];
    else [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelStatusBar - 1];
}


- (void)showToolView:(UITapGestureRecognizer *)sender{
    
    if (self.topView.isHidden) {
        self.statusBarHidden = NO;
        self.topView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.transform = CGAffineTransformMakeTranslation(0, kStatusBarAndNavigationBarHeight);
        } completion:^(BOOL finished) {
        }];
    }else{
        self.statusBarHidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.topView.hidden = YES;
        }];

    }
}



-(void)drawRect:(CGRect)rect{
    if (!_frameRef) {
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CTFrameDraw(_frameRef, ctx);
}
- (CTFrameRef)parserContent:(NSString *)content{
    
    
    
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSForegroundColorAttributeName] = [UIColor orangeColor];
    attribute[NSFontAttributeName] = [UIFont systemFontOfSize:14.0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    paragraphStyle.paragraphSpacing = 10;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.lineHeightMultiple = 1.0;
    attribute[NSParagraphStyleAttributeName] = paragraphStyle;

    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content attributes:attribute];

    
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    
    CGPathRef pathRef = CGPathCreateWithRect([UIScreen mainScreen].bounds, NULL);
    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, NULL);
    CFRelease(setterRef);
    CFRelease(pathRef);
    return frameRef;
    
}


- (void)setContent:(NSString *)content{
    _content = content;
    self.frameRef = [self parserContent:content];
}


- (void)setFrameRef:(CTFrameRef)frameRef{
    _frameRef = frameRef;
    [self setNeedsDisplay];
    self.backgroundColor = [UIColor whiteColor];
}

@end
