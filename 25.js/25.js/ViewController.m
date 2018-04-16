//
//  ViewController.m
//  25.js
//
//  Created by czljcb on 2017/12/7.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "ViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()
@property (nonatomic, strong) JSContext *JSCtx;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JSContext *JSCtx = [[JSContext alloc] init];
    self.JSCtx = JSCtx;
    
    JSCtx[@"play"] = ^() {
        NSArray *args = [JSContext currentArguments];
        NSLog(@"%s--%@", __func__,[args[0] toString]);
        // 在这里执行分享的操作...
    };
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    // 将分享结果返回给js
    //NSString *jsStr = [NSString stringWithFormat:@"share('%@','%@','%@')",@"22",@"44",@"4445"];
    
    NSString *jsStr = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://127.0.0.1/ishare/demo.js"] encoding:NSUTF8StringEncoding error:NULL];
    
    NSString *jsStr1 = [NSString stringWithFormat:@"%@ getLiveKey('%@')",jsStr,@"kds2://pptv@@id=gdty"];

    
    [self.JSCtx evaluateScript:jsStr1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
