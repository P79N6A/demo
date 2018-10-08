//
//  SPHaloButton.m
//  page
//
//  Created by Jay on 9/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPHaloButton.h"
#import "UIView+PulseView.h"
#import "const.h"

@interface SPHaloButton()
@property (nonatomic, strong) UIColor *haloColor;

@end


@implementation SPHaloButton

- (void)setSpSelected:(BOOL)spSelected{
    _spSelected = spSelected;
    if (spSelected) {
        if (self.selectImage) self.spImageView.image = self.selectImage;
    }else{
        if (self.nomalImage) self.spImageView.image = self.nomalImage;
    }
}

- (void)setNomalImage:(UIImage *)nomalImage{
    _nomalImage = nomalImage;
    if (!_spSelected) {
        self.spImageView.image = nomalImage;
    }
}

- (void)setSelectImage:(UIImage *)selectImage{
    _selectImage = selectImage;
    if (_spSelected) {
        self.spImageView.image = selectImage;
    }
}



- (instancetype)initWithFrame:(CGRect)frame
                    haloColor:(UIColor *)color{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.enabled = YES;
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
    [self.spImageView startPulseWithColor:color scaleFrom:1.0 to:1.2 frequency:1.0 opacity:0.5 animation:PulseViewAnimationTypeRegularPulsing];
}

- (void)closeHalo{
    [self.spImageView stopPulse];
}

- (void)setFrame{
    self.spImageView.frame = CGRectMake(DZMSpace_4, DZMSpace_4, self.bounds.size.width - DZMSpace_5, self.bounds.size.height - DZMSpace_5);
    self.spImageView.layer.cornerRadius = 0.5 * (self.bounds.size.width - DZMSpace_5);
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setFrame];
    NSLog(@"%s", __func__);
}

@end
