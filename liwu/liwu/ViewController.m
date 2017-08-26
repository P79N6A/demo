//
//  ViewController.m
//  liwu
//
//  Created by czljcb on 2017/8/26.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *bigZhaoImages;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.bigZhaoImages = [self loadImagesWithImagePrefix:@"image" count:94];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 1.设置动画的图片
    self.imageView.animationImages = self.bigZhaoImages;
    
    // 2.设置动画的执行次数
    self.imageView.animationRepeatCount = 1;
    
    self.imageView.animationDuration = 94 * 0.08;
    
    // 3.开始动画
    [self.imageView startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //self.bigZhaoImages = nil;
        
        self.imageView.animationImages = nil;

    });

}

- (NSArray *)loadImagesWithImagePrefix:(NSString *)imagePrefix count:(NSInteger)count
{
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@_%03d", imagePrefix, i + 1];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        [images addObject:image];
    }
    
    return images;
}

@end
