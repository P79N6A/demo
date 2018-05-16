//
//  HomeViewController.m
//  9*9
//
//  Created by Jay on 2018/4/9.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "HomeViewController.h"
#import "TTZData.h"

//View圆角和加边框

#define kViewBorderRadius(View,Radius,Width,Color)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]


@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bgView.image = [TTZData bgImage];
    [self.btn1 setBackgroundImage:[TTZData bgImage] forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:[TTZData bgImage] forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:[TTZData bgImage] forState:UIControlStateNormal];
    [self.btn4 setBackgroundImage:[TTZData bgImage] forState:UIControlStateNormal];
    
    kViewBorderRadius(self.btn1, 5, 2, [UIColor whiteColor]);
    kViewBorderRadius(self.btn2, 5, 2, [UIColor whiteColor]);
    kViewBorderRadius(self.btn3, 5, 2, [UIColor whiteColor]);
    kViewBorderRadius(self.btn4, 5, 2, [UIColor whiteColor]);

}



- (BOOL)prefersStatusBarHidden{
    return YES;
}
@end
