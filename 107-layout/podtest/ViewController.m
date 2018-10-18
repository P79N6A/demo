//
//  ViewController.m
//  podtest
//
//  Created by Jay on 17/10/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import <YHLibSrc/MBProgressHUD+MJ.h>
#import <YHLibSrc/YHCategoryHeader.h>

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
    
//    [redView setLyHeight:^(LayoutModel *__autoreleasing* _Nonnull layout) {
//        (*layout).constant = 200;
//        (*layout).relativeToView = nil;
//
//    }];
//
//    [redView setLyWidth:^(LayoutModel *__autoreleasing *layout) {
//        (*layout).constant = 200;
//        (*layout).relativeToView = nil;
//    }];
//
//    [redView setLyCenterX:^(LayoutModel *__autoreleasing *layout) {
//
//    }];
//    [redView setLyCenterY:^(LayoutModel *__autoreleasing *layout) {
//
//    }];
    
    [redView setLyRight:^(LayoutModel *__autoreleasing *layout) {
//        (*layout).relativeToView = self.view;
        (*layout).constant = -10;
    }];

    [redView setLyTop:^(LayoutModel *__autoreleasing *layout) {
//        (*layout).relativeToView = self.view;
        (*layout).constant = 10;
    }];
    [redView setLyButtom:^(LayoutModel *__autoreleasing *layout) {
//        (*layout).relativeToView = self.view;
//        (*layout).constant = -10;
    }];

    [redView setLyleft:^(LayoutModel *__autoreleasing *layout) {
//        (*layout).relativeToView = self.view;
//        (*layout).constant = 10;
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
