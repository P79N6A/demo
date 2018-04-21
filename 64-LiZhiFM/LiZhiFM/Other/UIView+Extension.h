#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGSize size;

@property CGFloat left;

@property CGFloat top;

@property CGFloat right;

@property CGFloat bottom;

- (void) scaleBy: (CGFloat) scaleFactor;

- (void) moveBy: (CGPoint) delta;

@property (assign, nonatomic) CGFloat maxX;

@property (assign, nonatomic) CGFloat maxY;

- (void) fitInSize: (CGSize) aSize;

+ (instancetype)viewFirstXib;

+ (instancetype)viewFromXib;

@end
