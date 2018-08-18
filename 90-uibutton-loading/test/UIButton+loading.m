
//
//  UIButton+loading.m
//  test
//
//  Created by Jay on 14/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "UIButton+loading.h"
#import <objc/runtime.h>


static char kLoading;
static char ACTIVITY_INDICATOR_KEY;
static char kTitleKey;
static char kNormalTitle;

@implementation UIButton (loading)


- (BOOL)loading{
        return [objc_getAssociatedObject(self, &kLoading) boolValue];
}

- (void)setLoading:(BOOL)loading{
    
    objc_setAssociatedObject(self, &kLoading, @(loading), OBJC_ASSOCIATION_RETAIN);
    if (loading) {
        
        [self addObserver:self forKeyPath:@"self.titleLabel.frame" options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) context:NULL];

        self.userInteractionEnabled = NO;
        if (!self.loadingView) {

            self.normalTitle = [self titleForState:UIControlStateNormal];
            UIActivityIndicatorView * loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.bounds.size.width * 0.5 - 10, 0, 20, self.bounds.size.height)];
            loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;

            self.loadingView = loadingView;
            [self addSubview:loadingView];
        }
        
        [self setTitle:self.title forState:UIControlStateNormal];

        if(!self.loadingView.isAnimating) [self.loadingView startAnimating];

    }else{
        if (self.loadingView) {
            [self.loadingView removeFromSuperview];
            self.loadingView = nil;
        }
        [self setTitle:self.normalTitle forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
        [self removeObserver:self forKeyPath:@"self.titleLabel.frame"];
    }
}


#pragma mark - KVO Observation
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"%s--%@---%@", __func__,keyPath,change);
    if ([keyPath isEqualToString:@"self.titleLabel.frame"] && self.loadingView) {
        self.loadingView.center = CGPointMake(self.titleLabel.frame.origin.x - 5 -self.loadingView.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    }
}


- (void)setTitle:(NSString *)title{
        objc_setAssociatedObject(self, &kTitleKey, title, OBJC_ASSOCIATION_RETAIN);
}
- (NSString *)title{
    return objc_getAssociatedObject(self, &kTitleKey);
}

- (void)setNormalTitle:(NSString *)normalTitle{
    objc_setAssociatedObject(self, &kNormalTitle, normalTitle, OBJC_ASSOCIATION_RETAIN);
}
- (NSString *)normalTitle{
    return objc_getAssociatedObject(self, &kNormalTitle);
}

- (UIActivityIndicatorView *)loadingView {
    return objc_getAssociatedObject(self, &ACTIVITY_INDICATOR_KEY);
}

- (void)setLoadingView:(UIActivityIndicatorView *)loadingView {
    objc_setAssociatedObject(self, &ACTIVITY_INDICATOR_KEY, loadingView, OBJC_ASSOCIATION_RETAIN);
}


+ (void)load
{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        
        SEL originalSelectorTitle = @selector(setTitle:forState:);
        
        SEL swizzledSelectorTitle = @selector(cz_setTitle:forState:);
        
        Method originalMethodTitle = class_getInstanceMethod(class, originalSelectorTitle);
        
        Method swizzledMethodTitle = class_getInstanceMethod(class, swizzledSelectorTitle);
        
        BOOL successPush = class_addMethod(class, originalSelectorTitle, method_getImplementation(swizzledMethodTitle), method_getTypeEncoding(swizzledMethodTitle));
        
        if (successPush) {
            
            class_replaceMethod(class, swizzledSelectorTitle, method_getImplementation(originalMethodTitle), method_getTypeEncoding(originalMethodTitle));
        } else {
            
            method_exchangeImplementations(originalMethodTitle, swizzledMethodTitle);
        }
        
        
    });
}



- (void)cz_setTitle:(NSString *)title forState:(TTControlState)state{

    if (state == TTControlStateLoading) {
        self.title = title;
        return;
    }
    BOOL loading =  self.loading;
    if (state == TTControlStateNormal && !loading) {
        self.normalTitle = title;
    }
    
    [self cz_setTitle:title forState:state];
}






@end
