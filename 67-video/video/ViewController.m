//
//  ViewController.m
//  video
//
//  Created by Jay on 28/4/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "TTZMedia.h"

#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *images;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.images = [TTZMedia thumbnailImageForVideo:@"/Users/jay/Desktop/1.mp4"];//[self thumbnailImageForVideo:[NSURL fileURLWithPath:@"/Users/jay/Desktop/1.mp4"] atTime:0];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    NSLog(@"%s", __func__);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [TTZMedia AVsaveVideoPath:@"/Users/jay/Downloads/MixVideo.mov"
                 WithWaterImg:[UIImage imageNamed:@"Snip20180503_38"]
               WithCoverImage:[UIImage imageNamed:@"Snip20180403_3"]
                  WithQustion:@"qustion"
                 WithFileName:@"fileName"];
    return;
    [TTZMedia importMP3WithURL:@"/Users/jay/Downloads/20180503102411_460.mp4"
                         range:NSMakeRange(0, 0)
                    completion:^(NSString *path) {
                        NSLog(@"%s-合成-%@", __func__,path);
                    }];
    return;
    [TTZMedia importVideoWithURL:@"/Users/jay/Downloads/20180503102411_460.mp4"
                           range:NSMakeRange(10, 20)
                      completion:^(NSString *path) {
                          NSLog(@"%s-合成-%@", __func__,path);
                      }];
    return;
    [TTZMedia addBackgroundMiusicWithVideoUrlStr:@"/Users/jay/Downloads/20180503102411_460.mp4"
                                        audioUrl:@"/Users/jay/Desktop/月半弯.mp3"
                        andCaptureVideoWithRange:NSMakeRange(0, 20)
                                      completion:^(NSString *path) {
                                          NSLog(@"%s-合成-%@", __func__,path);
                                      }];
    return;
    [TTZMedia addBackgroundMiusicWithVideoURL:@"/Users/jay/Downloads/20180503102411_460.mp4"
                                     audioURL:@"/Users/jay/Desktop/月半弯.mp3"
                                   completion:^(NSString *path) {
                                       NSLog(@"%s-合成-%@", __func__,path);
                                   }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.imageView.image = self.images[indexPath.item];
    return cell;
}

-(NSInteger )getVideoAllTimeWith:(NSURL *)url
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];  // 初始化视频媒体文件
    NSInteger second = 0;
    second = ceil(urlAsset.duration.value / urlAsset.duration.timescale); // 获取视频总时长,单位秒
    
    return second;
}

- (NSArray *) thumbnailImageForVideo:(NSURL *)videoURL
                              atTime:(NSTimeInterval)time
{
    
    NSMutableArray * returnArr = [NSMutableArray array];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil] ;
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset] ;
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    NSInteger alltime = [self getVideoAllTimeWith:videoURL];
    NSLog(@"%ld",(long)alltime);
    for (int i = 0; i < alltime * 2; i++) {
        CGImageRef thumbnailImageRef = NULL;
        CFTimeInterval thumbnailImageTime = i * 60 / 2;
        CMTime resultTime = CMTimeMake(thumbnailImageTime, 60);
        CMTimeShow(resultTime);
        NSError *thumbnailImageGenerationError = nil;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:resultTime actualTime:NULL error:&thumbnailImageGenerationError];
        
        if (!thumbnailImageRef)
            NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
        
        UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]  : nil;
        if (thumbnailImage) {
            [returnArr addObject:thumbnailImage];
        }
        
    }
    /*
     这个方法原本是要传一个 time 值，根据 time 返回该时间的图片
     CGImageRef thumbnailImageRef = NULL;
     CFTimeInterval thumbnailImageTime = time * 60;
     CMTime resultTime = CMTimeMake(thumbnailImageTime, 60);
     CMTimeShow(resultTime);
     
     NSError *thumbnailImageGenerationError = nil;
     thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:resultTime actualTime:NULL error:&thumbnailImageGenerationError];
     
     if (!thumbnailImageRef)
     NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
     
     UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]  : nil;
     if (thumbnailImage) {
     [returnArr addObject:thumbnailImage];
     }
     */
    
    return returnArr;
}

@end
