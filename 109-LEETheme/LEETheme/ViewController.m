//
//  ViewController.m
//  LEETheme
//
//  Created by Jay on 1/11/2018.
//  Copyright © 2018 Jay. All rights reserved.
//

#import "ViewController.h"

#import <LEETheme/LEETheme.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UISwitch *sw;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIStepper *step;
@property (weak, nonatomic) IBOutlet UIPageControl *page;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"右侧" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.title = @"标题";
    
    //self.btn.lee_theme.LeeAddBackgroundColor(kDay, [UIColor redColor])
                      //.LeeAddBackgroundColor(kNight, [UIColor blackColor]);
    
    self.btn.lee_theme.LeeConfigBackgroundColor(@"ident1");
    self.btn.lee_theme.LeeCustomConfig(@"ident5", ^(id item, id value) {
        
    });
    
    self.img.lee_theme.LeeConfigImage(@"ident3");
    
 
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
        
        /*  这是一种巧妙的方法 良好的过渡效果可以很好地提高体验 可以根据你的使用场景来进行尝试
         
         关于文字颜色改变时增加过渡的动画效果这点很不好处理, 如果增加动画处理 那么最终导致切换主题时文字颜色与其他颜色或图片不能很好地统一过渡, 效果上总会有些不自然.
         原理: 切换主题前 获取当前window的快照视图 并覆盖到window上 > 执行主题切换 > 将覆盖的快照视图通过动画隐藏 显示出切换完成的真实window.
         场景: 比较适用于阅读类APP切换日夜间主题场景.
         优点: 过渡效果自然统一, 可根据自行调整不同的动画效果等.
         缺点: 如果当前显示的内容不处于静止状态 那么会产生一种残影的感觉, 例如 列表滑动时切换
         总结: 可以根据你的使用场景来进行尝试, 一切只为了更好的体验 但也无需强求.
         */
        
        // 覆盖截图
        
        UIView *tempView = [self.view.window snapshotViewAfterScreenUpdates:NO];
        
        [self.view.window addSubview:tempView];
        
        // 切换主题
        
        if ([[LEETheme currentThemeTag] isEqualToString:kDay]) {
            
            [LEETheme startTheme:kNight];
            
        } else {
            
            [LEETheme startTheme:kDay];
        }
        
        // 增加动画 移除覆盖
        
        [UIView animateWithDuration:1.0f animations:^{
            
            tempView.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [tempView removeFromSuperview];
        }];
        

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
