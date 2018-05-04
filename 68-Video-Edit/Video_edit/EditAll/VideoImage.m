//
//  VideoImage.m
//  Video_edit
//
//  Created by xiaoke_mh on 16/4/7.
//  Copyright © 2016年 m-h. All rights reserved.
//

#import "VideoImage.h"

@implementation VideoImage
+ (NSArray *) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time
{

    NSMutableArray * returnArr = [NSMutableArray array];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil] ;
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset] ;
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    NSInteger alltime = [[self alloc] getVideoAllTimeWith:videoURL];
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
-(NSInteger )getVideoAllTimeWith:(NSURL *)url
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];  // 初始化视频媒体文件
    int minute = 0, second = 0;
    second = ceil(urlAsset.duration.value / urlAsset.duration.timescale); // 获取视频总时长,单位秒
    //NSLog(@"movie duration : %d", second);
//    if (second >= 60) {
//        int index = second / 60;
//        minute = index;
//        second = second - index*60;
//    }

    return second;
}
@end
