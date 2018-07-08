//
//  ViewController.m
//  hanyutv
//
//  Created by Jayson on 2018/6/24.
//  Copyright © 2018年 Jayson. All rights reserved.
//

#import "ViewController.h"
#import "JJHtml.h"
@interface ViewController ()
@property (nonatomic, copy) void (^top) ();
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ViewController
- (IBAction)dismiss:(id)sender {
    
    [self presentViewController:[ViewController new] animated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
//
//    return;
//    self.top = ^{
//        self.view.backgroundColor = [UIColor redColor];
//    };
//    [JJHtml getHanYuTVPage:10 block:^(NSArray<NSDictionary *> *obj) {
//
//    }];
//
//    [JJHtml getHanYuTVDetail:@"https://m.y3600.com/411/453.html" block:^(NSDictionary *obj) {
//        NSLog(@"");
//    }];
//
//    self.top();
    
    [JJHtml getHKTVPage:1 urlStr:<#(NSString *)#> block:<#^(NSArray<NSDictionary *> *)block#>];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
