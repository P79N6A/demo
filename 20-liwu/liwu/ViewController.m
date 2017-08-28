//
//  ViewController.m
//  liwu
//
//  Created by czljcb on 2017/8/26.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "ViewController.h"

#import "IQAnimationImageView.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *bigZhaoImages;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet IQAnimationImageView *iq;
@property (nonatomic, strong) NSArray *bigZhaoPaths;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.bigZhaoImages = [self loadImagesWithImagePrefix:@"image" count:94];
    self.bigZhaoPaths = [self loadPathWithImagePrefix:@"image" count:94];

}

-(IBAction)dd:(id)sender{
    self.iq.filePaths = self.bigZhaoPaths;
    self.iq.displayTime = 0.08 * 1000000 ;
    [self.iq startAnimating];
 
}
-(IBAction)cc:(id)sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)playAnim{
    for (int i=0;i<94;){
        usleep(80000);//1s = 1000ms 1ms = 1000μs
//0.08s = 8 * 10000
        UIImage *image=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"image_%03d",i+1 ] ofType:@"png"]];
        [self performSelectorOnMainThread:@selector(changeImage:) withObject:image waitUntilDone:YES];
        i++;
    }
}

-(void)changeImage:(UIImage*)image{
    self.imageView.image=image;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //[self performSelectorInBackground:@selector(playAnim)withObject:nil];
    

    
    return;
    // 1.设置动画的图片
    self.imageView.animationImages = self.bigZhaoImages;
    
    // 2.设置动画的执行次数
    self.imageView.animationRepeatCount = 1;
    
    self.imageView.animationDuration = 94 * 0.08;
    
    // 3.开始动画
    [self.imageView startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.bigZhaoImages = nil;
        
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
    for (NSInteger i = count-1; i >= 0; i--) {
        NSString *imageName = [NSString stringWithFormat:@"%@_%03ld", imagePrefix, i + 1];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        [images addObject:image];
        
    }
    return images;
}

- (NSArray<NSString *> *)loadPathWithImagePrefix:(NSString *)imagePrefix count:(NSInteger)count
{
    NSMutableArray *images = [NSMutableArray array];
//    for (int i = 0; i < count; i++) {
//        NSString *imageName = [NSString stringWithFormat:@"%@_%03d", imagePrefix, i + 1];
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
//        [images addObject:imagePath];
//        
//    }
    
   NSString *path =  [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"礼物动图第一期/摩天轮"];
    
   NSArray *names = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    [names enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,obj];
        [images addObject:filePath];
    }];
    
    return images;
}

@end
