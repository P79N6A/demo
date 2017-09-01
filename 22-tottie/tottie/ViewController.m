//
//  ViewController.m
//  tottie
//
//  Created by czljcb on 2017/8/27.
//  Copyright © 2017年 czljcb. All rights reserved.
//

#import "ViewController.h"

#import <Lottie/Lottie.h>
#import <AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self d];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"我爱你/data.json"];
    
    LOTAnimationView *animation = [[LOTAnimationView alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
    animation.
//    LOTAnimationView *animation = [[LOTAnimationView alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://www.lottiefiles.com/download/543"]];

    animation.loopAnimation = NO;
    [self.view addSubview:animation];
    animation.frame = CGRectMake(0, 100, 300, 300);
    animation.backgroundColor = [UIColor blackColor];
    [animation playWithCompletion:^(BOOL animationFinished) {
        // Do Something
    }];

}

- (void)d{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://www.lottiefiles.com/download/433"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%d----%f",1, 1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    }destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@",[response suggestedFilename]]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
        LOTAnimationView *animation = [[LOTAnimationView alloc] initWithContentsOfURL:filePath];
        animation.contentMode = UIViewContentModeScaleAspectFill;
        animation.loopAnimation = NO;
        [self.view addSubview:animation];
        animation.frame = CGRectMake(0, 100, 300, 300);
        animation.backgroundColor = [UIColor blackColor];
        [animation playWithCompletion:^(BOOL animationFinished) {
            // Do Something
        }];

        
    }];
    [downloadTask resume];
    
}


@end
