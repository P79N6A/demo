
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CAAnimation.h>

typedef NS_ENUM(NSUInteger, PulseViewAnimationType) {
    PulseViewAnimationTypeRegularPulsing,
    PulseViewAnimationTypeRadarPulsing
};

@interface UIView (PulseView)

- (void)startPulseWithColor:(UIColor *)color;

- (void)startPulseWithColor:(UIColor *)color animation:(PulseViewAnimationType)animationType;

- (void)startPulseWithColor:(UIColor *)color scaleFrom:(CGFloat)initialScale to:(CGFloat)finishScale frequency:(CGFloat)frequency opacity:(CGFloat)opacity animation:(PulseViewAnimationType)animationType;

- (void)stopPulse;

@end
