//
//  ViewController.m
//  tvbyb
//
//  Created by Jay on 31/5/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

#import "LZData.h"


#import "UIView+EffectView.h"
#import "TTViewController.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIView*v;
@property (nonatomic, weak) IBOutlet UIView*iv;

@end

@implementation ViewController


- (void)injected{
    NSLog(@"%s", __func__);
    self.iv.enabledEffect = NO;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    TTViewController *alertVC = [[TTViewController alloc] init];
//    alertVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
//    self.definesPresentationContext = YES; // 可以使用的Style // UIModalPresentationOverCurrentContext // UIModalPresentationOverFullScreen // UIModalPresentationCustom // 使用其他Style会黑屏
    alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:alertVC animated:NO completion:nil ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//
//    for (int i = 0; i < 100000; i ++) {
//
//
//    //1.确定请求路径
//    NSURLSession *session = [NSURLSession sharedSession];
//
//    //2,根据会话创建task
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://rotation.vod.bukayi.cn/channel/%d.m3u8",i]];
//    //3,创建可变的请求对象
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    //4,请求方法改为post
//    request.HTTPMethod = @"HEAD";
//    //5,设置请求体
//    request.HTTPBody = [@""dataUsingEncoding:NSUTF8StringEncoding];
//    //6根据会话创建一个task（发送请求）
//
//
//
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"i = type = %@",response.MIMEType);
//
//    }];
//
//    [dataTask resume];
//}

    // Do any additional setup after loading the view, typically from a nib.
    [LZData getTVBYBPage:2 block:^(NSArray<NSDictionary *> *obj) {
//        NSLog(@"%s--%@", __func__,obj);
    }];

    [LZData getTVBYBDetail:@"http://www.hktvyb.com/vod/detail/id/1379.html" block:^(NSDictionary *obj) {
        NSLog(@"%s--%@", __func__,obj);
    }];
//
    [LZData getTVBYBM3u8:@"http://www.hktvyb.com/vod/play/id/1379/sid/1/nid/1.html" block:^(NSArray *obj) {

    }];
    
    
//    UIBlurEffectStyleExtraLight,
//    UIBlurEffectStyleLight,
//    UIBlurEffectStyleDark,
//    UIBlurEffectStyleExtraDark __TVOS_AVAILABLE(10_0) __IOS_PROHIBITED __WATCHOS_PROHIBITED,
//    UIBlurEffectStyleRegular NS_ENUM_AVAILABLE_IOS(10_0), // Adapts to user interface style
//    UIBlurEffectStyleProminent NS_ENUM_AVAILABLE_IOS(10_0), // Adapts to user interface style
//
//    UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//
//    //这里一定要设置frame 不然不会显示效果
//
//    effectView.frame = self.iv.bounds;
//
//    [self.iv addSubview:effectView];
    
    

//    self.iv.enabledEffect = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
