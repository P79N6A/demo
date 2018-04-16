//
//  ViewController.m
//  getYueyu
//
//  Created by czljcb on 2018/4/15.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "ViewController.h"

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *url = @"http://www.iqiyi.com/playlist268438002.html";
    url = @"http://www.iqiyi.com/playlist405588902.html";
    
    NSString *html = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:NULL];
    
    
    
    NSString *ul = [html componentsSeparatedByString:@"site-piclist site-piclist-180101 site-piclist-180101-twoLine clearfix"].lastObject;
    
    NSMutableArray *lis = (NSMutableArray *)[ul componentsSeparatedByString:@"</li>"];
    [lis removeLastObject];
    
    
    [lis enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *urlString = @"<a href=\"(.*?)\" target=\"_blank\"";
        NSString *url = [self matchString:obj toRegexString:urlString].lastObject;
        
        NSString *titleString = @"title=\"(.*?)\">";
        NSString *title = [self matchString:obj toRegexString:titleString].lastObject;

        NSString *imgString = @"src=\"(.*?)\" alt";
        NSString *img = [self matchString:obj toRegexString:imgString].lastObject;
        
        NSString *timeString = @"mod-listTitle_right\">(.*?)<\/span>";
        NSString *time = [self matchString:obj toRegexString:timeString].lastObject;
        //NSString *countString = @"1341729209>(.*?)<\/em>";
        //NSString *count = [self matchString:obj toRegexString:countString].lastObject;
        
        NSLog(@"@{@\"url\":@\"%@\",@\"title\":@\"%@\",@\"img\":@\"%@\",@\"time\":@\"%@\"},",url,title ,img,time);

//        NSLog(@"%s", __func__);
    }];
}

- (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr
{
    
    if(!string) return @[];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        
        for (int i = 0; i < [match numberOfRanges]; i++) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
            
            [array addObject:component];
            
        }
        
    }
    
    return array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
