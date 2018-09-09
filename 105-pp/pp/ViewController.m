//
//  ViewController.m
//  pp
//
//  Created by xin on 2018/9/8.
//  Copyright © 2018年 HKDramaFan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self gangju];
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
-(NSString *)convertToJsonData:(id )dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}


- (void)gangju{
    NSInteger p = 1;
    NSString *listUrl = @"http://taobao.jszks.net/index.php/Gangju/gangju_shenhe/p/";
    listUrl = @"http://taobao.jszks.net/index.php/Riju/riju_shenhe/p/";
    listUrl = @"http://taobao.jszks.net/index.php/Dudu/hanjutv_shenhe/p/";
    listUrl = @"http://taobao.jszks.net/index.php/Dongman/dmhy/p/";
    listUrl = @"http://taobao.jszks.net/index.php/Taiju/taijutv/p/";
    listUrl = @"http://taobao.jszks.net/index.php/Meiju/meijutv/p/";

    NSString *durl = @"http://taobao.jszks.net/index.php/Gangju/gangjuxiangxi_shenhe?iid=";
            durl = @"http://taobao.jszks.net/index.php/Riju/rijuxiangxi_shenhe?iid=";
            durl = @"http://taobao.jszks.net/index.php/Dudu/hanjutvxiangxi_shenhe?iid=";
            durl = @"http://taobao.jszks.net/index.php/Dongman/dmhyxiangxi?iid=";
            durl = @"http://taobao.jszks.net/index.php/Taiju/taijutvxiangxi?iid=";
            durl = @"http://taobao.jszks.net/index.php/Meiju/meijutvxiangxi?iid=";

    
    NSString *url = [NSString stringWithFormat:@"%@%ld",listUrl,p];
    NSString *vlist = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:NULL];
    NSArray *objs = [self dictionaryWithJsonString:vlist][@"list"];
    NSMutableArray *jsons = [NSMutableArray array];
    while (objs.count) {
        [objs enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *v = obj.mutableCopy;
            NSString *url = [NSString stringWithFormat:@"%@%@",durl,v[@"id"]];
            NSString *list = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:NULL];
            
            NSArray *lists = [self dictionaryWithJsonString:list][@"list"];

            v[@"list"] = lists;
            [jsons addObject:v];
        }];
        p ++;
        url = [NSString stringWithFormat:@"%@%ld",listUrl,p];

        NSString *vlist = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:NULL];
        objs = [self dictionaryWithJsonString:vlist][@"list"];
    }
    NSString *json = [self convertToJsonData:jsons];
    NSLog(@"---%@",json);
}
@end
