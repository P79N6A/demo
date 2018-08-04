
#import "UINavigationBar+Alpha.h"
#import <objc/runtime.h>



@implementation UINavigationBar (Alpha)

//图片的地址
static char *alview;

//重写uiview的方法
- (void)setAlphaView:(UIView *)alphaView
{
    //&alview  地址符
    objc_setAssociatedObject(self, &alview, alphaView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//get方法
- (UIView *)alphaView
{
    return objc_getAssociatedObject(self, &alview);
}

- (void)changeNavigationBarAlphaWith:(UIColor *)color
{
    if (!self.alphaView) {
        // 1.添加空的图片给navigationBar
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.shadowImage = [UIImage new];
        // 2.创建alphaView
        CGFloat y =  [UIApplication sharedApplication].statusBarFrame.size.height ;
        CGFloat h = y + self.frame.size.height;
        //self.alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, -y, [UIScreen mainScreen].bounds.size.width, h)];
        self.alphaView = [[UIView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, h)];

        self.alphaView.userInteractionEnabled = NO;
        self.alphaView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        // 3.设置层级结构
        //[self insertSubview:self.alphaView atIndex:0];
        [self.subviews.firstObject  insertSubview:self.alphaView atIndex:0];
    }
    // 4.设置alphaView颜色
    self.alphaView.backgroundColor = color;
    
}


- (void) resetNavBar{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = nil;
    [self.alphaView removeFromSuperview];
    self.alphaView = nil;
}

@end
