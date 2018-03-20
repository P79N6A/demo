//
//  TTZTagView.m
//  tagView
//
//  Created by Jay on 2018/3/9.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZTagView.h"
@interface TTZTagView ()
@property (nonatomic, strong) NSMutableArray <UIButton *> *views;
@property (nonatomic, strong) NSMutableArray  *frames;

@end


@implementation TTZTagView

- (NSMutableArray *)frames{
    if (!_frames) {
        _frames = [NSMutableArray array];
    }
    return _frames;
}



- (void)setModels:(NSArray<NSString *> *)models{
    _models = models;
    
    [self contentHeight:models];
    for (NSInteger i = 0; i < models.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                [btn setTitle:models[i] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor orangeColor];
                btn.frame = [self.frames[i] CGRectValue];
                [self addSubview:btn];
        
    }
}

- (CGFloat)contentHeight:(NSArray<NSString *> *)models
{
    
    [self.frames removeAllObjects];
    CGFloat top = 10;
    CGFloat left = 10;
    CGFloat right = 10;
    CGFloat buttom = 10;
    
    for (NSInteger i = 0; i < models.count; i ++) {

        CGFloat x=0;
        CGFloat y=0;
        CGFloat w = [models[i] stringWidthWithFont:[UIFont systemFontOfSize:15] height:30];
        CGFloat h = 30;
        
        if (self.frames.count < 1) {
            x = left;
            y = top;
            
        }else{
            
            CGRect  lastFrame = [self.frames[i-1] CGRectValue];
            
            CGFloat maxW = CGRectGetMaxX(lastFrame) + 5 + w + right;
            
            if (maxW > self.bounds.size.width) {
                x = left;
                y = CGRectGetMaxY(lastFrame) + 5;
            }else{
                y = lastFrame.origin.y;
                x = CGRectGetMaxX(lastFrame)+5;
            }
            
        }
        
         CGRect  frame = CGRectMake(x, y, w, h);
         [self.frames addObject: [NSValue valueWithCGRect:frame]];
    }
    return CGRectGetMaxY( [self.frames.lastObject CGRectValue]) + buttom;
}

@end

@implementation NSString (NSStringWidth)
- (CGFloat)stringWidthWithFont:(UIFont *)font height:(CGFloat)height {
    if (self == nil || self.length == 0) {
        return 0;
    }
    
    NSString *copyString = [NSString stringWithFormat:@"%@", self];
    
    CGSize constrainedSize = CGSizeMake(999999, height);
    
    NSDictionary * attribute = @{NSFontAttributeName:font};
    CGSize size = [copyString boundingRectWithSize:constrainedSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return ceilf(size.width);
}
@end
