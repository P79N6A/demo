//
//  TransFromAnimation.h
//  audioPlayer
//
//  Created by Jay on 27/7/18.
//  Copyright © 2018年 Jayson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,YJPPresentAnimationType) {
    YJPPresentAnimationPresent = 0,
    YJPPresentAnimationDismiss
};

@interface TransFromAnimation : NSObject<UIViewControllerAnimatedTransitioning>


-(instancetype)initWithAnimationType:(YJPPresentAnimationType)type;
+(instancetype)transfromWithAnimationType:(YJPPresentAnimationType)type;

@end

