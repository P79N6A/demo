//
//  ViewController.m
//  iCloud
//
//  Created by Jay on 6/9/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSUbiquitousKeyValueStore *keyStore;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //获取iCloud配置首选项
    self.keyStore = [NSUbiquitousKeyValueStore defaultStore];
    //注册通知中心，当配置发生改变的时候，发生通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(ubiquitousKeyValueStoreDidChange:)
                   name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                 object:self.keyStore];
    self.textLabel.text = [self.keyStore stringForKey:@"MyString"];


}

/* UI点击，点击改变按钮 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.keyStore setString:@"Hello World" forKey:@"MyString"];
    [self.keyStore synchronize];
    NSLog(@"Save key");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/* 监听通知，当配置发生改变的时候会调用 */
- (void)ubiquitousKeyValueStoreDidChange:(NSNotification *)notification
{
    NSLog(@"External Change detected");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Change detected"
                                                    message:@"Change detected"
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil, nil];
    [alert show];
    //显示改变的信息
    self.textLabel.text = [self.keyStore stringForKey:@"MyString"];
}


@end
