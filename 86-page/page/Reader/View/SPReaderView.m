//
//  SPReaderView.m
//  page
//
//  Created by xin on 2018/10/6.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPReaderView.h"

#import "SPReadView.h"
#import "SPTopView.h"
#import "SPButtomView.h"

#import "SPSettingView.h"
#import "SPStatusView.h"
#import "SPHaloButton.h"

#import "DZMMagnifierView/DZMMagnifierView.h"

#import "const.h"
#import "SPReadConfig.h"



@interface SPReaderView()

@property (nonatomic, strong) UIWindow *lightView;

@property (nonatomic, weak)  SPReadView *readView;

@property (nonatomic, weak)  SPTopView *topView;
@property (nonatomic, weak)  SPButtomView *buttomView;
@property (nonatomic, weak)  UIView *tapView;
@property (nonatomic, weak)  UIView *coverButton;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, weak)  SPSettingView *settingView;
@property (nonatomic, weak)  SPStatusView *statusView;
@property (nonatomic, weak) SPHaloButton *lightButton;

@property (nonatomic, strong) DZMMagnifierView *magnifierView;
@end

@implementation SPReaderView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 内容View
        [self addSubview:({
            SPReadView *readView = [[SPReadView alloc] initWithFrame:DZReaderContentFrame];
            _readView = readView;
            readView.backgroundColor = [UIColor clearColor];
            [readView addGestureRecognizer:({
                UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
                longGes;
            })];
            readView;
        })];
        
        //触控区域
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
            UIView *coverBtn = [[UIView alloc] init];
            _coverButton = coverBtn;
            [coverBtn addGestureRecognizer:({
                UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolView:)];
                pan;
            })];
            coverBtn.hidden = YES;
            coverBtn;
        })];
        
        //夜间模式
        [self addSubview:({
            
            SPHaloButton *lightButton = [[SPHaloButton alloc] initWithFrame:CGRectMake(ScreenWidth - lightButtonWH - DZMSpace_1, ScreenHeight, lightButtonWH, lightButtonWH) haloColor:[[UIColor blackColor] colorWithAlphaComponent:0.75] ];
            lightButton.selectImage = [UIImage imageNamed:@"RM_14"];
            lightButton.nomalImage = [UIImage imageNamed:@"RM_13"];
            [lightButton addTarget:self action:@selector(lightAction:) forControlEvents:UIControlEventTouchUpInside];
            lightButton.selected = NO;
            _lightButton = lightButton;
            lightButton;
            
        })];
        
        [self addSubview:({
            
            SPStatusView *statusView = [[SPStatusView alloc] initWithFrame:CGRectMake(DZMSpace_1, ScreenHeight - DZMSpace_2, ScreenWidth - 2 * DZMSpace_1, DZMSpace_2)];
            _statusView = statusView;
            statusView;
            
        })];
        
        [self addSubview:({
            SPTopView *topView = [[SPTopView alloc] initWithFrame:CGRectMake(0, -kStatusBarAndNavigationBarHeight-DZMSpace_1, kScreenWidth, kStatusBarAndNavigationBarHeight)];
            topView.backgroundColor = DZMMenuUIColor;
            _topView = topView;
            topView;
        })];
        
        [self addSubview:({
            
            SPSettingView *settingView = [[SPSettingView alloc] initWithFrame:CGRectMake(0, ScreenHeight+DZMSpace_1, ScreenWidth, NovelsSettingViewH)];
            _settingView = settingView;
            settingView.backgroundColor = DZMMenuUIColor;
            settingView;
        })];
        
        
        [self addSubview:({
            SPButtomView *buttomView = [[SPButtomView alloc] initWithFrame:CGRectMake(0, kScreenHeight + DZMSpace_1, kScreenWidth, kTabbarSafeBottomMargin + 112)];
            buttomView.backgroundColor = DZMMenuUIColor;
            _buttomView = buttomView;
            buttomView.funClick = ^(NSInteger code) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.settingView.transform = CGAffineTransformMakeTranslation(0, -NovelsSettingViewH-DZMSpace_1);
                    
                    self.buttomView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    
                }];
                
            };
            buttomView;
        })];
        
        __weak typeof(self) weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:DZMNotificationNamePageWillScroll object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            
            if (!weakSelf.coverButton.isHidden) {
                [weakSelf showToolView:nil];
            }
        }];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lightView = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.lightView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            self.lightView.windowLevel = UIWindowLevelStatusBar+2;
            self.lightView.hidden = NO;
            self.lightView.alpha = 0.0;
            self.lightView.userInteractionEnabled = NO;
            self.lightView.rootViewController = [LightViewController new];
        });

    }
    return self;
}

- (void)lightAction:(SPHaloButton *)sender{
    sender.spSelected = !sender.spSelected;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lightView.alpha = (CGFloat)sender.spSelected;
    }];
}

/// 创建放大镜
- (void)creatMagnifierView:(CGPoint )windowPoint {
    
    if (self.magnifierView == nil) {
        
        self.magnifierView = [[DZMMagnifierView alloc] init];
        self.magnifierView.targetWindow = self.window;
        self.magnifierView.targetPoint = windowPoint;
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender{
    
        
//        // 禁止上下滚动使用
//        if DZMReadConfigure.shared().effectType == DZMRMEffectType.upAndDown.rawValue { return }
//
        // 触摸位置
    CGPoint point = [sender locationInView:self];

        // 触摸位置
    CGPoint windowPoint = [sender locationInView:self.window];

        // 触摸开始 触摸中
    if(sender.state == UIGestureRecognizerStateBegan){

            // 发送通知


            // 放大镜
        [self creatMagnifierView:windowPoint];

    }else if (sender.state == UIGestureRecognizerStateChanged){

            // 设置放大镜位置
        self.magnifierView.targetPoint = windowPoint;

        }else{ // 触摸结束

            // 获得选中区域
//            selectRange = DZMReadAuxiliary.GetTouchLineRange(point: point, frameRef: frameRef)
//
//             获得选中选中范围
//            rects = DZMReadAuxiliary.GetRangeRects(range: selectRange!, frameRef: frameRef, content: content)
//
//            // 显示光标
//            cursor(isShow: true)
//
            // 设置放大镜位置
            self.magnifierView.targetPoint = windowPoint;
             __weak typeof(self) weakSelf = self;
            [self.magnifierView remove:^{
                weakSelf.magnifierView = nil;
            }];
//
//            // 移除
//            magnifierView?.remove({ [weak self] () in
//
//                // 清空
//                self?.magnifierView = nil
//
//                // 显示菜单
//                self?.menu(isShow: true)
//            })
//
//            // 重绘
            [self setNeedsDisplay];
//
//            // 开启手势
//            if !rects.isEmpty {
//
//                // 手势状态
//                longGes?.isEnabled = false
//                tapGes?.isEnabled = true
//                isOpenDrag = true
//
//                // 发送通知
//                DZMReadView.PostNotification(userInfo: [DZMKey_ReadView_Ges_isOpen: NSNumber(value: false)])
//            }
        }
    
}
- (void)showToolView:(UITapGestureRecognizer *)sender{
    
    if (self.coverButton.isHidden) {
        self.statusBarHidden = NO;
        self.coverButton.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.transform = CGAffineTransformMakeTranslation(0, kStatusBarAndNavigationBarHeight+DZMSpace_1);
            self.buttomView.transform = CGAffineTransformMakeTranslation(0, -(kTabbarSafeBottomMargin+112+DZMSpace_1));
            
        } completion:^(BOOL finished) {
        }];
        
        
        ////
        self.lightButton.frame = CGRectMake(ScreenWidth - lightButtonWH - DZMSpace_1, ScreenHeight, lightButtonWH, lightButtonWH);

        [UIView animateWithDuration:0.25 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.lightButton.frame = CGRectMake(ScreenWidth - lightButtonWH - DZMSpace_1, ScreenHeight - 112 - DZMSpace_2 * 2 - lightButtonWH, lightButtonWH, lightButtonWH);
        } completion:nil];

    }else{
        self.statusBarHidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.transform = CGAffineTransformIdentity;
            self.buttomView.transform = CGAffineTransformIdentity;
            self.settingView.transform = CGAffineTransformIdentity;
            
            self.lightButton.frame = CGRectMake(ScreenWidth, self.lightButton.frame.origin.y, lightButtonWH, lightButtonWH);
            
        } completion:^(BOOL finished) {
            self.coverButton.hidden = YES;
        }];
        
        
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tapView.frame = CGRectMake(88, 0, self.bounds.size.width - 88 * 2 , self.bounds.size.height);
    self.coverButton.frame = self.bounds;
    
    
    if (self.isShow == SPReaderShowTypeSet && self.coverButton.isHidden) {
        self.statusBarHidden = NO;
        self.coverButton.hidden = NO;
        self.topView.transform = CGAffineTransformMakeTranslation(0, kStatusBarAndNavigationBarHeight+DZMSpace_1);
        self.settingView.transform = CGAffineTransformMakeTranslation(0, -NovelsSettingViewH-DZMSpace_1);
        
        self.buttomView.transform = CGAffineTransformIdentity;
        
        
    }
    
    if (self.isShow == SPReaderShowTypeMenu && self.coverButton.isHidden) {
        self.statusBarHidden = NO;
        self.coverButton.hidden = NO;
        self.topView.transform = CGAffineTransformMakeTranslation(0, kStatusBarAndNavigationBarHeight+DZMSpace_1);
        self.buttomView.transform = CGAffineTransformMakeTranslation(0, -(kTabbarSafeBottomMargin+112+DZMSpace_1));
        
    }
    
}



//-(void)drawRect:(CGRect)rect{
//
//    self.frameRef = [self parserContent:_content];
//    if (!_frameRef) {
//        return;
//    }
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
//    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
//    CGContextScaleCTM(ctx, 1.0, -1.0);
//    CTFrameDraw(_frameRef, ctx);
//}

//FIXME:  -  隐藏状态栏
- (void)setStatusBarHidden:(BOOL)statusBarHidden{
    _statusBarHidden = statusBarHidden;
    if(statusBarHidden) [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelStatusBar + 1];
    else [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelStatusBar - 1];
    
}

//
//- (CTFrameRef)parserContent:(NSString *)content{
//
//
//
////    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
////    attribute[NSForegroundColorAttributeName] = [UIColor orangeColor];
////    attribute[NSFontAttributeName] = [UIFont systemFontOfSize:14.0];
////
////    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
////    paragraphStyle.lineSpacing = 10;
////    //paragraphStyle.paragraphSpacing = 10;
////    paragraphStyle.alignment = NSTextAlignmentJustified;
////    paragraphStyle.lineHeightMultiple = 1.0;
////    attribute[NSParagraphStyleAttributeName] = paragraphStyle;
//
//
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content attributes:SPReadConfig.attributeStyle];
//
//    NSLog(@"%s-fontSize-%ld", __func__,(long)SPReadConfig.defaultConfig.fontSize);
//    NSLog(@"%s-lineSpace-%ld", __func__,(long)SPReadConfig.defaultConfig.lineSpace);
//    NSLog(@"%s-fontColor-%@", __func__,(long)SPReadConfig.defaultConfig.fontColor);
//    NSLog(@"%s-themeColor-%@", __func__,(long)SPReadConfig.defaultConfig.themeColor);
//    NSLog(@"%s-fontType-%ld", __func__,(long)SPReadConfig.defaultConfig.fontType);
//
//
//    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
//
//    CGPathRef pathRef = CGPathCreateWithRect(self.bounds, NULL);
//    //CGPathRef pathRef = CGPathCreateWithRect(CGRectMake(LeftSpacing, TopSpacing, self.bounds.size.width - 2 * LeftSpacing, self.bounds.size.height - 2 * TopSpacing), NULL);
//
//    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, NULL);
//    CFRelease(setterRef);
//    CFRelease(pathRef);
//    return frameRef;
//
//}


- (void)setContent:(NSString *)content{
    _content = content;
    self.readView.content = content;
    //    [self.readView setNeedsDisplay];
}

- (void)setProgressTitle:(NSString *)progressTitle{
    _progressTitle = progressTitle;
    self.statusView.titleLabel.text = progressTitle;
    NSArray *indexs = [progressTitle componentsSeparatedByString:@"-"];
    NSInteger page = [indexs[1] integerValue];
    NSInteger totalPage = [indexs.lastObject integerValue];
    self.buttomView.progress = page * 1.0 /totalPage;
}

//
//- (void)setFrameRef:(CTFrameRef)frameRef{
//    _frameRef = frameRef;
//    //self.backgroundColor = [SPReadConfig defaultConfig].themeColor;
//    self.statusView.titleLabel.text = self.progressTitle;
//}



@end

@implementation LightViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

@end


