//
//  ViewController14.m
//  屏幕旋转
//
//  Created by Jay on 2018/4/3.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController14.h"

@interface ViewController14 ()
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@end

@implementation ViewController14

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

}


- (void)orientChange:(NSNotification *)noti

{
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    switch (orient)
    
    {
        case UIDeviceOrientationPortrait:
        {
            [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationPortrait];
            
            self.navigationController.view.transform =CGAffineTransformMakeRotation(0);
            
            self.navigationController.view.bounds = CGRectMake(self.navigationController.view.bounds.origin.x,
                                                               self.navigationController.view.bounds.origin.y,
                                                               MIN(self.view.frame.size.height, self.view.frame.size.width),
                                                               MAX(self.view.frame.size.height, self.view.frame.size.width)
                                                               );
            
            self.view.frame =CGRectMake(0,
                                        0,
                                        MIN(self.view.frame.size.height, self.view.frame.size.width),
                                        MAX(self.view.frame.size.height, self.view.frame.size.width)
                                        );

        }
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        {
            NSLog(@"%s----左------", __func__);
//            self.orientation = UIInterfaceOrientationLandscapeRight;

//            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
//            [UIView animateWithDuration:0.25 animations:^{
//                self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
//            }];
//            self.view.bounds = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//
            
            
            CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
            [UIView animateWithDuration:duration animations:^{
                
                
                [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeRight];
                
                self.navigationController.view.transform =CGAffineTransformMakeRotation(M_PI_2);
                
                self.navigationController.view.bounds = CGRectMake(self.navigationController.view.bounds.origin.x,
                                                                   self.navigationController.view.bounds.origin.y,
                                                                   MAX(self.view.frame.size.height, self.view.frame.size.width),
                                                                   MIN(self.view.frame.size.height, self.view.frame.size.width)
                                                                   );

                self.view.frame =CGRectMake(0,
                                            0,
                                            MAX(self.view.frame.size.height, self.view.frame.size.width),
                                            MIN(self.view.frame.size.height, self.view.frame.size.width)
                                            );

            }];
            


        }
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            break;
            
        case UIDeviceOrientationLandscapeRight:
        {
            NSLog(@"%s----右------", __func__);

//            self.orientation = UIInterfaceOrientationLandscapeLeft;
//            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
//            [UIView animateWithDuration:0.25 animations:^{
//                self.view.transform = CGAffineTransformMakeRotation(-M_PI/2);
//            }];
//            self.view.bounds = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
            
           CGPoint p =  self.navigationController.view.bounds.origin;
            
            CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
            
            [UIView animateWithDuration:duration animations:^{
                
                
                [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeLeft];
                
                
                
                self.navigationController.view.transform =CGAffineTransformMakeRotation(-M_PI_2);
                self.navigationController.view.bounds = CGRectMake(self.navigationController.view.bounds.origin.y,
                                                                   self.navigationController.view.bounds.origin.x,
                                                                   MAX(self.view.frame.size.height, self.view.frame.size.width),
                                                                   MIN(self.view.frame.size.height, self.view.frame.size.width)
                                                                   );
                
                self.view.frame =CGRectMake(0,
                                            0,
                                            MAX(self.view.frame.size.height, self.view.frame.size.width),
                                            MIN(self.view.frame.size.height, self.view.frame.size.width)
                                            );
                
                CGPoint p =  self.navigationController.view.bounds.origin;
NSLog(@"%s", __func__);
                
            }];

        }
            break;
        default:
            
            break;
            
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}


@end
