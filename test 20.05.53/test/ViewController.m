//
//  ViewController.m
//  test
//
//  Created by Jay on 14/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+loading.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *login;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self.login setTitle:@"功能的高期望" forState:TTControlStateLoading];
    [self.login setTitle:@"tttr" forState:UIControlStateNormal];

    
    
}


- (IBAction)start:(id)sender {
    self.login.loading = YES;
}

- (IBAction)stop:(id)sender {
    self.login.loading = NO;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
