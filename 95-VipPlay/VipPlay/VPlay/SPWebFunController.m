//
//  ViewController.m
//  VipPlay
//
//  Created by Jay on 24/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPWebFunController.h"
#import "HybridNSURLProtocol.h"
#import "NSURLProtocol+WKWebVIew.h"

#import "TJPlayController.h"

#import <FTPopOverMenu/FTPopOverMenu.h>
#import <AVFoundation/AVFoundation.h>
//#import <MediaPlayer/MediaPlayer.h>

#import "UIView+PulseView.h"



@interface SPWebFunController ()<AXWebViewControllerDelegate>

@property (nonatomic, strong) NSString       *currentUrl;


@property (nonatomic, strong) UIButton       *leftButton;
@property (nonatomic, strong) UIButton       *rightButton;

@property (nonatomic, strong) UIButton       *mediaCountButton;
@property (nonatomic, strong) NSMutableArray <NSString *>*mediaObjs;

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSMutableArray <NSDictionary *>*platformlist;


@property (nonatomic, assign) CGPoint startImageCenter;
@property (nonatomic, assign) CGPoint startGCenter;

@end


@implementation SPWebFunController


- (UIButton *)leftButton{
    if (!_leftButton) {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setImage:[UIImage imageNamed:@"web"] forState:UIControlStateNormal];
        leftButton.frame = CGRectMake(0, 0, 30, 44);
        [leftButton addTarget:self action:@selector(videosClicked:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton = leftButton;
    }
    return _leftButton;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:[UIImage imageNamed:@"vip"] forState:UIControlStateNormal];
        rightButton.frame = CGRectMake(0, 0, 30, 44);
        [rightButton addTarget:self action:@selector(apiClicked:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton = rightButton;
    }
    return _rightButton;
}

- (UIButton *)mediaCountButton{
    if (!_mediaCountButton) {
        _mediaCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mediaCountButton.frame = CGRectMake(200, 300, 40, 40);
        _mediaCountButton.backgroundColor = [UIColor redColor];
        [_mediaCountButton addTarget:self action:@selector(mediaList:) forControlEvents:UIControlEventTouchUpInside];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [_mediaCountButton addGestureRecognizer:pan];
        _mediaCountButton.layer.cornerRadius = 20;
        _mediaCountButton.layer.masksToBounds = YES;
        _mediaCountButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
        _mediaCountButton.hidden = !self.mediaObjs.count;
        _mediaCountButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];;
    }
    return _mediaCountButton;
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.mediaObjs.count) [self.mediaCountButton startPulseWithColor:[UIColor lightGrayColor] scaleFrom:1.0 to:1.2 frequency:1.0 opacity:0.5 animation:PulseViewAnimationTypeRegularPulsing];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.leftButton],[[UIBarButtonItem alloc] initWithCustomView:self.rightButton],fixedSpace,fixedSpace];
    }
    else {
        self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.leftButton],[[UIBarButtonItem alloc] initWithCustomView:self.rightButton]];
    }
}

- (void)dealloc{
    NSLog(@" webView dealloc ----");
    //    [NSURLProtocol unregisterClass:[HybridNSURLProtocol class]];
    //    [NSURLProtocol wk_unregisterScheme:@"http"];
    //    [NSURLProtocol wk_unregisterScheme:@"https"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [NSURLProtocol registerClass:[HybridNSURLProtocol class]];
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSURLProtocol unregisterClass:[HybridNSURLProtocol class]];
    [NSURLProtocol wk_unregisterScheme:@"http"];
    [NSURLProtocol wk_unregisterScheme:@"https"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.showsToolBar = YES;
    self.navigationType = AXWebViewControllerNavigationToolItem;
    self.maxAllowedTitleLength = 999;
    self.showsBackgroundLabel = NO;
    self.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    [self initDefaultData];
    
    [self loadWebURL:self.platformlist.firstObject];
    
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
    
    [self.view addSubview:self.mediaCountButton];
    
}

- (void)loadWebURL:(NSDictionary *)obj{
    [self loadURL:[NSURL URLWithString:obj[@"url"]]];
    [[NSUserDefaults standardUserDefaults] setObject:obj[@"adType"] forKey:@"adType"];
    [[NSUserDefaults standardUserDefaults] setObject:obj[@"mediaType"] forKey:@"mediaType"];
    [[NSUserDefaults standardUserDefaults] setObject:obj[@"reload"] forKey:@"reload"];
}

- (void)initDefaultData{
    self.mediaObjs = [NSMutableArray array];
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mviplist" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    NSDictionary *dict = [self mviplist];//[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    //NSLog(@"%@,error %@",dict, error);
    self.list = dict[@"list"];
    self.platformlist = ((NSArray *)dict[@"platformlist"]).mutableCopy;
    
}

- (void)toNativePlay:(NSString *)url{
    
    if([[self topViewController] isKindOfClass:[TJPlayController class]]) return ;
    
    TJPlayController *playVC = [[TJPlayController alloc] init];
    playVC.url = url;
    NSArray *tltles = [self.navigationItem.title componentsSeparatedByString:@"-"];
    if (tltles.count<2) {
        tltles = [self.navigationItem.title componentsSeparatedByString:@"_"];
    }
    playVC.title = tltles.firstObject;
    
    [self.navigationController pushViewController:playVC animated:YES];
    
    [self.webView goBack];
}


//FIXME:  -  事件监听
#pragma mark - 手势
- (void)handlePan:(UIPanGestureRecognizer *)recoginzer
{
    UIButton * imageView = (UIButton *)recoginzer.view;
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        //记录中心位置
        self.startImageCenter = imageView.center;
        self.startGCenter = [recoginzer locationInView:self.view];
        return;
    }
    
    //非开始阶段
    //获得手势移动的距离 现在的位置
    CGPoint nowGCenter = [recoginzer locationInView:self.view];
    float x = nowGCenter.x - self.startGCenter.x;
    float y = nowGCenter.y - self.startGCenter.y;
    
    CGFloat centerX = self.startImageCenter.x+x;
    CGFloat centerY = self.startImageCenter.y+y;
    if (centerX < 30) {
        centerX = 30;
    }
    if (centerX > self.view.bounds.size.width - 30) {
        centerX = self.view.bounds.size.width - 30;
    }
    if (centerY < 100) {
        centerY = 100;
    }
    if (centerY > self.view.bounds.size.height - 100) {
        centerY = self.view.bounds.size.height - 100;
    }
    //计算imageview的相对位移
    imageView.center = CGPointMake(centerX, centerY);
    [imageView startPulseWithColor:[UIColor lightGrayColor] scaleFrom:1.0 to:1.2 frequency:1.0 opacity:0.5 animation:PulseViewAnimationTypeRegularPulsing];
    
    //    if (pan.state == UIGestureRecognizerStateEnded) {
    //
    //        imageView.center = self.startImageCenter;
    //    }
    
    
    return;
    //    if (recoginzer.state != UIGestureRecognizerStateEnded && recoginzer.state != UIGestureRecognizerStateFailed) {
    //        CGPoint location = [recoginzer locationInView:recoginzer.view.superview];
    //        // x 27 w-27
    //
    //        //y 50  h - 86
    //        CGFloat x = location.x;
    //        CGFloat y = location.y;
    //
    //        if (x < 30) {
    //            x = 30;
    //        }
    //        if (x > self.view.bounds.size.width - 30) {
    //            x = self.view.bounds.size.width - 30;
    //        }
    //        if (y < 100) {
    //            y = 100;
    //        }
    //        if (y > self.view.bounds.size.height - 100) {
    //            y = self.view.bounds.size.width - 100;
    //        }
    //
    //        recoginzer.view.center = CGPointMake(x, y);
    //        [recoginzer.view startPulseWithColor:[UIColor lightGrayColor] scaleFrom:1.0 to:1.2 frequency:1.0 opacity:0.5 animation:PulseViewAnimationTypeRegularPulsing];
    //        NSLog(@"%s--%@", __func__,NSStringFromCGPoint(location));
    //    }
    
}

- (void)mediaList:(UIButton *)sender{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"自动嗅探列表" message:@"浏览所自动嗅探到的多媒体资源列表" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self.mediaObjs enumerateObjectsUsingBlock:^(NSString * url, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIAlertAction *name = [UIAlertAction actionWithTitle:url style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self toNativePlay:url];
        }];
        
        [alertVC addAction:name];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancel];
    
    UIPopoverPresentationController *popover = alertVC.popoverPresentationController;
    if (popover) {
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
        [self presentViewController:alertVC animated:YES completion:nil];
    }else {
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}
// 视频平台点击
- (void)videosClicked:(id)sender {
    
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuWidth = 100;
    configuration.textAlignment = NSTextAlignmentCenter;
    __weak typeof(self) weakSelf = self;
    [FTPopOverMenu showForSender:sender withMenuArray:[self.platformlist valueForKey:@"name"] doneBlock:^(NSInteger selectedIndex) {
        
        NSString *url = weakSelf.platformlist[selectedIndex][@"url"];
        if ([url isEqualToString:@"app://add"]) {
            [self showAlert];
            return ;
        }
        
        //[weakSelf loadURL:[NSURL URLWithString:url]];
        [weakSelf loadWebURL:weakSelf.platformlist[selectedIndex]];
    } dismissBlock:^{
        NSLog(@"user canceled. do nothing.");
    }];
}


- (void)showAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加视频平台" message:@"自定义嗅探视频平台" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"cannel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *name = alert.textFields.firstObject.text;
        NSString *url = alert.textFields.lastObject.text;
        [self.platformlist insertObject:@{@"name":name,@"url":url} atIndex:self.platformlist.count - 1];
    }]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入视频网站的名称";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入视频网站的网址";
    }];
    [self presentViewController:alert animated:YES completion:nil];
}
// 接口切换点击
- (void)apiClicked:(id)sender {
    
    
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuWidth = 150;
    configuration.textAlignment = NSTextAlignmentCenter;
    __weak typeof(self) weakSelf = self;
    [FTPopOverMenu showForSender:sender withMenuArray:[self.list valueForKey:@"name"] doneBlock:^(NSInteger selectedIndex) {
        [weakSelf vipVideoCurrentApiDidChange:weakSelf.list[selectedIndex]];
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
    }
}
- (void)videoCurrentDidChange:(NSNotification *)notification{
    NSString *url = [notification.userInfo valueForKey:@"url"];
    if (![self.mediaObjs containsObject:url]) {
        [self.mediaObjs insertObject:url atIndex:0];
        [self.mediaCountButton setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)self.mediaObjs.count] forState:UIControlStateNormal];
        self.mediaCountButton.hidden = !self.mediaObjs.count;
        
        [self toNativePlay:url];
    }
}
- (void)vipVideoCurrentApiDidChange:(NSDictionary  *)obj{
    
    
    [self.webView evaluateJavaScript:@"document.location.href" completionHandler:^(NSString *url, NSError * _Nullable error) {
        
        NSString *originUrl = [[url componentsSeparatedByString:@"url="] lastObject];
        
        if (![url hasPrefix:@"http"]) {
            return ;
        }
        
        NSString *finalUrl = [NSString stringWithFormat:@"%@%@", obj[@"url"],originUrl];
        NSMutableDictionary *objj = obj.mutableCopy;
        objj[@"url"] = finalUrl;
        //[self loadURL:[NSURL URLWithString:finalUrl]];
        [self loadWebURL:objj];
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
    NSLog(@"--webViewController加载出错--%@",error);
}
- (void)webViewControllerDidFinishLoad:(AXWebViewController *)webViewController{
    
    
    
    NSString *JsStr = @"(document.getElementsByTagName(\"video\")[0]).src";
    [self.webView evaluateJavaScript:JsStr completionHandler:^(NSString * response, NSError * _Nullable error) {
        if(![response isEqual:[NSNull null]] && response.length > 0){
            //截获到视频地址了
            NSLog(@"通过webView截获到视频地址 == %@",response);
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


- (id)mviplist{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:[self jsonstring] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
}

- (NSString *)jsonstring{
    return @"ewogICAgInBsYXRmb3JtbGlzdCI6WwogICAgICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICAibmFtZSI6IueIseWlh+iJuiIsCiAgICAgICAgICAgICAgICAgICAgInVybDEiOiJodHRwOi8vd3d3LmlxaXlpLmNvbSIsCiAgICAgICAgICAgICAgICAgICAgInVybCI6Imh0dHBzOi8vY2RuLnp5cGJvLmNvbS8yMDE4MDgwNy91dkRXWnNKMi9pbmRleC5tM3U4IgogICAgICAgICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgICJuYW1lIjoi5riv5YmnVFYiLAogICAgICAgICAgICAgICAgICAgICJ1cmwiOiJodHRwczovL20uZHNtaS5jYy8iLAogICAgICAgICAgICAgICAgICAgICJzZXBUeXBlIjoidj0iLAogICAgICAgICAgICAgICAgICAgICJhZFR5cGUiOlsKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgInNhdWdlaS5qcyIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJzMTMuY256ei5jb20iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiaW1nLndzZi1nei5jbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJ4bHNzY2hpbmExNS5uZXQiLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiMmhpcC5jbiIKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXSwKICAgICAgICAgICAgICAgICAgICAibWVkaWFUeXBlIjpbCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICIubTN1OCIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICIubXA0IgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBdCiAgICAgICAgICAgICAgICAgICAgfSwKICAgICAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgIm5hbWUiOiLml6XliadUViIsCiAgICAgICAgICAgICAgICAgICAgInVybCI6Imh0dHBzOi8vbS5yaWp1dHYuY29tL3JpanUiLAogICAgICAgICAgICAgICAgICAgICJzZXBUeXBlIjoidj0iLAogICAgICAgICAgICAgICAgICAgICJhZFR5cGUiOlsKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgInNhdWdlaS5qcyIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJzMTMuY256ei5jb20iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiaW1nLndzZi1nei5jbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJ4bHNzY2hpbmExNS5uZXQiLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiMmhpcC5jbiIKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXSwKICAgICAgICAgICAgICAgICAgICAibWVkaWFUeXBlIjpbCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICIubTN1OCIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICIubXA0IgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBdCiAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgfSwKICAgICAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgIm5hbWUiOiJUViIsCiAgICAgICAgICAgICAgICAgICAgInVybCI6Imh0dHA6Ly9iZGRuLmNuL3piLmh0bSIsCiAgICAgICAgICAgICAgICAgICAgInNlcFR5cGUiOiJ1cmw9IiwKICAgICAgICAgICAgICAgICAgICAiYWRUeXBlIjpbCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJzYXVnZWkuanMiLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiczEzLmNuenouY29tIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgImltZy53c2YtZ3ouY24iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAieGxzc2NoaW5hMTUubmV0IiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIjJoaXAuY24iCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF0sCiAgICAgICAgICAgICAgICAgICAgIm1lZGlhVHlwZSI6WwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiLm0zdTgiLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiLm1wNCIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJ3aWZpIgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBdCiAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgICAgIF0sCiAgICAKICAgICJsaXN0IjogWwogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAi5Y6f5Zyw5Z2AIiwKICAgICAgICAgICAgICJ1cmwiOiAiIgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIum7mOiupOino+aekOaOpeWPoyIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cubGFuemh1emhpYm8uY29tL2ppZXhpLz91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIueUteinhuWPsOWPiuinhumikea1geaSreaUvuaOpeWPoyIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cubGFuemh1emhpYm8uY29tL2ppZXhpMS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLohb7orq/kvJjphbfnrYnlhajnvZFWaXDop4bpopHmkq3mlL7mjqXlj6MiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vd3d3LmxhbnpodXpoaWJvLmNvbS9qaWV4aS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICJodHRwOi8veS5tdDJ0LmNvbS9saW5lcz91cmw9IiwKICAgICAgICAgICAgICJ1cmwiOiAi5LqM5Y+36Kej5p6Q5o6l5Y+jIgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuWbm+WPt+ino+aekOaOpeWPoyIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9qcWFhYS5jb20vangucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAi5LqU5Y+36Kej5p6Q5o6l5Y+jIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2FwaS42NjI4MjAuY29tL3huZmx2L2luZGV4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuWFreWPt+ino+aekOaOpeWPoyIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9hcGkueGZzdWIuY29tL2luZGV4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuS4g+WPt+ino+aekOaOpeWPoyIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9qaWV4aS45MmZ6LmNuL3BsYXllci92aXAucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAi5YWr5Y+36Kej5p6Q5o6l5Y+jIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL3d3dy42NjI4MjAuY29tL3huZmx2L2luZGV4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuS4h+iDveaOpeWPozUiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vangudmdvb2RhcGkuY29tL2p4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIjXmnIgtOCIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9hcGkudmlzYW9rLm5ldC8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTkiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vYXBpLnh5aW5neXUuY29tLz91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIjXmnIgtMTAiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vYXBpLmdyZWF0Y2hpbmE1Ni5jb20vP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0xMSIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9qeC42MThnLmNvbS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTEyIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2FwaS5iYWl5dWcudmlwL2luZGV4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0xNCIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9hcGkueHlpbmd5dS5jb20vP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0xNSIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9hcGkuZ3JlYXRjaGluYTU2LmNvbS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTE2IiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2FwaS5iYWl5dWcudmlwL2luZGV4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIjXmnIgtMTciLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vYXBpLnZpc2Fvay5uZXQvP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0xOCIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9qeC42MThnLmNvbS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTIwIiwKICAgICAgICAgICAgICJ1cmwiOiAiaGh0dHA6Ly9hcGkuYmFpeXVnLmNuL3ZpcC8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTIxIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2ppZXhpLjA3MTgxMS5jYy9qeDIucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0yMiIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cuODIxOTA1NTUuY29tL2luZGV4L3Fxdm9kLnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0yNCIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cuODIxOTA1NTUuY29tL2luZGV4L3Fxdm9kLnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIjQuMjEtMiIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9xdHYuc29zaGFuZS5jb20va28ucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNC4yMS0zIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cHM6Ly95b29vbW0uY29tL2luZGV4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIjQuMjEtNCIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cuODIxOTA1NTUuY29tL2luZGV4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiI0LjIxLTYiLAogICAgICAgICAgICAgInVybCI6Imh0dHA6Ly93d3cuODUxMDUwNTIuY29tL2FkbWluLnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjoi6auY56uv6Kej5p6QIiwKICAgICAgICAgICAgICJ1cmwiIDoiaHR0cDovL2p4LnZnb29kYXBpLmNvbS9qeC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6IuWFreWFreinhumikSIsCiAgICAgICAgICAgICAidXJsIjoiaHR0cDovL3F0di5zb3NoYW5lLmNvbS9rby5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICAKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIui2hea4heaOpeWPozFfMCIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cuNTJqaWV4aS5jb20vdG9uZy5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLotoXmuIXmjqXlj6MxXzEiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vd3d3LjUyamlleGkuY29tL3l1bi5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLotoXmuIXmjqXlj6MyIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2ppZXhpLjkyZnouY24vcGxheWVyL3ZpcC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6IuWTgeS8mOino+aekCIsCiAgICAgICAgICAgICAidXJsIjoiaHR0cDovL2FwaS5wdWNtcy5jb20veG5mbHYvP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiLml6DlkI3lsI/nq5kiLAogICAgICAgICAgICAgInVybCI6Imh0dHA6Ly93d3cuODIxOTA1NTUuY29tL2luZGV4L3Fxdm9kLnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuiFvuiur+WPr+eUqO+8jOeZvuWfn+mYgeinhumikSIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9hcGkuYmFpeXVnLmNuL3ZpcC9pbmRleC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLohb7orq/lj6/nlKjvvIznur/ot6/kuIko5LqR6Kej5p6QKSIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9qaWV4aS45MmZ6LmNuL3BsYXllci92aXAucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAi6IW+6K6v5Y+v55So77yM6YeR5qGl6Kej5p6QIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2pxYWFhLmNvbS9qeC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLnur/ot6/lm5vvvIjohb7orq/mmoLkuI3lj6/nlKjvvIkiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vYXBpLm5lcGlhbi5jb20vY2twYXJzZS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLnur/ot6/kupQiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vYWlrYW4tdHYuY29tLz91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuiKseWbreW9seinhu+8iOWPr+iDveaXoOaViO+8iSIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9qLnp6MjJ4LmNvbS9qeC8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLoirHlm63lvbHop4YxIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2ouODhnYy5uZXQvangvP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAi57q/6Lev5LiAKOS5kOS5kOinhumikeino+aekCkiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vd3d3LjY2MjgyMC5jb20veG5mbHYvaW5kZXgucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiIxNzE3dHkiLAogICAgICAgICAgICAgInVybCI6Imh0dHA6Ly8xNzE3dHkuZHVhcHAuY29tL2p4L3R5LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjoi6YCf5bqm54mbIiwKICAgICAgICAgICAgICJ1cmwiOiJodHRwOi8vYXBpLndsemhhbi5jb20vc3VkdS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6IjEiLAogICAgICAgICAgICAgInVybCI6Imh0dHA6Ly8xN2t5dW4uY29tL2FwaS5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6IjYiLAogICAgICAgICAgICAgInVybCI6Imh0dHA6Ly8wMTQ2NzAuY24vangvdHkucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiI4IiwKICAgICAgICAgICAgICJ1cmwiOiJodHRwOi8vdHYueC05OS5jbi9hcGkvd25hcGkucGhwP2lkPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6IjEwIiwKICAgICAgICAgICAgICJ1cmwiOiJodHRwOi8vN2N5ZC5jb20vdmlwLz91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuihqOWTpeino+aekCIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9qeC5iaWFvZ2UudHYvaW5kZXgucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAi5LiH6IO95o6l5Y+jMyIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly92aXAuamxzcHJoLmNvbS9pbmRleC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLkuIfog73mjqXlj6M0IiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cHM6Ly9hcGkuZGFpZGFpdHYuY29tL2luZGV4Lz91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuS4h+iDveaOpeWPozYiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vd3d3aGUxLjE3N2tkeS5jbi80LnBocD9wYXNzPTEmdXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTUiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vd3d3LmNrcGxheWVyLnR2L2t1a3UvP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC02IiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2FwaS5sdmNoYTIwMTcuY24vP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC03IiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL3d3dy5ha3R2Lm1lbi8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTEzIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2p4LnJlY2xvc2UuY24vangucGhwLz91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIjXmnIgtMTkiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8veXVuLmJhaXl1Zy5jbi92aXAvP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0yMyIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9hcGkuYmFpeXVnLmNuL3ZpcC9pbmRleC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTI1IiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovLzJndHkuY29tL2FwaXVybC95dW4ucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0yNiIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly92LjJndHkuY29tL2FwaXVybC95dW4ucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNC4yMS01IiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2ppZXhpLjkyZnouY24vcGxheWVyL3ZpcC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6IueIsei3n+W9semZoiIsCiAgICAgICAgICAgICAidXJsIjoiaHR0cDovLzJndHkuY29tL2FwaXVybC95dW4ucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0xIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL3d3dy44MjE5MDU1NS5jb20vaW5kZXgvcXF2b2QucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0yIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2ppZXhpLjkyZnouY24vcGxheWVyL3ZpcC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTMiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vYXBpLndsemhhbi5jb20vc3VkdS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTQiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vYmVhYWNjLmNvbS9hcGkucGhwP3VybD0iCiAgICAgICAgICAgICB9CiAgICAgICAgICAgICBdCn0=";
}

@end


