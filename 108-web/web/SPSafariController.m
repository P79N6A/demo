//
//  SPSafariController.m
//  web
//
//  Created by Jay on 19/10/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPSafariController.h"
#import "PlayViewController.h"

#import <WebKit/WebKit.h>
#import <StoreKit/StoreKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "UIView+Layout.h"
#import "NSURLProtocol/NSURLProtocol+WKWebVIew.h"
#import "NSURLProtocol/HybridNSURLProtocol.h"

@interface SPSafariController ()<WKNavigationDelegate,WKUIDelegate,SKStoreProductViewControllerDelegate>
@property(nonatomic, readwrite) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *actionBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *vipBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *navigationCloseItem;


@property (nonatomic, strong) NSMutableArray <NSString *>*mediaObjs;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSMutableArray <NSDictionary *>*platformlist;
@property (nonatomic, assign) BOOL isBackAction;

@end

@implementation SPSafariController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"UserAgent": [self userAgent]}];
        self.mediaObjs = @[].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoCurrentDidChange:)
                                                 name:@"SPVipVideoCurrentDidChange"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemBecameCurrent:)
                                                 name:@"AVPlayerItemBecameCurrentNotification"
                                               object:nil];

    
    [self.view addSubview:self.webView];
    [self.webView setLyTop:nil];
    [self.webView setLyRight:nil];
    [self.webView setLyButtom:nil];
    [self.webView setLyleft:nil];
    
    
    
    [self.navigationController.view addSubview:self.progressView];
    [self.navigationController.view bringSubviewToFront:self.progressView];
    
    [self.progressView setLyleft:nil];
    [self.progressView setLyRight:nil];
     __weak typeof(self) weakSelf = self;
    [self.progressView setLyButtom:^(LayoutModel *__autoreleasing *layout) {
        (*layout).relativeToView = weakSelf.navigationController.navigationBar;
    }];
    [self.progressView setLyHeight:^(LayoutModel *__autoreleasing *layout) {
        (*layout).constant = 2;
    }];
    
    [self updateToolbarItems];
    
    [self loadData];
    [self initDefaultData];
    
    [self loadWebURL:self.platformlist.firstObject];
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



- (void)dealloc{

    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    
    [self.webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.webView.navigationDelegate = nil;
    self.webView.UIDelegate = nil;
}
//FIXME:  -  自定义方法
- (void)loadWebURL:(NSDictionary *)obj{
    [self loadURL:[NSURL URLWithString:obj[@"url"]]];
    [[NSUserDefaults standardUserDefaults] setObject:obj[@"adType"] forKey:@"adType"];
    [[NSUserDefaults standardUserDefaults] setObject:obj[@"mediaType"] forKey:@"mediaType"];
    [[NSUserDefaults standardUserDefaults] setObject:obj[@"reload"] forKey:@"reload"];
    self.isBackAction = ![obj[@"stop"] boolValue];
}
- (void)loadURL:(NSURL *)URL{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [self.webView loadRequest:request];
}
- (void)initDefaultData{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"kApi"];
    dict = dict? dict : [self mviplist];
    self.list = dict[@"list"];
    self.platformlist = ((NSArray *)dict[@"platformlist"]).mutableCopy;
}
- (void)loadData{
    
    
    NSString *url = [NSString stringWithFormat:@"%@?r=%d&t=%f&d=%f",@"https://czljcb.gitee.io/v2/api/pingshu/viplist.json",rand(),[[NSDate date] timeIntervalSince1970],[[NSDate date] timeIntervalSince1970]*[[NSDate date] timeIntervalSince1970]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:15.0];

    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        id respones = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![respones isKindOfClass:[NSDictionary class]] || error) return ;
            self.list = respones[@"list"];
            self.platformlist = ((NSArray *)respones[@"platformlist"]).mutableCopy;
            [self loadWebURL:self.platformlist.firstObject];
            [[NSUserDefaults standardUserDefaults] setObject:respones forKey:@"kApi"];
        });
        
        
    }];
    //开启网络任务
    [task resume];
    
}


//FIXME:  -  通知
- (void)playerItemBecameCurrent:(NSNotification *)notification{
    AVPlayerItem *playerItem = [notification object];
    if(playerItem == nil) return;
    if ([playerItem isKindOfClass:[AVPlayerItem class]])
    {
        // Break down the AVPlayerItem to get to the path
        AVURLAsset *asset = (AVURLAsset*)[playerItem asset];
        if(CMTimeGetSeconds(asset.duration) < 180) return;
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
        //[self.mediaCountButton setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)self.mediaObjs.count] forState:UIControlStateNormal];
        //self.mediaCountButton.hidden = !self.mediaObjs.count;
        
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

        [self loadURL:[NSURL URLWithString:finalUrl]];

    }];
    
}

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

- (void)toNativePlay:(NSString *)url{
    
    if([[self topViewController] isKindOfClass:[PlayViewController class]]) return ;
    
    
    PlayViewController *playVC = [[PlayViewController alloc] init];
    NSArray *tltles = [self.navigationItem.title componentsSeparatedByString:@"-"];
    if (tltles.count<2) {
        tltles = [self.navigationItem.title componentsSeparatedByString:@"_"];
    }
    playVC.title = tltles.firstObject;
    playVC.url = url;
    
    [self.navigationController pushViewController:playVC animated:YES];
    
    if(self.isBackAction) [self.webView goBack];
}


#pragma mark - Actions
- (void)backButtonClicked:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)goBackClicked:(UIBarButtonItem *)sender {

    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self backButtonClicked:nil];
    }
}
- (void)goForwardClicked:(UIBarButtonItem *)sender {

    if ([self.webView canGoForward]) {
       [self.webView goForward];
    }
}
- (void)reloadClicked:(UIBarButtonItem *)sender {

    [self.webView reload];
}
- (void)stopClicked:(UIBarButtonItem *)sender {
    [self.webView stopLoading];
}

- (void)listButtonClicked:(id)sender {
    UIAlertController *YYCAlertVC = [UIAlertController alertControllerWithTitle:@"视频平台" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self.platformlist enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *title = [obj valueForKey:@"name"];
        
        UIAlertAction *YYCDone = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self loadWebURL:obj];
        }];
        
        [YYCAlertVC addAction:YYCDone];
    }];
    
    UIAlertAction *YYCCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [YYCAlertVC addAction:YYCCancel];
    
    UIPopoverPresentationController *YYCPopover = YYCAlertVC.popoverPresentationController;
    if (YYCPopover) {
        YYCPopover.sourceView = self.progressView;
        YYCPopover.sourceRect = self.progressView.bounds;
        [self presentViewController:YYCAlertVC animated:YES completion:nil];
    }else {
        [self presentViewController:YYCAlertVC animated:YES completion:nil];
    }
}

- (void)vipButtonClicked:(id)sender{
    [self toNativePlay:@"https://cdn.youku-letv.com/20181022/m4MlVDnt/index.m3u8"];
    return;
    UIAlertController *YYCAlertVC = [UIAlertController alertControllerWithTitle:@"接口切换" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self.list enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *title = [obj valueForKey:@"name"];
        
        UIAlertAction *YYCDone = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self vipVideoCurrentApiDidChange:obj];
        }];
        
        [YYCAlertVC addAction:YYCDone];
    }];
    
    UIAlertAction *YYCCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [YYCAlertVC addAction:YYCCancel];
    
    UIPopoverPresentationController *YYCPopover = YYCAlertVC.popoverPresentationController;
    if (YYCPopover) {
        YYCPopover.sourceView = self.progressView;
        YYCPopover.sourceRect = self.progressView.bounds;
        [self presentViewController:YYCAlertVC animated:YES completion:nil];
    }else {
        [self presentViewController:YYCAlertVC animated:YES completion:nil];
    }
}

- (void)failLoadWithError:(NSError *)error{
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
     
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.progressView.progress >= 1.0) {
            self.progressView.hidden = YES;
            self.progressView.progress = 0;
        }
        
    }else if ([keyPath isEqualToString:@"title"]) {
        self.navigationItem.title = change[@"new"];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        if (navigationAction.request) {
            [webView loadRequest:navigationAction.request];
        }
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    // Get host name of url.
    NSString *host = webView.URL.host;
    // Init the alert view controller.
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:host?:@"messages" message:message preferredStyle: UIAlertControllerStyleAlert];
    // Init the cancel action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completionHandler != NULL) {
            completionHandler();
        }
    }];
    // Init the ok action.
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        if (completionHandler != NULL) {
            completionHandler();
        }
    }];
    
    // Add actions.
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:NULL];
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    // Get the host name.
    NSString *host = webView.URL.host;
    // Initialize alert view controller.
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:host?:@"messages" message:message preferredStyle:UIAlertControllerStyleAlert];
    // Initialize cancel action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        if (completionHandler != NULL) {
            completionHandler(NO);
        }
    }];
    // Initialize ok action.
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        if (completionHandler != NULL) {
            completionHandler(YES);
        }
    }];
    // Add actions.
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:NULL];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSString *host = webView.URL.host;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:prompt?:@"messages" message:host preferredStyle:UIAlertControllerStyleAlert];
    // Add text field.
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText?:@"input";
        textField.font = [UIFont systemFontOfSize:12];
    }];
    // Initialize cancel action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        // Get inputed string.
        NSString *string = [alert.textFields firstObject].text;
        if (completionHandler != NULL) {
            completionHandler(string?:defaultText);
        }
    }];
    // Initialize ok action.
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        // Get inputed string.
        NSString *string = [alert.textFields firstObject].text;
        if (completionHandler != NULL) {
            completionHandler(string?:defaultText);
        }
    }];
    // Add actions.
    [alert addAction:cancelAction];
    [alert addAction:okAction];
}

#pragma mark - 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

//    // Disable all the '_blank' target in page's target.
//    if (!navigationAction.targetFrame.isMainFrame) {
//        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
//    }
//    NSURLComponents *components = [[NSURLComponents alloc] initWithString:navigationAction.request.URL.absoluteString];
//    // For appstore and system defines. This action will jump to AppStore app or the system apps.
//    if ([[NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] 'https://itunes.apple.com/' OR SELF BEGINSWITH[cd] 'mailto:' OR SELF BEGINSWITH[cd] 'tel:' OR SELF BEGINSWITH[cd] 'telprompt:'"] evaluateWithObject:components.URL.absoluteString]) {
//        
//        if ([[NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] 'https://itunes.apple.com/'"] evaluateWithObject:components.URL.absoluteString]) {
//            SKStoreProductViewController *productVC = [[SKStoreProductViewController alloc] init];
//            productVC.delegate = self;
//            NSError *error;
//            NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"id[1-9]\\d*" options:NSRegularExpressionCaseInsensitive error:&error];
//            NSTextCheckingResult *result = [regex firstMatchInString:components.URL.absoluteString options:NSMatchingReportCompletion range:NSMakeRange(0, components.URL.absoluteString.length)];
//            
//            if (!error && result) {
//                NSRange range = NSMakeRange(result.range.location+2, result.range.length-2);
//                [productVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: @([[components.URL.absoluteString substringWithRange:range] integerValue])} completionBlock:^(BOOL result, NSError * _Nullable error) {
//                }];
//                [self presentViewController:productVC animated:YES completion:NULL];
//                decisionHandler(WKNavigationActionPolicyCancel);
//                return;
//            }
//        }
//        if ([[UIApplication sharedApplication] canOpenURL:components.URL]) {
//            if (@available(iOS 10.0, *)) {
//                [UIApplication.sharedApplication openURL:components.URL options:@{} completionHandler:NULL];
//            } else {
//                // Fallback on earlier versions
//                [[UIApplication sharedApplication] openURL:components.URL];
//            }
//        }
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    } else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES[cd] 'https' OR SELF MATCHES[cd] 'http' OR SELF MATCHES[cd] 'file' OR SELF MATCHES[cd] 'about'"] evaluateWithObject:components.scheme]) {// For any other schema but not `https`、`http` and `file`.
//        if ([[UIApplication sharedApplication] canOpenURL:components.URL]) {
//            if (@available(iOS 10.0, *)) {
//                [UIApplication.sharedApplication openURL:components.URL options:@{} completionHandler:NULL];
//            } else {
//                // Fallback on earlier versions
//                [[UIApplication sharedApplication] openURL:components.URL];
//            }
//        }
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }

    [self updateToolbarItems];

    // Call the decision handler to allow to load web page.
    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark - 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [self didFinishLoad];
}

#pragma mark - 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [self didStartLoad];
}
#pragma mark - 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    if (error.code == NSURLErrorCancelled) {
        [webView goBack];
        return;
    }
    [self didFailLoadWithError:error];
    [self failLoadWithError:error];
}

- (void)didStartLoad
{
    self.navigationItem.title = @"加载中...";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self updateToolbarItems];
    self.progressView.hidden = NO;
    self.progressView.progress = 0;
}

- (void)didFinishLoad{
    
    [self updateToolbarItems];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    NSString *JsStr = @"(document.getElementsByTagName(\"video\")[0]).src";
    [self.webView evaluateJavaScript:JsStr completionHandler:^(NSString * response, NSError * _Nullable error) {
        if(![response isEqual:[NSNull null]] && response.length > 0){
            //截获到视频地址了
            NSLog(@"通过webView截获到视频地址 == %@",response);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self videoCurrentDidChange:[NSNotification notificationWithName:@"SPVipVideoCurrentDidChange" object:nil userInfo:@{@"url":response}]];
            });
        }else{
            //没有视频链接
        }
    }];
}

- (void)updateToolbarItems
{
    self.backBarButtonItem.enabled = self.webView.canGoBack;
    self.forwardBarButtonItem.enabled = self.webView.canGoForward;
    //self.actionBarButtonItem.enabled = !self.webView.isLoading;

    UIBarButtonItem *refreshStopBarButtonItem = self.webView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        fixedSpace.width = 35.0f;

        //NSArray *items = [NSArray arrayWithObjects:fixedSpace, refreshStopBarButtonItem, fixedSpace, self.backBarButtonItem, fixedSpace, self.forwardBarButtonItem, fixedSpace, self.actionBarButtonItem, nil];
        NSArray *items = [NSArray arrayWithObjects:self.backBarButtonItem, fixedSpace,refreshStopBarButtonItem, fixedSpace, self.forwardBarButtonItem, fixedSpace, self.actionBarButtonItem, nil];

        self.navigationItem.leftBarButtonItems = items;
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: self.navigationCloseItem, fixedSpace, self.actionBarButtonItem,fixedSpace, self.vipBarButtonItem, nil];
        
        
    } else {
        self.navigationItem.leftBarButtonItem = self.navigationCloseItem;
        
        self.navigationController.toolbarHidden = NO;
        NSArray *items = [NSArray arrayWithObjects: fixedSpace, self.backBarButtonItem,flexibleSpace, refreshStopBarButtonItem, flexibleSpace, self.forwardBarButtonItem, flexibleSpace,self.vipBarButtonItem, flexibleSpace, self.actionBarButtonItem, fixedSpace, nil];

        self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.navigationController.toolbar.barTintColor = self.navigationController.navigationBar.barTintColor;
        self.toolbarItems = items;
    }
}

#pragma mark - Getters
- (WKWebView *)webView{
    if (!_webView) {
        // 设置WKWebView基本配置信息
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = [[WKPreferences alloc] init];
        
        configuration.allowsInlineMediaPlayback = YES;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
        
        configuration.selectionGranularity = YES;
        
        if (@available(iOS 9.0, *)) {
            configuration.requiresUserActionForMediaPlayback = NO;//解决弹不出
        } else {
            // Fallback on earlier versions
            configuration.mediaPlaybackRequiresUserAction = NO;
        }//把手动播放设置NO ios(8.0, 9.0)
        
        
        if (@available(iOS 9.0, *)) {
            configuration.allowsAirPlayForMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
            configuration.mediaPlaybackAllowsAirPlay = YES;
        }//允许播放，ios(8.0, 9.0)


        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.allowsBackForwardNavigationGestures = YES;/**这一步是，开启侧滑返回上一历史界面**/

        // 设置代理
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;

        // 添加进度监听
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:(NSKeyValueObservingOptionNew) context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

    }
    return _webView;
}

- (UIProgressView *)progressView
{
    if (_progressView) return _progressView;
    _progressView = [[UIProgressView alloc] init];
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    return _progressView;
}

- (UIBarButtonItem *)backBarButtonItem
{
    if (_backBarButtonItem) return _backBarButtonItem;
    _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LYWebViewControllerBack"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClicked:)];
    _backBarButtonItem.width = 18.0f;
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem
{
    if (_forwardBarButtonItem) return _forwardBarButtonItem;
    _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LYWebViewControllerNext"] style:UIBarButtonItemStylePlain target:self action:@selector(goForwardClicked:)];
    _forwardBarButtonItem.width = 18.0f;
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem
{
    if (_refreshBarButtonItem) return _refreshBarButtonItem;
    _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadClicked:)];
    _refreshBarButtonItem.width = 18.0f;

    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem
{
    if (_stopBarButtonItem) return _stopBarButtonItem;
    _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopClicked:)];
    _stopBarButtonItem.width = 18.0f;

    return _stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem
{
    if (_actionBarButtonItem) return _actionBarButtonItem;
    _actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(listButtonClicked:)];
    _actionBarButtonItem.width = 18.0f;
    return _actionBarButtonItem;
}


- (UIBarButtonItem *)vipBarButtonItem{
    if (_vipBarButtonItem) return _vipBarButtonItem;
    _vipBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(vipButtonClicked:)];
    _vipBarButtonItem.width = 18.0f;
    return _vipBarButtonItem;
}


- (UIBarButtonItem *)navigationCloseItem{
    if (_navigationCloseItem) return _navigationCloseItem;
    
    _navigationCloseItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backButtonClicked:)];
    _navigationCloseItem.width = 18.0f;
    return _navigationCloseItem;
}

////////////
- (void)didFailLoadWithError:(NSError *)error{
    if (error.code == NSURLErrorCannotFindHost) {// 404
        
        
        NSString *html = [NSString stringWithFormat:@"<!doctype html><html><head><meta charset=\"utf-8\"><meta name=\"viewport\"content=\"width=device-width,initial-scale=1,user-scalable=0\"><style type=\"text/css\">*{margin:0px;padding:0px;font-family:\"PingFang\"}body li{list-style-type:none}body a{text-decoration:none}img{border:0px}a:focus{outline:none}a{blr:expression(this.onFocus=this.blur())}.img404{width:8rem;overflow:hidden;margin:5rem auto 1rem}.img404 img{width:100%%}.detail404,.detail_neor{text-align:center;font-size:12px;color:#cecece}.btn404,.detail_neor_btn{text-align:center;color:#646464;font-size:12px;border:1px solid#cecece;width:8rem;margin:0.6rem auto;padding:0.3rem 0 0.3rem;border-radius:3px;-webkit-border-radius:3px;-moz-border-radius:3px}.neterror{width:4rem;overflow:hidden;margin:6rem auto 1rem}.neterror img{width:100%%}</style><title>404</title><script>(function(doc,win){var docEl=doc.documentElement,resizeEvt='orientationchange'in window?'orientationchange':'resize',recalc=function(){var clientWidth=docEl.clientWidth;if(!clientWidth)return;docEl.style.fontSize=20*(clientWidth/320)+'px'};if(!doc.addEventListener)return;win.addEventListener(resizeEvt,recalc,false);doc.addEventListener('DOMContentLoaded',recalc,false)})(document,window);</script></head></head><body><div class=\"img404\"><img src='data:image/png;base64,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'/></div><p class=\"detail404\">Not Found</p><p class=\"btn404\"onClick=\"location='%@'\">点击重试</p></body></html>",error.userInfo[@"NSErrorFailingURLStringKey"]];
        
        [self.webView loadHTMLString:html baseURL:nil];
    } else {
        NSString *html = [NSString stringWithFormat:@"<!doctype html><html><head><meta charset=\"utf-8\"><meta name=\"viewport\"content=\"width=device-width,initial-scale=1,user-scalable=0\"><style type=\"text/css\">*{margin:0px;padding:0px;font-family:\"PingFang\"}body li{list-style-type:none}body a{text-decoration:none}img{border:0px}a:focus{outline:none}a{blr:expression(this.onFocus=this.blur())}.img404{width:8rem;overflow:hidden;margin:5rem auto 1rem}.img404 img{width:100%%}.detail404,.detail_neor{text-align:center;font-size:12px;color:#cecece}.btn404,.detail_neor_btn{text-align:center;color:#646464;font-size:12px;border:1px solid#cecece;width:8rem;margin:0.6rem auto;padding:0.3rem 0 0.3rem;border-radius:3px;-webkit-border-radius:3px;-moz-border-radius:3px}.neterror{width:4rem;overflow:hidden;margin:6rem auto 1rem}.neterror img{width:100%%}</style><title>网络错误</title><script>(function(doc,win){var docEl=doc.documentElement,resizeEvt='orientationchange'in window?'orientationchange':'resize',recalc=function(){var clientWidth=docEl.clientWidth;if(!clientWidth)return;docEl.style.fontSize=20*(clientWidth/320)+'px'};if(!doc.addEventListener)return;win.addEventListener(resizeEvt,recalc,false);doc.addEventListener('DOMContentLoaded',recalc,false)})(document,window);</script></head></head><body><div class=\"neterror\"><img src='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAYwAAAFTCAMAAAAdj8uCAAAAjVBMVEUAAADOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7LyVyIAAAALnRSTlMA+QoDD9Fx9do/FY8tgqjxBjE4G7UfUInJnOjgJ+25a2CilbBHv2XkXH1WeEvEyI9oHAAAFkZJREFUeNrs2s1yqkAUBOAWMKAgTgwGYikaTVJJJen3f7zL3c0sIszfhjrfA7Ciz/RMHVhT9Q5i1K5WiC65sYcY1fOWIDLVk5RojNqRbBSiUjeSEo1xPQc3hYjSmqREY1owBnWKeK4kJRpTgzG4IpovkhKN6cEYfCGSC0mJhk0wBhdE8UZSomEXjMEbIjhuSYmGbTDI7RHBZQUp0bAPBllkCCztabpA/OFCU58irJKmb4g/fdNUIqhPmjYQd2xo+kRAVU7DC8RdLzTkVbzDu0kh7kqbaIf4Kw3LBGJEsqThNVI7OOwhRu0PUdrnMaduITeMSXYL6vIjAlBLuWCEGChLBX+tFKkwlaqFtxUNnRzekyUdDSt4SsxWe5LD28L+ZPbbJOwzyA+EhR8ayqBDqoTw+ZdXfkNKbnsh735FEqxJLSoIS9WCujbYlx4grD0E+p/TX+oaCAcNdb8p3HyYrXYN4WBt9tsP16/IM0j4Z5FTBhdXGVIxBtUVDh6p2z5BOHraUvcIe+/UneFIYTYUHJ2pe4e1Z+q6FG7OLWajPcNN2lH3DEuqoK5yfpzJZ1PC1rnz01xFXaG8klV6rITOJhqtx6pm6TPzM6PWHjL3rZLZRGOde2x5ZAePersJsoNVk5xNNFr+VwfZAtxY/gWazqNEzCYa/8i5ot1GgRiYXZZbCmmTCHEom4RrVN1F6QH//3n3cC+x2i7LDKoUx++tFMOMPfaY0nNtpajhs1JSLWE435lx1AONdvwfZkdY05EiXItp7Qu+C9EDjdKzO4kXMb2tMWCYBj/G1AONlm4tGwNBo5Z/hh+d6YFG6fnDsAqCRiuGUlgi3WUcFUFDpOTisAe6ESlBWqkraODS5Xxb5OdcgYZKaIxgF3CVDHc/LdwOC7g8bJitNexJ7r15V0lQMH6vg3R58Pvwk02Sajww2lG+RwpCYr2loJEsH7OCB8bRyKqjIgTjmyMPjSKbt8cIlj9KH5TcnEmvTEdAI32vMdAHxvJ5ejVW6caLTPJHycOszffGQY//IK0pakJYlw4QabjNnG34ni9TV7XfGOn4UtjO0CvuFoqmxCYHKknqA1F5LDvm9l+4eLnnhWal+KsWf/mh3T69WS2EC4EeTuZ3L70jx6amob0JRVTZ8HR/Vif3vkzQmS88T6mZ7OkHf16pizNNHX1ihqyXAhGIt1scK5hJRXc9bysgxIjD24hfmp2E7NR/B+lZCAV6JvKapL5NyQIjqLwAdIGFRmlSVHhD2xDWSrX3lzp8TVsTmhTp/MSWt0LJgDDK+WeiJYsL+Vx0wEA0D3Hp9JryYieruTzCMZR0rh4AGCsJjYoW8sfpPqFGapt/BGBIaHiH9MfTPWfBqu8fDwEMAQ1QAXRTBWHH+s6zg/5W6mNDdchYT/p6gqW8JRd8J5UaQxhomKmR9RM8lbMio9Muvj9/cTtWauQTReUn2deauzfXzhDRDcIi8WbpF8tSz5rsnFOxJ1nA+qiBqiNZKgv8caztV98cveXPV0OG8FSM6JwhWaoXZ+dQ1DlgR6HCbXJwzP9blHCOp4yL5NJb8lG/Yz7ECwB5uhBfMG/gO0kk1keeZkUNhiWywhZC/kk4tYDAXEwniFO3QbzZ3LKhisjvP6QOqjBcINWQ71BRbFQLJqyINLY1wqFk+S7/kXemW2oCQRRmUxQUEXFQcRmJcYvT7/94OflnuwTnfh40J/e/C3R31a1bS5egiBEcjD8oI+DCBR9Z98Y/Ydv3CH7em7wgXOyjMdYTuH0nd1XVBPLmFZyGlMD6Xlj3mrzgkft3KcAM9eDb2fMI6L1NHo0+014jK5PNuvRn96SMgc/+2BJcNdHk0QgG8FKQJduA/uCOpLKHwwi3iFoEJb3pjN8YVgbsoeHowv0dqaUNvzei90wsUqcBpAt6L0gEd3D7zq93GDH1XELzNsZCq+c0gl7LWNgQOu96jBx3bq/xTBFaCLHwduYcPxpLS3k/zDl2nsCnkJw3u2lPTlALqQjl7tvWosHcuT+1fRUJriqoiJwAybNRnhkZ0M/RfN36GowPspOjpfMsQp+zKGNO2gATcDXmky+aTEiD3pxFGvkt4xWmLBbtgj+kjGPkF6WCjdhlQXgaXrlqHksmIGJcvviylJ4L4lU/vDxWXLc4wW7jmc63s5dfltImRyNnLLS44cEPLEk3B+9z+fK5FtYUihys5JylCw83KNaYuYwh6Odo3Ejx/zBkTmNshRRX8feAuYyFrwshlfMiVLoo4i+Y0xhcxeApzFl15GMeue8wVDIK9eq73HqbKD+aXp3TWHgWvauj/R4zJQvd6f1iMnp8ZSGPrPp8o0cZnfdoUx658v7usgmr+yvq1LcdMNGWvO/x2nfwGH9QyezWY3mY4dXHE+FtniGXhan49VTKoYa6hXIani3GcLlrp3IRfwYqSp6LiVU5K/LB3TMk1hAtbiBT7ex9Gp22lp1Sg6wAmZXQYkMamerKz1GAAsknI3BVWpex1vn4go0NWYtqW94arTcanrdUHV/AtLXPC/J0BGtLjOaoxr4BMElnBFwmsSvHi609RkFkLm+Kl89CGsnmIUfyxdg6WBbJdn2knxdqyrNFSm6ybTFNkmmxzUiJT0tN/RZIRfddO9TKEbMN5C1VWrxBQ7Bdhmd8ZLmViUCsvoUto1OlbVha6JwNVY8zwp1OzrhyzQXcauzgTqSRavWHyMq3bDszbfAhPqjL8ArX3IBbeNRpfDS4qaaWlfPBEGNbtnRVSWvnCMhKcwdl5gjYqSKTa4nWZDy270QsDq5UN5yzurm2+QvarKIsV11/xWL/yOmxHtpcfYYSyZ2x+StiJD6X4A2Qju2elY7IECWcqnrlnq8FX429ql1PEUXPrITInsV8C9HjDAkJWZlarAgtHIpWf8Givr3TRtmMVPU4R/CzmWtq4WYgtXBUrX6KMhrtc1sZMka4EVnYDlyWYgNdNrITWdGGcfTw3HfGSv6XH+5KTywV5iEUeoKpUq3+ENXWxMj/2NtiLHKQROkhqIc7lsu/ctXqbyADSoAaAjjIRGY+lXkQlczQJoAXAj0kcZYo+FqpAXipxv1BaB5EGKixcKmG4CsUbC7Py9LXKJrfNfMEW/MwtmBfaZ7/gJqnvmA0X4juP5Xltdw8jFyWPFPRBRdQTyqf9lVqTehJ6PapgdKFdRIrNZ+3nUtLrUSH7KdKQboikaxHpiYmxoILtgy9qF4PkNgpaJ0sPvk038An+Eua/ozk54GwGCBc4E/eN99An/0lHqDwxQBHtNHIvR4V+EuaqYaLAZROsBhdtRlubb6Btdqa2EWLIVN1xzKxaDFUP9x7j8XoKZ6fL8ZnzWKI6tr/aqamNToKWgyRY8fyNnwPB24dVlHUav2TJ0OWOvfmG9g3IkBX73IyVJ8RqK9saL6BobrMwYt8Rvg0NqUKhQdtzGI9Br6oebpAhQC6d8jiDF2AL9U6xh/mYfxQa/tKWQSHccaCySHqrviq/SB3Gnv1kH8pH+RyyELL8vCiobW6D73Bw1bKU8/qmpWO6TmtzrMq+3Zy93jE6xF4RUIkd3TPnlXJ2LHIKazbVVM5G3nUxzXkYSQbLd0FK8dtYqzprrwXrqdPHPllaoC/tQd7E2XNd424wIcaSaeuvAnSjnkArVR+Ka6vRu4fiI+unRjFj5lMXib6lKreI+WdPX1y1ESmdxnSMGLngCoKR7Lbq2oiZUhv96A0spKpyAhVFB6cFRjDZnuvRH6hv2irDG+X+SUvZGJxGDKMbWVZfa/BYc/jmhGmaDXa6DKMERj7TKrQP6zzOUdJcDcVzqc6OuQYmrsIj2h4SMdRmUjORp8OnYjV7cay6Y9Zjeq8dZdHzVnNcCw7m5hVjkeOE6IGy5UswW/gXSB+e3BTBGn78DaWjSyBr1AKPLxw52wSyVS4UJOMOAoOM3OB2UH7Jle+THWK5uBcktkl0rkiIycdcz78Kz2td2fq2PqU8uFfuZx4NhFSWpc24f9izewmEOw0Hos3PrX7cdxvn8ZgLJ7lv9SU5Y7Npq9sq79o1NoGLiByT8XciBaTe76F7XG67Jz19Ta6BBCRpyLWbzQp2CzV6MLjjJgH2ujG5sPOBL0M3kDX+iYsMuhexpoD5EcDIzsNb/Aek/F+c3duW2pCMRgObEBHccCFjorgqNRD1eb9H6+XbepMhfwBXH7X7XKAnXN28ikOBfD0kOeQCBuiVBZDcazU6mHoqCfcUK8uL4xNph//6z2tsCUBK/3Gg4LFhzRDry25QB4eanVa3YsKlkk4Nf5bnmDo8xJYWZFDOZ17E4GmCjNgadGFpf3DwTwQvgArozIwTXg3QfICGA2Fc5ue+heN5d+SnSocW8BkXO5rvUtspcie9Rn9qHer8YHUQdbg0onF/VEcYxb8xvoKql/yH0JHneNC/kPp62u1fMPs9/jeBHsptoCaJ8ia3TN1zpmBP37B2BLq1Lt/9jnW30AzQHOOBsAWaBz/JNreAGs5I6y3Zv6F6ruCESzHiGhMCKXLX48ZzCBcvzK2O+wDZ8ioxiCRM6IgoP3XSYCMrcwwlbL7qnSYONA7LFPF8QDOAsSMgYahtAT9cpeIkjVuNHAH1c9l1AUBxJy5DznFsMnAR3Hdf0yukFttnAfUGUHOyI3Giu9fJjxuDC69ysXW3ghw9Ttd2LdnJMgZMdu9tf03Eheg/lQEVFi6TFH9YEbqahHqSwXf6HYfSk/Jjbm8dsAdBeZTQJ0QnJiBuyluLbQBZLFkxCj7dRRUUGIgS+R7UQGdgCSDkkAVEdal852eKR2abttgaq70qQP8ElMzGzTF6URjCDbfR5LmjFRF3FL4+zqA+GbpkEoE5ykJ0ClPIejPLLCFCbEHCAYsGl6MLY1YgL5cCA+olRSM9d38VAgGyBWIrYLkgSaAxuEWYBBOGyweTUNAMEDRCFMs57AhMPwuHkyOwkz4KW0uWh4gGJBoeAU1JT09MN/glKqJZiW29LuxaUmfgGBAovGJzSXitep15f9L3cdoEBwx2JJWaRQcLhoV2PbGERr+xxbbTSXBABTdYK1InUL4OfM6AFSyWEZgudk2Epd3VFoQzO9PPY6oUyL2pkD9RlhY9bWt6EF+aUsK5nC+76gQDFA0jnCGcU4Kto/yWjMwI0w7VDQopo6JCRWMHYHZ89nDulesejJ+gm5NBYhg4G/q8rCmOyYNFfffrakAEYwKvSpVpnX+iYIp996t2T4fimmtimNfiKgNFo3Q0QviQlQwZMxY1FrbjovGmV6QMyoYMqQ71GpdecPLZ+uUXo50jRcl34T5rlMieifcoYro5YikK4We2Dyt13o6x2ONMqAXIyhljIEGx5OaXR5jbffqs1y1b4Mx453B47pdJSvRIA/XX72CXorCQ6ut8hLEqrbOnxgIckVt4N7qEZMxlYESntS3OQe4ZSYCkiLGmxPXJDBOhERwi9Chwe9FBs7fMCUAdNdPQZakQ4Mni5qc1FA0yWv4aN29XXIN7H88Msj2+HmTwPqCP8vsQeMkyojrsiFDZBPqDP+glxr1XVg0Cq/d1tkL18XzyY53Az/Rz5v1CRzxTssJgxek8cWJ9v7DjQ2ugl4bzmVMT7D35gsbvvbJlpxrMyYA+2cKyqa9ZUf8ANy4xTg85voM24m9+YarjGPjrqBBZqBfeUqWXLkBc7JhygZ2MBsIi9G49rEiFaPywWIRgAM34EgmpKGIvUekYqWo3rkhnCWmrcLcKSawPqRqI8zckopC1XJ5NnDVN225tx/chCQ1c2vxV6Krgoa4rZongHhBS6glb+ZOQzLHvZpQkRFDskvbluK+NTdiYR7xbQ0yWz+0EhWRjlkrglFwM0IyIYatUKRWdFPG3dtR2YZgfHJDRraikY8MMltTfcrhHUwgxGTIjBtythWNm4ELsFPEJ3CGZ28vGP6AG7IzzRPuDepSgwzZ2jr0SYUfmgvGD25K6QxFI9S+iSG0AdY/GbgkxcA6hT7mxkztRGNQGASNJx+rGnixvvQQkyUhN+anXYLyov2vHjrf7CDnOegY2wpGxs35RUa8j0mHE+PW8c95JR0uI0uOrCAgGzIH5JlRJbN4vna0d67HU10UEWXohcV4rOUz3LZwCStYUa+4pclosw9pB/vnjTWcqFd+Cim1aWf0ptQ7E1YRU49MPaPyynyAhH72LLkuT3NPRIR7g7lZE92eembEOjbUH3u7U+GWz+SWnFnQcS8bbnaXztAtKzPqlR0ruVFPZKVpeHAVwayjPsm5Ac9wg8r9ejD5HlJUC+qRKWsZUj8s2DhSi71nMRtXVjMnENxgeLH5tYSkoN44sJpP6oEikZ6UveILfeqJwGM1FXWPH7ZhbucDoCHNUuj1DH6zd69LiQNBGIYbTYhEIBgUQfYAi4iy8N3/5e1Pq93a5TAzne6pfm7AKmAimXnpTEjcGPx2L5KVivvZBQIMSFofvAiNZqxhrNcSAZ5J2CtSXU4K9kI0Q+rAN4QoSdawwSc2IjT23vWyJnl9BJmSpHqZ8iLJv+MfJyTuEUFWJGhyBLv1TvtarEnaTQ9BxiRojbQPH6x3mv4hQqplC98Fwa6m6Npep19w7xGoJSl9vn+f5A/3wexJ1B0CfZCQvcgx44a/4wcS9IRQc5Jx6IlsxBT801kNSM4bghUkYVDxzfuCuETbkGhaErNBsD0JaBtIbXLPEPBuxKzXtLZsbSMYM47AVFOSMQCjtWWbNmBGlNSmmx2fERi1LVspeopSlJ0cwpZg1LZs7DpeFpTY00sHC6NGDFtKjU8VfKLkHir5hfEORnHL9rk0qgcSMDt/YXRer8m3bKXwJ7UvvTBuXxBANhaeSe/d3Z+7MDqv1zpo2UrphnEs27N9IBKJ6GsmfXoy2YqeKh/BKG/ZSmA7IUE3c8GFUSCWRxIww/yGRBULEjMDo75lW2T3DJd/12u2Wrbc7MCYatlyMwRjqmXLTh+MpZYtPz/AGGrZ8vO1XjPUsuXnFTE1Gkag2HUPxk7LlqM7RDUiF6teM9OyZeknIqvJRarXjLRseZpUiGxNrsN6jXshd6VnRKdgopxRJaL7TS5GvWamZcvSCvH1cj6IS2mMEywOHTbq9jsYOy1bhlqksCQXXq9ZatnycwRjqmXLTQHOVMuWmz3SqLofJG7PAvFoGF9m2g4nWBs6bNgQjLds11BZr3nLpqhe497IBdZr3rJ15oCvvGXrzC/8xX+ocSml9Zq3bIrqNW/ZNNVr3rIpqte4d3Kh9Zq3bBdQXK95y6apXvOWTVG95i3blaZI7UgusF7zlu1syus1b9kU1WuqHqBvR4v/8JbtfGqGCnvLFsccJxgZOpyDGhcx+AB9Q/Y4wczQ4Qz8ae8OUhAIYiCK9l5wKTp7ERFy/+O5nkWSFlunCv47x0/qFhVatr/aokHL1nCo1zQG9K284iNuA/pe7lGjZet41GvHD+ibuUSLlq3kUq/Rsq2fxKdlawlM4nOoMYZPvUbLtn4Sn5at4lKv0bL97qmw0YC+oVNMoWXLGdVre8+Bb+s1WraazCS+4oC+p3PMomVLCU3i07IZ1Wt7j4E19ZrJgL6pa0yiZUu41Wu0bGsn8WnZcmKT+HoD+o62mEbLltKaxKdlc6rXNFu2N0zkH0s4zoVyAAAAAElFTkSuQmCC'/></div><p class=\"detail_neor\">网络出错啦，请点击按钮重新加载</p><p class=\"detail_neor_btn\"onClick=\"location='%@'\">重新加载</p></body></html>",error.userInfo[@"NSErrorFailingURLStringKey"]];
        
        [self.webView loadHTMLString:html baseURL:nil];
    }
    
    self.navigationItem.title = @"load failed";
    [self updateToolbarItems];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.progressView setProgress:0.9 animated:YES];
}

- (NSString *)userAgent{
    
    
    NSArray *userAgents = @[
                            @"Mozilla/5.0 (Linux; Android 4.4.4; HTC D820u Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.89 Mobile Safari/537.36",
                            @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-cn; HTC_D820u Build/KTU84P) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30",
                            @"Mozilla/5.0 (Linux; Android 4.4.4; HTC D820u Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari/537.36 ACHEETAHI/2100501044",
                            @"Mozilla/5.0 (Linux; Android 4.4.4; HTC D820u Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari/537.36 bdbrowser_i18n/4.6.0.7",
                            @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-CN; HTC D820u Build/KTU84P) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 UCBrowser/10.1.0.527 U3/0.8.0 Mobile Safari/534.30",
                            @"Mozilla/5.0 (Android; Mobile; rv:35.0) Gecko/35.0 Firefox/35.0",
                            @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-cn; HTC D820u Build/KTU84P) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30 SogouMSE,SogouMobileBrowser/3.5.1",
                            @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-CN; HTC D820u Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Oupeng/10.2.3.88150 Mobile Safari/537.36",
                            @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-cn; HTC D820u Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko)Version/4.0 MQQBrowser/5.6 Mobile Safari/537.36",
                            @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-cn; HTC D820u Build/KTU84P) AppleWebKit/534.24 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.24 T5/2.0 baidubrowser/5.3.4.0 (Baidu; P1 4.4.4)",
                            @"Mozilla/5.0 (Linux; U; Android 4.4.4; zh-cn; HTC D820u Build/KTU84P) AppleWebKit/535.19 (KHTML, like Gecko) Version/4.0 LieBaoFast/2.28.1 Mobile Safari/535.19",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12A365 Safari/600.1.4",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X; zh-CN) AppleWebKit/537.51.1 (KHTML, like Gecko) Mobile/12A365 UCBrowser/10.2.5.551 Mobile",
                            @"Mozilla/5.0 (iPhone 5SGLOBAL; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/6.0 MQQBrowser/5.6 Mobile/12A365 Safari/8536.25",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/7.0 Mobile/12A365 Safari/9537.53",

                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4.9 (KHTML, like Gecko) Version/6.0 Mobile/10A523 Safari/8536.25",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_4 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Mercury/8.9.4 Mobile/11B554a Safari/9537.53",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12A365 SogouMobileBrowser/3.5.1",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 7_1 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D167 Safari/9537.53",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Coast/4.01.88243 Mobile/12A365 Safari/7534.48.3",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) CriOS/40.0.2214.69 Mobile/12A365 Safari/600.1.4",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_2 like Mac OS X) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.0 Mobile/14F89 Safari/602.1",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 11_1_1 like Mac OS X) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.0 Mobile/15F89 Safari/602.1",
                            @"Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1",
                            ];
    
    NSInteger index = arc4random() % userAgents.count;
    return  userAgents[index];
}

- (id)mviplist{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:[self jsonstring] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
}

- (NSString *)jsonstring{
    return @"ewogICAgInBsYXRmb3JtbGlzdCI6WwogICAgICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICAic3RvcCI6dHJ1ZSwKICAgICAgICAgICAgICAgICAgICAibmFtZSI6IlZpZGVvIiwKICAgICAgICAgICAgICAgICAgICAidXJsIjoiaHR0cDovL3d3dy5pcWl5aS5jb20iLAogICAgICAgICAgICAgICAgICAgICJyZWxvYWQiOnsKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgImxvZ28ucG5nIjoiaHR0cHM6Ly9pLmxvbGkubmV0LzIwMTgvMDkvMTEvNWI5NzdmNDUwMDVhYi5wbmciCiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9LAogICAgICAgICAgICAgICAgICAgICJhZFR5cGUiOlsKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgImltZy4wOW1rLmNuIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgImltZy54aWFvaHVpMi5jbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICIueGlhb2h1aSIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICIuYXBwbGUuY29tIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgImltZzIuIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgInN5c2Fwci5jbiIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF0sCiAgICAgICAgICAgICAgICAgICAgIm1lZGlhVHlwZSI6WwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiLm0zdTgiCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF0KCiAgICAgICAgICAgICAgICAgICAgfSwKICAgICAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgIm5hbWUiOiJUViIsCiAgICAgICAgICAgICAgICAgICAgInVybCI6Imh0dHA6Ly9iZGRuLmNuL3piLmh0bSIsCiAgICAgICAgICAgICAgICAgICAgInJlbG9hZCI6ewogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAibG9nby5wbmciOiJodHRwczovL2kubG9saS5uZXQvMjAxOC8wOS8xMS81Yjk3N2I0OWExMzU1LnBuZyIKICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICAgICAgICAgImFkVHlwZSI6WwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAic2F1Z2VpLmpzIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgInMxMy5jbnp6LmNvbSIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJpbWcud3NmLWd6LmNuIiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgInhsc3NjaGluYTE1Lm5ldCIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICIyaGlwLmNuIgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICBdLAogICAgICAgICAgICAgICAgICAgICJtZWRpYVR5cGUiOlsKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIi5tM3U4IiwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIi5tcDQiLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAid2lmaSIKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXQogICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgIF0sCiAgICAKICAgICJsaXN0IjogWwogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAi5Y6f5Zyw5Z2AIiwKICAgICAgICAgICAgICJ1cmwiOiAiIgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIum7mOiupOino+aekOaOpeWPoyIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cubGFuemh1emhpYm8uY29tL2ppZXhpLz91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIueUteinhuWPsOWPiuinhumikea1geaSreaUvuaOpeWPoyIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cubGFuemh1emhpYm8uY29tL2ppZXhpMS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLohb7orq/kvJjphbfnrYnlhajnvZFWaXDop4bpopHmkq3mlL7mjqXlj6MiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vd3d3LmxhbnpodXpoaWJvLmNvbS9qaWV4aS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICJodHRwOi8veS5tdDJ0LmNvbS9saW5lcz91cmw9IiwKICAgICAgICAgICAgICJ1cmwiOiAi5LqM5Y+36Kej5p6Q5o6l5Y+jIgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuWbm+WPt+ino+aekOaOpeWPoyIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9qcWFhYS5jb20vangucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAi5LqU5Y+36Kej5p6Q5o6l5Y+jIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2FwaS42NjI4MjAuY29tL3huZmx2L2luZGV4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuWFreWPt+ino+aekOaOpeWPoyIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9hcGkueGZzdWIuY29tL2luZGV4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuS4g+WPt+ino+aekOaOpeWPoyIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9qaWV4aS45MmZ6LmNuL3BsYXllci92aXAucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAi5YWr5Y+36Kej5p6Q5o6l5Y+jIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL3d3dy42NjI4MjAuY29tL3huZmx2L2luZGV4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuS4h+iDveaOpeWPozUiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vangudmdvb2RhcGkuY29tL2p4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIjXmnIgtOCIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9hcGkudmlzYW9rLm5ldC8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTkiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vYXBpLnh5aW5neXUuY29tLz91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIjXmnIgtMTAiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vYXBpLmdyZWF0Y2hpbmE1Ni5jb20vP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0xMSIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9qeC42MThnLmNvbS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTEyIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2FwaS5iYWl5dWcudmlwL2luZGV4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0xNCIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9hcGkueHlpbmd5dS5jb20vP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0xNSIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9hcGkuZ3JlYXRjaGluYTU2LmNvbS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTE2IiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2FwaS5iYWl5dWcudmlwL2luZGV4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIjXmnIgtMTciLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vYXBpLnZpc2Fvay5uZXQvP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0xOCIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9qeC42MThnLmNvbS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTIwIiwKICAgICAgICAgICAgICJ1cmwiOiAiaGh0dHA6Ly9hcGkuYmFpeXVnLmNuL3ZpcC8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTIxIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2ppZXhpLjA3MTgxMS5jYy9qeDIucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0yMiIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cuODIxOTA1NTUuY29tL2luZGV4L3Fxdm9kLnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0yNCIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cuODIxOTA1NTUuY29tL2luZGV4L3Fxdm9kLnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIjQuMjEtMiIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9xdHYuc29zaGFuZS5jb20va28ucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNC4yMS0zIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cHM6Ly95b29vbW0uY29tL2luZGV4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIjQuMjEtNCIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cuODIxOTA1NTUuY29tL2luZGV4LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiI0LjIxLTYiLAogICAgICAgICAgICAgInVybCI6Imh0dHA6Ly93d3cuODUxMDUwNTIuY29tL2FkbWluLnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjoi6auY56uv6Kej5p6QIiwKICAgICAgICAgICAgICJ1cmwiIDoiaHR0cDovL2p4LnZnb29kYXBpLmNvbS9qeC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6IuWFreWFreinhumikSIsCiAgICAgICAgICAgICAidXJsIjoiaHR0cDovL3F0di5zb3NoYW5lLmNvbS9rby5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICAKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIui2hea4heaOpeWPozFfMCIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cuNTJqaWV4aS5jb20vdG9uZy5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLotoXmuIXmjqXlj6MxXzEiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vd3d3LjUyamlleGkuY29tL3l1bi5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLotoXmuIXmjqXlj6MyIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2ppZXhpLjkyZnouY24vcGxheWVyL3ZpcC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6IuWTgeS8mOino+aekCIsCiAgICAgICAgICAgICAidXJsIjoiaHR0cDovL2FwaS5wdWNtcy5jb20veG5mbHYvP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiLml6DlkI3lsI/nq5kiLAogICAgICAgICAgICAgInVybCI6Imh0dHA6Ly93d3cuODIxOTA1NTUuY29tL2luZGV4L3Fxdm9kLnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuiFvuiur+WPr+eUqO+8jOeZvuWfn+mYgeinhumikSIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9hcGkuYmFpeXVnLmNuL3ZpcC9pbmRleC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLohb7orq/lj6/nlKjvvIznur/ot6/kuIko5LqR6Kej5p6QKSIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9qaWV4aS45MmZ6LmNuL3BsYXllci92aXAucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAi6IW+6K6v5Y+v55So77yM6YeR5qGl6Kej5p6QIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2pxYWFhLmNvbS9qeC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLnur/ot6/lm5vvvIjohb7orq/mmoLkuI3lj6/nlKjvvIkiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vYXBpLm5lcGlhbi5jb20vY2twYXJzZS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLnur/ot6/kupQiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vYWlrYW4tdHYuY29tLz91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuiKseWbreW9seinhu+8iOWPr+iDveaXoOaViO+8iSIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9qLnp6MjJ4LmNvbS9qeC8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLoirHlm63lvbHop4YxIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2ouODhnYy5uZXQvangvP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAi57q/6Lev5LiAKOS5kOS5kOinhumikeino+aekCkiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vd3d3LjY2MjgyMC5jb20veG5mbHYvaW5kZXgucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiIxNzE3dHkiLAogICAgICAgICAgICAgInVybCI6Imh0dHA6Ly8xNzE3dHkuZHVhcHAuY29tL2p4L3R5LnBocD91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjoi6YCf5bqm54mbIiwKICAgICAgICAgICAgICJ1cmwiOiJodHRwOi8vYXBpLndsemhhbi5jb20vc3VkdS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6IjEiLAogICAgICAgICAgICAgInVybCI6Imh0dHA6Ly8xN2t5dW4uY29tL2FwaS5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6IjYiLAogICAgICAgICAgICAgInVybCI6Imh0dHA6Ly8wMTQ2NzAuY24vangvdHkucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiI4IiwKICAgICAgICAgICAgICJ1cmwiOiJodHRwOi8vdHYueC05OS5jbi9hcGkvd25hcGkucGhwP2lkPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6IjEwIiwKICAgICAgICAgICAgICJ1cmwiOiJodHRwOi8vN2N5ZC5jb20vdmlwLz91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuihqOWTpeino+aekCIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9qeC5iaWFvZ2UudHYvaW5kZXgucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAi5LiH6IO95o6l5Y+jMyIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly92aXAuamxzcHJoLmNvbS9pbmRleC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICLkuIfog73mjqXlj6M0IiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cHM6Ly9hcGkuZGFpZGFpdHYuY29tL2luZGV4Lz91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIuS4h+iDveaOpeWPozYiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vd3d3aGUxLjE3N2tkeS5jbi80LnBocD9wYXNzPTEmdXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTUiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vd3d3LmNrcGxheWVyLnR2L2t1a3UvP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC02IiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2FwaS5sdmNoYTIwMTcuY24vP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC03IiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL3d3dy5ha3R2Lm1lbi8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTEzIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2p4LnJlY2xvc2UuY24vangucGhwLz91cmw9IgogICAgICAgICAgICAgfSwKICAgICAgICAgICAgIHsKICAgICAgICAgICAgICJuYW1lIjogIjXmnIgtMTkiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8veXVuLmJhaXl1Zy5jbi92aXAvP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0yMyIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly9hcGkuYmFpeXVnLmNuL3ZpcC9pbmRleC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTI1IiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovLzJndHkuY29tL2FwaXVybC95dW4ucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0yNiIsCiAgICAgICAgICAgICAidXJsIjogImh0dHA6Ly92LjJndHkuY29tL2FwaXVybC95dW4ucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNC4yMS01IiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2ppZXhpLjkyZnouY24vcGxheWVyL3ZpcC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6IueIsei3n+W9semZoiIsCiAgICAgICAgICAgICAidXJsIjoiaHR0cDovLzJndHkuY29tL2FwaXVybC95dW4ucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0xIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL3d3dy44MjE5MDU1NS5jb20vaW5kZXgvcXF2b2QucGhwP3VybD0iCiAgICAgICAgICAgICB9LAogICAgICAgICAgICAgewogICAgICAgICAgICAgIm5hbWUiOiAiNeaciC0yIiwKICAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL2ppZXhpLjkyZnouY24vcGxheWVyL3ZpcC5waHA/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTMiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vYXBpLndsemhhbi5jb20vc3VkdS8/dXJsPSIKICAgICAgICAgICAgIH0sCiAgICAgICAgICAgICB7CiAgICAgICAgICAgICAibmFtZSI6ICI15pyILTQiLAogICAgICAgICAgICAgInVybCI6ICJodHRwOi8vYmVhYWNjLmNvbS9hcGkucGhwP3VybD0iCiAgICAgICAgICAgICB9CiAgICAgICAgICAgICBdCn0KCg==";
}

@end
