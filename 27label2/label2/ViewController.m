//
//  ViewController.m
//  label2
//
//  Created by FEIWU888 on 2017/9/30.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import "ViewController.h"

#import "MarqueeLabel.h"

@interface ViewController ()
/** <##> */
@property (nonatomic, weak) MarqueeLabel *demoLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MarqueeLabel *newLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width-200, 20) duration:8.0 andFadeLength:10.0f];
    self.demoLabel = newLabel;
    
    [self.view addSubview:self.demoLabel];
    
    self.demoLabel.numberOfLines = 1;
    self.demoLabel.opaque = NO;
    self.demoLabel.enabled = YES;
    self.demoLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    self.demoLabel.textAlignment = UITextAlignmentLeft;
    self.demoLabel.textColor = [UIColor colorWithRed:0.234 green:0.234 blue:0.234 alpha:1.000];
    self.demoLabel.backgroundColor = [UIColor clearColor];
    self.demoLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.000];
    
    self.demoLabel.text = @"怎么才能让字体匀速滚动呢？我看刚开始的时候慢，中间款，后来又慢了";
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
