//
//  TTZMedia.h
//  video
//
//  Created by Jay on 4/5/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionBlock)(NSString *);

@interface TTZMedia : NSObject

/**
 截取视频并添加背景音乐

 @param videoUrl 资源路径
 @param audioUrl 资源路径
 @param videoRange 截取范围
 @param callBack 结果callback
 */
+ (void)addBackgroundMiusicWithVideoUrlStr:(NSString *)videoUrl
                                  audioUrl:(NSString *)audioUrl
                  andCaptureVideoWithRange:(NSRange)videoRange
                                completion:(CompletionBlock)callBack;

/**
 添加背景音乐
 
 @param videoURL 资源路径
 @param audioURL 资源路径
 @param callBack 结果callback
 */
+ (void)addBackgroundMiusicWithVideoURL:(NSString *)videoURL
                          audioURL:(NSString *)audioURL
                        completion:(CompletionBlock)callBack;


/**
 截取视频
 
 @param videoURL 资源路径
 @param videoRange 截取范围
 @param callBack 结果callback
 */
+ (void)importVideoWithURL:(NSString *)videoURL
                     range:(NSRange)videoRange
                completion:(CompletionBlock)callBack;



/**
 导出背景音乐
 @param videoURL 资源路径
 @param mp3Range 音乐范围 (0,0) 代表全部时长
 @param callBack 结果callback
 */
+ (void)importMP3WithURL:(NSString *)videoURL
                   range:(NSRange)mp3Range
              completion:(CompletionBlock)callBack;



/**
 获得视频的某个时间点的帧图片

 @param videoURL 资源路径
 @param timeBySecond 某一秒
 @return 帧图片
 */
+ (UIImage *)thumbnailImageForVideo:(NSString *)videoURL
                             atTime:(CGFloat)timeBySecond;


/**
 获得视频帧图片集

 @param videoURL 资源路径
 @return 图片集
 */
+ (NSArray <UIImage *>*)thumbnailImageForVideo:(NSString *)videoURL;


+ (void)AVsaveVideoPath:(NSString*)videoURL
               waterImg:(UIImage*)img
             imagePonit:(CGRect)iFrame
                qustion:(NSString*)question
           qustionPonit:(CGRect)qFrame;

/**
 获取多媒体时长
 @param url 资源路径
 @return 时长 单位为s
 */
+ (CGFloat)durationWithResourceURL:(NSString *)url;

@end
