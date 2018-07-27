//
//  UIView+EffectView.m
//  tvbyb
//
//  Created by Jay on 12/6/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "UIView+EffectView.h"
#import <objc/runtime.h>

static char ACTIVITY_EFFECT_KEY;

@implementation UIView (EffectView)
- (UIVisualEffectView *)effectView {
    return objc_getAssociatedObject(self, &ACTIVITY_EFFECT_KEY);
}

- (void)setEffectView:(UIVisualEffectView *)effectView {
    objc_setAssociatedObject(self, &ACTIVITY_EFFECT_KEY, effectView, OBJC_ASSOCIATION_RETAIN);
}

- (void)setEnabledEffect:(BOOL)enabledEffect{
    
    
    if (enabledEffect) {
        
        if (self.effectView) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            effectView.frame = self.bounds;
            effectView.userInteractionEnabled = NO;
            [self addSubview:effectView];
            self.effectView = effectView;
        });
        return;
    }
    
    [self.effectView removeFromSuperview];
}

- (BOOL)enabledEffect{
    return YES;
}


@end
