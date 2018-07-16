//
//  ViewController.m
//  js
//
//  Created by Jay on 6/7/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import "TaiJuHtml.h"

@interface ViewController ()
@property (nonatomic, strong) JSContext *jsContext;
@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
//
//    NSMutableArray  *jsons= [NSMutableArray array];
//
//    for (NSInteger i = 1; i < 8; i ++) {
//        NSString *url = [NSString stringWithFormat:@"http://taobao.jszks.net/index.php/Dudu/hanjutv/p/%ld",i];
//        NSString *json = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:NULL];
//        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
//        NSArray *list = [obj valueForKey:@"list"];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSString *Id = [obj valueForKey:@"id"];
//            NSString *urlId = [NSString stringWithFormat:@"http://taobao.jszks.net/index.php/Dudu/hanjutvxiangxi?iid=%@",Id];
//            NSString *tvjson = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlId] encoding:NSUTF8StringEncoding error:NULL];
//            NSDictionary *tvobj = [NSJSONSerialization JSONObjectWithData:[tvjson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
//            NSArray *tvlist = [tvobj valueForKey:@"list"];
//            dict[@"Id"] = Id;
//            dict[@"zhuti"] = [obj valueForKey:@"zhuti"];
//            dict[@"img"] = [obj valueForKey:@"img"];
//            dict[@"title"] = [obj valueForKey:@"title"];
//            dict[@"list"] = tvlist;
//
//            [jsons addObject:dict];
//        }];
//
//        NSLog(@"%s---%@", __func__,json);
//    }
//
//    NSData *data = [NSJSONSerialization dataWithJSONObject:jsons options:NSJSONWritingPrettyPrinted error:NULL];
//    [data writeToFile:@"/Users/jay/Desktop/hanjutv.json" options:NSDataWritingAtomic error:NULL];
//
//    NSString *txt =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%s", __func__);
//    return;
    
    [TaiJuHtml getTaiJuPageNo:1 completed:^(NSArray<NSDictionary *> *objs) {
        
    }];
    [TaiJuHtml getTaiJuDetail:@"http://www.97taiju.com/taiju/kuayueshenhai/" completed:^(NSDictionary *obj) {
        NSLog(@"%s", __func__);
    }];
    [TaiJuHtml taiJuM3u8:@"http://www.97taiju.com/taiju/kuayueshenhai/play-491-1-3.html#play" completed:^(NSArray *objs) {
        
    }];
    [TaiJuHtml taiJuSearch:@"我" pageNo:1 completed:^(NSArray<NSDictionary *> *objs) {
        
    }];
    
    return;
    // Do any additional setup after loading the view, typically from a nib.
    // 一个JSContext对象，就类似于Js中的window，
    // 只需要创建一次即可。
    self.jsContext = [[JSContext alloc] init];
    self.jsContext[@"log"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
    };

    //  jscontext可以直接执行JS代码。
    //[self.jsContext evaluateScript:@"var squareFunc = function() { return 20 * 2 }"];
    NSString *js = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://127.0.0.1/demo.js"] encoding:NSUTF8StringEncoding error:NULL];
    [self.jsContext evaluateScript:js];
    // 计算正方形的面积
    JSValue *square = [self.jsContext evaluateScript:@"squareFunc()"];
    
    // 也可以通过下标的方式获取到方法
    JSValue *squareFunc = self.jsContext[@"squareFunc"];
    JSValue *value = [squareFunc callWithArguments:@[@"20"]];
    NSLog(@"%@", square.toNumber);
    NSLog(@"%@", value.toNumber);
    
    
    
    //[self.jsContext evaluateScript:@"log('ider', [7, 21], { hello:'world', js:100 });"];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
