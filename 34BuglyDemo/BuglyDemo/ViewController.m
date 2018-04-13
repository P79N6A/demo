//
//  ViewController.m
//  BuglyDemo
//
//  Created by FEIWU888 on 2017/10/19.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSError *err;
    NSURL *url = [NSURL URLWithString:@"http://www.guangbomi.com/"];
    
    NSData *responseData = [NSData dataWithContentsOfURL:url];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:enc];
    

     NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.guangbomi.com/"] encoding:NSUTF8StringEncoding error:&err];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray *array = @[@"33"];
    NSLog(@"%@",array[0]);
    NSLog(@"%@",array[1]);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
