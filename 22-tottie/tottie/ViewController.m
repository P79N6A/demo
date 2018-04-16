//
//  ViewController.m
//  tottie
//
//  Created by czljcb on 2017/8/27.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "ViewController.h"

#import <SSZipArchive.h>
#import <Lottie/Lottie.h>
#import <AFNetworking.h>
#import <UIImage+YHPDFIcon.h>

@interface ViewController () <LOTImageCache>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** <##> */
@property (nonatomic, strong) NSMutableDictionary *cache;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.cache = [NSMutableDictionary dictionary];
//    self.imageView.image = [UIImage yh_imageNamed:@"分享"];
    
<<<<<<< HEAD
//    [self d];
=======
    //[self d];
>>>>>>> 81d8d8e3160f82eb5119794f6ef0d31c3358e604
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
<<<<<<< HEAD
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//
//    NSString *file = [path stringByAppendingPathComponent:@"28"];
//
//    LOTAnimationView *animation = [LOTAnimationView animationNamed:@"data" inBundle:[NSBundle bundleWithPath:file]];
//    animation.contentMode = UIViewContentModeScaleAspectFill;
//    animation.loopAnimation = NO;
//    animation.cacheEnable = YES;
//    [self.view addSubview:animation];
//    animation.frame = CGRectMake(0, 100, 300, 300);
//    animation.backgroundColor = [UIColor blackColor];
//    [animation playWithCompletion:^(BOOL animationFinished) {
//        // Do Something
//        //[animation removeFromSuperview];
//        [self.cache removeAllObjects];
//        [[LOTAnimationCache sharedCache] clearCache];
//    }];
    LOTAnimationView *animation = [LOTAnimationView animationNamed:@"heart"];
//    LOTAnimationView *animation = [[LOTAnimationView alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://www.lottiefiles.com/download/543"]];
//
    animation.loopAnimation = NO;
    [self.view addSubview:animation];
    animation.frame = CGRectMake(0, 100, 300, 300);
    animation.backgroundColor = [UIColor whiteColor];
=======
    
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"我爱你/data.json"];
    
    LOTAnimationView *animation = [[LOTAnimationView alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
    animation.
//    LOTAnimationView *animation = [[LOTAnimationView alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://www.lottiefiles.com/download/543"]];

    animation.loopAnimation = NO;
    [self.view addSubview:animation];
    animation.frame = CGRectMake(0, 100, 300, 300);
    animation.backgroundColor = [UIColor blackColor];
>>>>>>> 81d8d8e3160f82eb5119794f6ef0d31c3358e604
    [animation playWithCompletion:^(BOOL animationFinished) {
        // Do Something
    }];

}
- (LOTImage *)imageForKey:(NSString *)key{
    
    //UIImage *imge = [UIImage imageWithContentsOfFile:key];
    return nil;
}
- (void)setImage:(LOTImage *)image forKey:(NSString *)key{
    [self.cache setObject:image forKey:key];
}


- (void)d{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://img.11yuehui.com/mb/gift/down/28.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%d----%f",1, 1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    }destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@",[response suggestedFilename]]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
        [SSZipArchive unzipFileAtPath:filePath.path toDestination:filePath.path.stringByDeletingLastPathComponent];
        
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;

        NSString *file = [path stringByAppendingPathComponent:@"28"];
        
        NSString *jsonPath = [file stringByAppendingPathComponent:@"data.json"];
        NSString *imagePath = [file stringByAppendingPathComponent:@"images/data.json"];
        NSError *merror;
        //[[NSFileManager defaultManager] moveItemAtPath:jsonPath toPath:imagePath error:&merror];
        
        [LOTCacheProvider setImageCache:self];
        
        LOTAnimationView *animation = [LOTAnimationView animationNamed:@"data" inBundle:[NSBundle bundleWithPath:file]];
        animation.contentMode = UIViewContentModeScaleAspectFill;
        animation.loopAnimation = NO;
        animation.cacheEnable = YES;
        [self.view addSubview:animation];
        animation.frame = CGRectMake(0, 100, 300, 300);
        animation.backgroundColor = [UIColor blackColor];
        [animation playWithCompletion:^(BOOL animationFinished) {
            // Do Something
            //[animation removeFromSuperview];
            [self.cache removeAllObjects];
            [[LOTAnimationCache sharedCache] clearCache];
        }];

        
    }];
    [downloadTask resume];
    
}




@end
