//
//  ViewController.m
//  9*9
//
//  Created by Jay on 2018/4/3.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "TTZTagView.h"
#import "TTZData.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet TTZTagView *contentView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView.ladder = 3;
    self.bgImageView.image = [TTZData bgImage];
    
}
- (IBAction)resetAction {
    [self.contentView reset];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
