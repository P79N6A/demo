//
//  ViewController.m
//  label
//
//  Created by FEIWU888 on 2017/9/5.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import "ViewController.h"

#import "FWGiftLabel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet FWGiftLabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.label startAnimWithDuration:10.0];
}

@end
