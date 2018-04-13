//
//  ViewController.m
//  tap
//
//  Created by FEIWU888 on 2017/9/25.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import "ViewController.h"

#import "XXLinkLabel.h"

#import "UILabel+YBAttributeTextTapAction.h"

#import <CoreText/CoreText.h>

@interface ViewController ()<XXLinkLabelDelegate>
@property (strong, nonatomic) IBOutlet UILabel *moveView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(move)];
    
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    

//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    [self.moveView addGestureRecognizer:tap];
    
//    return;
    //self.moveView.regularType = XXLinkLabelRegularTypeAboat | XXLinkLabelRegularTypeTopic | XXLinkLabelRegularTypeUrl;
    self.moveView.attributedText = [[NSAttributedString alloc] initWithString:@"美233444女ssdeeeee"];
    self.moveView.enabledTapEffect = NO;
    [self.moveView yb_addAttributeTapActionWithStrings:@[@"233"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        NSLog(@"%s--%@", __func__,string);
    }];
//    self.moveView.regularLinkClickBlock = ^(NSString *clickedString) {
//        NSLog(@"%s---%@", __func__,clickedString);
//    };
//    [self.moveView addRegularString:@"美"];

    
}

- (void)move{
    
    self.moveView.frame = CGRectMake(self.moveView.frame.origin.x + 0.01, self.moveView.frame.origin.y + 0.01, 100, 100);

}

//- (void)tapAction:(UITapGestureRecognizer *)tap{
//
//        CGPoint clickPoint =  [tap locationInView:self.moveView];
//        NSLog(@"----------%@", NSStringFromCGPoint(clickPoint));
////        CGPoint movePoint = [self.view convertPoint:clickPoint toView:self.moveView];
//
//        NSInteger index =  [self getindexArrayOfStringInLabel:self.moveView Point:clickPoint];
//    
//        NSLog(@"%s---%d", __func__,index);
////        if ([self.moveView.layer.presentationLayer hitTest:clickPoint])
////        {
////           // NSLog(@"%@.........", NSStringFromCGPoint(movePoint));
////
////        }
//    
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action {
    NSLog(@"%s", __func__);
}

@end
