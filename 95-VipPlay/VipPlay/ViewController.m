//
//  ViewController.m
//  VipPlay
//
//  Created by Jay on 24/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "HybridNSURLProtocol.h"
#import <FTPopOverMenu/FTPopOverMenu.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AXWebViewControllerDelegate>
@property (nonatomic, strong) NSString       *currentUrl;


@property (nonatomic, strong) UIButton       *leftButton;
@property (nonatomic, strong) UIButton       *rightButton;

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSArray *platformlist;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSURLProtocol registerClass:[HybridNSURLProtocol class]];

    // Do any additional setup after loading the view, typically from a nib.
    [self loadURL:[NSURL URLWithString:@"http://m.iqiyi.com"]];
    self.delegate = self;
    [self initDefaultData];
    
    if (!_leftButton) {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setTitle:@"平台" forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
        leftButton.frame = CGRectMake(0, 0, 30, 44);
        [leftButton addTarget:self action:@selector(videosClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftButton = leftButton;
    }
    
    if (!_rightButton) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setTitle:@"转换" forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        rightButton.frame = CGRectMake(0, 0, 30, 44);
        [rightButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(apiClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.rightButton = rightButton;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemBecameCurrent:)
                                                 name:@"AVPlayerItemBecameCurrentNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowVisible:)
                                                 name:UIWindowDidBecomeVisibleNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowHidden:)
                                                 name:UIWindowDidBecomeHiddenNotification
                                               object:self.view.window];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.leftButton],[[UIBarButtonItem alloc] initWithCustomView:self.rightButton]];
    
    
    
    self.showsToolBar = YES;
    self.navigationType = AXWebViewControllerNavigationToolItem;
    self.maxAllowedTitleLength = 999;

}

- (void)playerItemBecameCurrent:(NSNotification *)notification{
    AVPlayerItem *playerItem = [notification object];
    if(playerItem == nil) return;
    if ([playerItem isKindOfClass:[AVPlayerItem class]])
    {
        // Break down the AVPlayerItem to get to the path
        AVURLAsset *asset = (AVURLAsset*)[playerItem asset];
        NSURL *url = [asset URL];
        NSString *path = [url absoluteString];
        NSLog(@"bbbbbbb %@", path);
        
        
        //        [self longGesture:nil];
    }
}

// 视频平台点击
- (void)videosClicked:(id)sender {

    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuWidth = 100;
    configuration.textAlignment = NSTextAlignmentCenter;
     __weak typeof(self) weakSelf = self;
    [FTPopOverMenu showForSender:sender withMenuArray:[self.platformlist valueForKey:@"name"] doneBlock:^(NSInteger selectedIndex) {
        
            [weakSelf loadURL:[NSURL URLWithString:weakSelf.platformlist[selectedIndex][@"url"]]];
    } dismissBlock:^{
        NSLog(@"user canceled. do nothing.");
    }];
}

// 接口切换点击
- (void)apiClicked:(id)sender {

    
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuWidth = 150;
    configuration.textAlignment = NSTextAlignmentCenter;
 __weak typeof(self) weakSelf = self;
    [FTPopOverMenu showForSender:sender withMenuArray:[self.list valueForKey:@"name"] doneBlock:^(NSInteger selectedIndex) {
        [weakSelf vipVideoCurrentApiDidChange:weakSelf.list[selectedIndex][@"url"]];
    } dismissBlock:^{
        NSLog(@"user canceled. do nothing.");
    }];
}
- (void)initDefaultData{
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mviplist" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"%@,error %@",dict, error);
    self.list = dict[@"list"];
    self.platformlist = dict[@"platformlist"];

}

- (void)vipVideoCurrentApiDidChange:(NSString  *)vipURL{
    
#if 1//AX_WEB_VIEW_CONTROLLER_USING_WEBKIT
    [self.webView evaluateJavaScript:@"document.location.href" completionHandler:^(NSString *url, NSError * _Nullable error) {
        
        NSString *originUrl = [[url componentsSeparatedByString:@"url="] lastObject];
        
        if (![url hasPrefix:@"http"]) {
            return ;
        }
        
        NSString *finalUrl = [NSString stringWithFormat:@"%@%@", vipURL,originUrl];

        [self loadURL:[NSURL URLWithString:finalUrl]];
    }];
#else
    NSString *url =  [self.webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSString *originUrl = [[url componentsSeparatedByString:@"url="] lastObject];
    
    if (![url hasPrefix:@"http"]) {
        return ;
    }
    
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@", vipURL,originUrl];
    NSLog(@"finalUrl = %@", finalUrl);
//    [self loadURL:[NSURL URLWithString:finalUrl]];
#endif
    
    
}

- (void)windowVisible:(NSNotification *)notification
{
    //    UIViewController *viewController = [notification.object rootViewController];
    //    [viewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"-windowVisible");
}

- (void)windowHidden:(NSNotification *)notification
{
    NSLog(@"-windowHidden");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewController:(AXWebViewController *)webViewController didFailLoadWithError:(NSError *)error{
    NSLog(@"%s", __func__);
}

@end
