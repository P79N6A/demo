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
