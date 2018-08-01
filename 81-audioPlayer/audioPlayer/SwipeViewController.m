
#import "SwipeViewController.h"

@interface SwipeViewController ()

@property(nonatomic,assign)CGFloat persentCompleted;
@property(nonatomic,strong)UIViewController *dissmissVC;

@end

@implementation SwipeViewController


- (void)handleDismissViewController:(UIViewController *)controller
{
    self.dissmissVC = controller;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [controller.view addGestureRecognizer:pan];
}

-(CGFloat )completionSpeed
{
    return 1 - self.persentCompleted;
}

-(void)panAction:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture translationInView:self.dissmissVC.view];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interacting = YES;
            //[self.dissmissVC dismissViewControllerAnimated:YES completion:nil];
            
            break;
        }
        
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat persent = (point.y/500) <=1 ?(point.y/500):1;
            self.persentCompleted = persent;
            [self updateInteractiveTransition:persent];
            
            
            self.dissmissVC.view.center = CGPointMake(self.dissmissVC.view.center.x + point.x, self.dissmissVC.view.center.y + point.y);
            [gesture setTranslation:CGPointMake(0, 0) inView:self.dissmissVC.view];

            break;
        }
        
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            [self.dissmissVC dismissViewControllerAnimated:YES completion:nil];

            self.interacting = NO;
            if (gesture.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }else{
                [self finishInteractiveTransition];
            }
            break;
        }
            
        default:
            break;
    }
    
}


@end
