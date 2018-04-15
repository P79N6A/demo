//
//  ViewController.m
//  getHTML
//
//  Created by czljcb on 2017/11/25.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "ViewController.h"
#import "HTMLManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    [[HTMLManager sharedInstance] getHtmlWithURL:@"http://m.91kds.com/" sucess:^(NSString *html) {
       NSLog(@"%s---%@", __func__,html);
    } error:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
