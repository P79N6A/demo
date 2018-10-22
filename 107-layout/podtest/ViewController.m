//
//  ViewController.m
//  podtest
//
//  Created by Jay on 17/10/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
//#import <YHLibSrc/MBProgressHUD+MJ.h>
//#import <YHLibSrc/YHCategoryHeader.h>

#import "UIView+Layout.h"

@interface ViewController ()
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) UIView *redView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];

    
    [self.view addSubview:redView];
    self.redView = redView;
     __weak typeof(self) weakSelf = self;
    [redView setLyHeight:^(LayoutModel * _Nonnull layout) {
        //(layout).constant = 200;
        layout.relativeToView = weakSelf.view;
        layout.multiplier = 0.6;
    }];

    [redView setLyWidth:^(LayoutModel  *layout) {
        (layout).constant = 200;
    }];

    [redView setLyCenterX:^(LayoutModel  *layout) {

    }];
    [redView setLyCenterY:^(LayoutModel  *layout) {

    }];
    [UIView animateWithDuration:33 animations:^{
        
    }];
    UISwitch *sw = [UISwitch new];
    [redView addSubview:sw];
    [sw setLyCenterX:nil];

    
    
    [sw setLyCenterY:nil];
    
//    [redView setLyRight:^(LayoutModel *__autoreleasing *layout) {
////        (*layout).relativeToView = self.view;
//        (*layout).constant = -10;
//    }];
//
//    [redView setLyTop:^(LayoutModel *__autoreleasing *layout) {
////        (*layout).relativeToView = self.view;
//        (*layout).constant = 10;
//    }];
//    [redView setLyButtom:^(LayoutModel *__autoreleasing *layout) {
////        (*layout).relativeToView = self.view;
////        (*layout).constant = -10;
//    }];
//
//    [redView setLyleft:^(LayoutModel *__autoreleasing *layout) {
////        (*layout).relativeToView = self.view;
////        (*layout).constant = 10;
//    }];
    
    UIButton *add = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [redView addSubview:add];
    
    [add setLyTop:^(LayoutModel * _Nonnull layout) {
        layout.constant = 10;
    }];
    

    
    [add setLyleft:^(LayoutModel * _Nonnull layout) {
        layout.constant = 5;
    }];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.heightConstraint.constant = 300;
    self.redView.lyHeight.constant = 100;
//    [self.view removeConstraint:self.heightConstraint];
//
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.redView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:100]];
}

@end
