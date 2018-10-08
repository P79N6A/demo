//
//  SPHaloButton.h
//  page
//
//  Created by Jay on 9/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPHaloButton : UIButton
@property (nonatomic, weak) UIImageView *spImageView;
@property (nonatomic, strong) UIImage *nomalImage;
@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, assign) BOOL spSelected;
- (instancetype)initWithFrame:(CGRect)frame
                    haloColor:(UIColor *)color;
+ (CGSize)HaloButtonSize:(CGSize)size;
@end
