//
//  SPHaloButton.m
//  page
//
//  Created by Jay on 9/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPHaloButton.h"
#import "UIView+YGPulseView.h"
#import "const.h"

@interface SPHaloButton()
@property (nonatomic, strong) UIColor *haloColor;
//@property (nonatomic, strong) UIImage *nomalImage;
//@property (nonatomic, strong) UIImage *selectImage;
//@property (nonatomic, assign) BOOL isSelected;
@end


@implementation SPHaloButton

//- (void)setIsSelected:(BOOL)isSelected{
//    _isSelected = isSelected;
//    if (isSelected) {
//        if (self.selectImage) self.imageView.image = self.selectImage;
//    }else{
//        if (self.nomalImage) self.imageView.image = self.nomalImage;
//    }
//}


- (instancetype)initWithFrame:(CGRect)frame
                    haloColor:(UIColor *)color{
    self = [super initWithFrame:frame];
    if (self) {
        self.haloColor = color;
        [self addSubview:({

            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.backgroundColor = self.haloColor;
            _spImageView = imageView;
            imageView;
        })];
        

        [self setFrame];
        [self openHalo:color];
    }
    return self;
}


+ (CGSize)HaloButtonSize:(CGSize)size{
    return CGSizeMake(size.width + DZMSpace_5, DZMSpace_5 + size.height);
}

- (void)openHalo:(UIColor *)color{
    self.haloColor = color;
    [self.spImageView startPulseWithColor:color scaleFrom:1.0 to:1.2 frequency:1.0 opacity:0.5 animation:YGPulseViewAnimationTypeRegularPulsing];
}

- (void)closeHalo{
    [self.imageView stopPulse];
}

- (void)setFrame{
    self.spImageView.frame = CGRectMake(DZMSpace_4, DZMSpace_4, self.bounds.size.width - DZMSpace_5, self.bounds.size.height - DZMSpace_5);
    self.spImageView.layer.cornerRadius = 0.5 * (self.bounds.size.width - DZMSpace_5);
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setFrame];
}

@end
