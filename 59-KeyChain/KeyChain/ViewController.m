//
//  ViewController.m
//  KeyChain
//
//  Created by Jay on 2018/4/11.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "TTZKeyChain.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *name = [TTZKeyChain objforKey:@"name" withService:@"com.ishare.www"];
    
    NSString *json = @"{@\"name\" : @\"曹志\",@\"age\":@\"12\"}";
    
    [TTZKeyChain setObj:json forKey:@"name" withService:@"com.ishare.www"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
