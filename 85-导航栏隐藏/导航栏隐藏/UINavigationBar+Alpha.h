
#import <UIKit/UIKit.h>
@interface UINavigationBar (Alpha)

// 改变透明度的view
//@property (nonatomic, strong) UIView *alphaView;

// 根据颜色改变透明度
- (void)changeNavigationBarAlphaWith:(UIColor *)color;
- (void)resetNavBar;
@end
