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
#import <MediaPlayer/MediaPlayer.h>

#import "ListCell.h"

@implementation ListController
- (void)viewDidLoad{
    [super viewDidLoad];
    UIToolbar *bgBar = [[UIToolbar alloc] init];
    bgBar.barStyle = UIBarStyleBlack;
    
    self.tableView.backgroundView = bgBar;
    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    //1 去除掉自动布局添加的边距
    self.tableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    //2 去掉iOS7的separatorInset边距
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UIToolbar *titleView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.translucent = YES;
    titleView.barStyle = UIBarStyleBlack;
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    titleLB.text = @"自动嗅探列表";
    titleLB.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLB];
    titleLB.textColor = [UIColor whiteColor];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close)];
    //UIBarButtonItem *
    //UIToolbar *
    [titleView setItems:@[back]];
    
    self.tableView.tableHeaderView = titleView;
}

- (void)close{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mediaObjs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.tilteLB.text = self.mediaObjs[indexPath.row];
    cell.indexView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:NO completion:nil];
    !(_didSelectItemBlock)? : _didSelectItemBlock(self.mediaObjs[indexPath.row]);
}

@end

@interface ViewController ()<AXWebViewControllerDelegate>

@property (nonatomic, strong) NSString       *currentUrl;


@property (nonatomic, strong) UIButton       *leftButton;
@property (nonatomic, strong) UIButton       *rightButton;

@property (nonatomic, strong) UIButton       *mediaCountButton;
@property (nonatomic, strong) NSMutableArray <NSString *>*mediaObjs;

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSArray *platformlist;

@end


@implementation ViewController

- (UIButton *)leftButton{
    if (!_leftButton) {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setTitle:@"平台" forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
        leftButton.frame = CGRectMake(0, 0, 30, 44);
        [leftButton addTarget:self action:@selector(videosClicked:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton = leftButton;
    }
    return _leftButton;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setTitle:@"转换" forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        rightButton.frame = CGRectMake(0, 0, 30, 44);
        [rightButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(apiClicked:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton = rightButton;
    }
    return _rightButton;
}

- (UIButton *)mediaCountButton{
    if (!_mediaCountButton) {
        _mediaCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mediaCountButton.frame = CGRectMake(200, 300, 64, 64);
        _mediaCountButton.backgroundColor = [UIColor redColor];
        [_mediaCountButton addTarget:self action:@selector(mediaList:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mediaCountButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSURLProtocol registerClass:[HybridNSURLProtocol class]];
    
    self.mediaObjs = [NSMutableArray array];
    self.delegate = self;
    [self initDefaultData];
    [self loadURL:[NSURL URLWithString:self.platformlist.firstObject[@"url"]]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoCurrentDidChange:)
                                                 name:@"SPVipVideoCurrentDidChange"
                                               object:nil];
    
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
    [self.view addSubview:self.mediaCountButton];
    
    
    self.showsToolBar = YES;
    self.navigationType = AXWebViewControllerNavigationToolItem;
    self.maxAllowedTitleLength = 999;
    self.showsNavigationCloseBarButtonItem = YES;
    self.navigationCloseItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close)];
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

- (void)toNativePlay:(NSString *)url{
    
    if([[self topViewController] isKindOfClass:[MPMoviePlayerViewController class]]) return ;
    
    MPMoviePlayerViewController *playVC = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:url]];
    playVC.view.frame = CGRectMake(0, 100, 414, 300);
    [self presentViewController:playVC animated:YES completion:nil];
}

//FIXME:  -  事件监听

- (void)mediaList:(UIButton *)sender{
    NSLog(@"%s", __func__);
     __weak typeof(self) weakSelf = self;
    ListController *alertVC = [[ListController alloc] init];
    alertVC.mediaObjs = self.mediaObjs;
    alertVC.view.backgroundColor = [UIColor clearColor];
    alertVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    alertVC.didSelectItemBlock = ^(NSString *url) {
        [weakSelf toNativePlay:url];
    };
    [self presentViewController:alertVC animated:NO completion:nil ];
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
//FIXME:  -  通知
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
        [self videoCurrentDidChange:[NSNotification notificationWithName:@"SPVipVideoCurrentDidChange" object:nil userInfo:@{@"url":path}]];

        
        //        [self longGesture:nil];
    }
}
- (void)videoCurrentDidChange:(NSNotification *)notification{
    NSString *url = [notification.userInfo valueForKey:@"url"];
    if (![self.mediaObjs containsObject:url]) {
        [self.mediaObjs addObject:url];
        [self.mediaCountButton setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)self.mediaObjs.count] forState:UIControlStateNormal];
        
        [self toNativePlay:url];
    }
}
- (void)vipVideoCurrentApiDidChange:(NSString  *)vipURL{
    
    
    [self.webView evaluateJavaScript:@"document.location.href" completionHandler:^(NSString *url, NSError * _Nullable error) {
        
        NSString *originUrl = [[url componentsSeparatedByString:@"url="] lastObject];
        
        if (![url hasPrefix:@"http"]) {
            return ;
        }
        
        NSString *finalUrl = [NSString stringWithFormat:@"%@%@", vipURL,originUrl];
        
        [self loadURL:[NSURL URLWithString:finalUrl]];
    }];
    
}
- (void)windowVisible:(NSNotification *)notification
{
    
    NSLog(@"-windowVisible");
}

- (void)windowHidden:(NSNotification *)notification
{
    NSLog(@"-windowHidden");
}

//FIXME:  -  AXWebViewControllerDelegate
- (void)webViewController:(AXWebViewController *)webViewController didFailLoadWithError:(NSError *)error{
    NSLog(@"%s", __func__);
}
- (void)webViewControllerDidFinishLoad:(AXWebViewController *)webViewController{
    
    NSString *JsStr = @"(document.getElementsByTagName(\"video\")[0]).src";
    [self.webView evaluateJavaScript:JsStr completionHandler:^(NSString * response, NSError * _Nullable error) {
        if(![response isEqual:[NSNull null]] && response.length > 0){
            //截获到视频地址了
            NSLog(@"response == %@",response);
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSNotification *noti = [NSNotification notificationWithName:@"SPVipVideoCurrentDidChange" object:nil userInfo:@{@"url":response}];
                [self videoCurrentDidChange:[NSNotification notificationWithName:@"SPVipVideoCurrentDidChange" object:nil userInfo:@{@"url":response}]];
            });
        }else{
            //没有视频链接
        }
    }];
    
}


//FIXME:  -  自定义方法
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
        
    }
    return resultVC;
}
- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end


