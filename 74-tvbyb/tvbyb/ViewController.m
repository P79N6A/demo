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

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIView*v;
@property (nonatomic, weak) IBOutlet UIView*iv;

@end

@implementation ViewController


- (void)injected{
    NSLog(@"%s", __func__);
    self.iv.enabledEffect = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [LZData getTVBYBPage:2 block:^(NSArray<NSDictionary *> *obj) {
//        NSLog(@"%s", __func__);
//    }];
//
//    [LZData getTVBYBDetail:@"http://www.hktvyb.com/vod/detail/id/925.html" block:^(NSDictionary *obj) {
//        NSLog(@"%s", __func__);
//    }];
//
//    [LZData getTVBYBM3u8:@"http://www.hktvyb.com/vod/play/id/925/sid/1/nid/1.html" block:^(NSArray *obj) {
//
//    }];
    
    
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
    
    

    self.iv.enabledEffect = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
