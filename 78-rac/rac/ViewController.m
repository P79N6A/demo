//
//  ViewController.m
//  rac
//
//  Created by Jay on 22/6/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "RedView.h"

//#import <ReactiveObjC/NSNotificationCenter+RACSupport.h>
//#import <RACSignal.h>
//#import <NSObject+RACSelectorSignal.h>
//
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet RedView *redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    RACSignal *signal = [[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%s", __func__);
    }];
    
    [[self.redView rac_signalForSelector:@selector(redViewAction:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"%s", __func__);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
