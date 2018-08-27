//
//  ViewController.m
//  keyInput
//
//  Created by Jay on 27/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "UIView+LayoutMethods.h"
#import "UIView+HandyAutoLayout.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    [view setCt_size:CGSizeMake(200, 200)];
    [view centerEqualToView:self.view];
//    [self.view addConstraint:[view constraintWidth:200]];
//
//   NSLayoutConstraint * h = [view constraintHeightEqualToView:self.view];
//    [self.view addConstraint:h];
//
//    [self.view addConstraint:[view constraintCenterXEqualToView:self.view]];
//    [self.view addConstraint:[view constraintCenterYEqualToView:self.view]];

    //for auto layout:
//
//        [self.view addConstraint:[self.tableView constraintCenterXEqualToView:self.view]];
//    [self.view addConstraint:[self.tableView constraintWidthEqualToView:self.view]];
//
//    [self.view addConstraints:[self.nextStepButton constraintsSize:CGSizeMake(300.0f, 40.0f)]];
//    [self.view addConstraint:[self.nextStepButton constraintCenterXEqualToView:self.view]];
    //for frame:
        
//        [self.subtitleLabel leftEqualToView:self.titleLabel];
//    [self.subtitleLabel top:14 FromView:self.timeLabel];
//
//    [self.createPost centerXEqualToView:self.view];
//    [self.createPost bottomInContainer:19.0f shouldResize:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
