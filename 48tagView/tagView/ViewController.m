//
//  ViewController.m
//  tagView
//
//  Created by Jay on 2018/3/9.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

#import "TTZTagView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h;

@property (weak, nonatomic) IBOutlet TTZTagView *tagView;
@property (nonatomic, strong) NSArray *data;

@end/** <##> */

@implementation ViewController
- (NSArray *)data {
    if (_data == nil) {
        _data = @[@"Energy",
                  @"Pharmaceutical Healthcare",
                  @"Financial Economics",
                  @"Automotive",
                  @"Environment",
                  @"Education",
                  @"IT Internet",
                  @"Telecoms Electronics",
                  @"Construction",
                  @"Chemical",
                  @"Legal",
                  @"Art",
                  @"Culture",
                  @"Agriculture",
                  @"Media",
                  @"Logistics Transport",
                  @"Investment",
                  @"Aero Aviation",
                  @"Tourism",
                  @"Traffic",
                  @"Food",
                  @"Machinery",
                  @"Real Estate",
                  @"Fashion Luxury",
                  @"Steel Mining",
                  @"Technology",
                  
                  ];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tagView.models = self.data;
        self.h.constant = [self.tagView contentHeight:self.data];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
