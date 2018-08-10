//
//  SPReadView.m
//  page
//
//  Created by Jay on 7/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPReadView.h"
#import "SPTopView.h"
#import "SPButtomView.h"
#import "SPStatusView.h"
#import "SPSettingView.h"
#import "const.h"
#import "SPReadConfig.h"
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
@property (nonatomic, weak)  SPTopView *topView;
@property (nonatomic, weak)  SPButtomView *buttomView;
@property (nonatomic, weak)  UIView *tapView;
@property (nonatomic, weak)  UIButton *coverButton;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, weak)  SPSettingView *settingView;
@property (nonatomic, weak)  SPStatusView *statusView;

@end


@implementation SPReadView


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:({
            UIView *tapView = [[UIView alloc] init];
            _tapView = tapView;
            [tapView addGestureRecognizer:({
                UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolView:)];
                pan;
            })];
            tapView;
        })];
        

        [self addSubview:({
            UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _coverButton = coverBtn;
            [coverBtn addTarget:self action:@selector(showToolView:) forControlEvents:UIControlEventTouchUpInside];
            coverBtn.backgroundColor = [UIColor clearColor];
            coverBtn.hidden = YES;
            coverBtn;
        })];
        
        
        [self addSubview:({
            
            SPStatusView *statusView = [[SPStatusView alloc] initWithFrame:CGRectMake(DZMSpace_1, ScreenHeight - DZMSpace_2, ScreenWidth - 2 * DZMSpace_1, DZMSpace_2)];
            _statusView = statusView;
            statusView;
            
        })];
        
        [self.coverButton addSubview:({
            SPTopView *topView = [[SPTopView alloc] initWithFrame:CGRectMake(0, -kStatusBarAndNavigationBarHeight, kScreenWidth, kStatusBarAndNavigationBarHeight)];
            topView.backgroundColor = [UIColor lightGrayColor];
            _topView = topView;
            topView;
        })];
        
        [self.coverButton addSubview:({
            
            SPSettingView *settingView = [[SPSettingView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, NovelsSettingViewH)];
            _settingView = settingView;
            settingView.backgroundColor = [UIColor lightGrayColor];
            settingView;
        })];

        
        [self.coverButton addSubview:({
            SPButtomView *buttomView = [[SPButtomView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kTabbarSafeBottomMargin + 112)];
            buttomView.backgroundColor = [UIColor lightGrayColor];
            _buttomView = buttomView;
            buttomView.funClick = ^(NSInteger code) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.settingView.transform = CGAffineTransformMakeTranslation(0, -NovelsSettingViewH);
                    
                    self.buttomView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    
                }];
                
            };
            buttomView;
        })];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tapView.frame = CGRectMake(88, 0, self.bounds.size.width - 88 * 2 , self.bounds.size.height);
    self.coverButton.frame = self.bounds;

//    self.batteryView.frame = CGRectMake(self.bounds.size.width - 25.0, 0.5 * (self.bounds.size.height - 10.0), 100, 100);

}

//FIXME:  -  隐藏状态栏
- (void)setStatusBarHidden:(BOOL)statusBarHidden{
    _statusBarHidden = statusBarHidden;
    if(statusBarHidden) [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelStatusBar + 1];
    else [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelStatusBar - 1];
}


- (void)showToolView:(UITapGestureRecognizer *)sender{
    
    if (self.coverButton.isHidden) {
        self.statusBarHidden = NO;
        self.coverButton.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.transform = CGAffineTransformMakeTranslation(0, kStatusBarAndNavigationBarHeight);
            self.buttomView.transform = CGAffineTransformMakeTranslation(0, -(kTabbarSafeBottomMargin+112));

        } completion:^(BOOL finished) {
        }];
    }else{
        self.statusBarHidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.transform = CGAffineTransformIdentity;
            self.buttomView.transform = CGAffineTransformIdentity;
            self.settingView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.coverButton.hidden = YES;
        }];

    }
}



-(void)drawRect:(CGRect)rect{
    
    self.frameRef = [self parserContent:_content];
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
    
    
    
//    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
//    attribute[NSForegroundColorAttributeName] = [UIColor orangeColor];
//    attribute[NSFontAttributeName] = [UIFont systemFontOfSize:14.0];
//
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 10;
//    //paragraphStyle.paragraphSpacing = 10;
//    paragraphStyle.alignment = NSTextAlignmentJustified;
//    paragraphStyle.lineHeightMultiple = 1.0;
//    attribute[NSParagraphStyleAttributeName] = paragraphStyle;

    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content attributes:SPReadConfig.attributeStyle];
    
    NSLog(@"%s-fontSize-%ld", __func__,(long)SPReadConfig.defaultConfig.fontSize);
    NSLog(@"%s-lineSpace-%ld", __func__,(long)SPReadConfig.defaultConfig.lineSpace);
    NSLog(@"%s-fontColor-%@", __func__,(long)SPReadConfig.defaultConfig.fontColor);
    NSLog(@"%s-themeColor-%@", __func__,(long)SPReadConfig.defaultConfig.themeColor);
    NSLog(@"%s-fontType-%ld", __func__,(long)SPReadConfig.defaultConfig.fontType);

    
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    
    //CGPathRef pathRef = CGPathCreateWithRect(self.bounds, NULL);
    CGPathRef pathRef = CGPathCreateWithRect(CGRectMake(LeftSpacing, TopSpacing, self.bounds.size.width - 2 * LeftSpacing, self.bounds.size.height - 2 * TopSpacing), NULL);

    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, NULL);
    CFRelease(setterRef);
    CFRelease(pathRef);
    return frameRef;
    
}


- (void)setContent:(NSString *)content{
    _content = content;
    [self setNeedsDisplay];
}


- (void)setFrameRef:(CTFrameRef)frameRef{
    _frameRef = frameRef;
    //self.backgroundColor = [SPReadConfig defaultConfig].themeColor;
    self.statusView.titleLabel.text = self.progressTitle;
}

@end
