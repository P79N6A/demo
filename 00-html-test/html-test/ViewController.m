//
//  ViewController.m
//  html-test
//
//  Created by czljcb on 2017/11/3.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://m.91kds.com/"] encoding:NSUTF8StringEncoding error:nil];

//    NSLog(@"%@",htmlString);
    
    NSArray *tem = [htmlString componentsSeparatedByString:@"<li>"];
    [tem enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            
            NSRange rangeHTML = [obj rangeOfString:@".html"];
            NSRange rangeHREF = [obj rangeOfString:@"href=\""];

            NSString *indexHtml = [obj substringWithRange:NSMakeRange(rangeHREF.location+rangeHREF.length, rangeHTML.location-rangeHREF.location-rangeHREF.length)];

        
        }
    }];
    
    
}


+ (NSMutableString *)getAStringOfChineseWord:(NSString *)string
{
    if (string == nil || [string isEqual:@""])
    {
        return nil;
    }
    NSMutableString *str = [[NSMutableString alloc]init];
    for (int i=0; i<[string length]; i++)
    {
        int a = [string characterAtIndex:i];
        if (a < 0x9fff && a > 0x4e00)
        {
            [str appendString:[string substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    return str;
}


@end
