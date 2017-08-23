//
//  ViewController.m
//  extension
//
//  Created by czljcb on 2017/6/28.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Extension.h"
#import "NSObject+Extension.h"
#import "UIAlertController+Extension.h"
#import "WELCustomStatusbarColor.h"
#import "UIImage+Blur.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *im;
@property (weak, nonatomic) IBOutlet UITextField *tf;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    
//    [UIImage imageWithCircleBorder:2.0 borderColor:[UIColor redColor] image:nil];
//    
//    [self perform:^{
//        NSLog(@"%s", __func__);
//    }];
//    
    UIImage *im = [UIImage imageNamed:@"31"];
    self.im.image = [im blurWithFuzzy:2 density:0];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"444" message:@"主要更新:\n- 焕然一新的文章列表页,带给你全新的阅读体验\n- 支持删除专题了,强迫症福音\n- 支持移除粉丝\n- 文章支持和保存 gif 图片了\n\n其他更新:\n- 去掉发现页好友喜欢的文章模块\n- 搜索新增热门专题\n- 坚信支持转发给好友\n- 去掉分享文章带的用户名和简书后缀,只保留文章标题" preferredStyle:UIAlertControllerStyleAlert];
//    alert.messageLabel.textAlignment = NSTextAlignmentLeft;
//    [self presentViewController:alert animated:YES completion:nil];
//    
//    [self.tf becomeFirstResponder];
 
//    [UIAlertController showAlertViewWithTitle:@"ee" Message:@"dd" BtnTitles:@[@"vv"] ClickBtn:^(NSInteger index) {
//        
//    }];
    
    [WELCustomStatusbarColor updateStatusbarIconColor:[UIColor orangeColor]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
