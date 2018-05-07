//
//  ViewController.m
//  video
//
//  Created by Jay on 28/4/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "TTZMedia.h"
#import "UIView+Loading.h"
#import "MBProgressHUD+MJ.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface ViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *images;
@property(nonatomic, strong) AVAsset *videoAsset;
/** <##> */
@property (nonatomic, strong) NSURL *videoUrl;
@end

@implementation ViewController

-(void)showLoadIng
{
    [self.view showLoading:@"loading..."];
    [MBProgressHUD showMessage:@"正在处理中"];
}
-(void)stopLoadIng
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccess:@"合成完成"];
}

//- (void)viewDidLoad {
//
//    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//
//    self.images = [TTZMedia thumbnailImageForVideo:@"/Users/jay/Desktop/1.mp4"];//[self thumbnailImageForVideo:[NSURL fileURLWithPath:@"/Users/jay/Desktop/1.mp4"] atTime:0];
//
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//
//    NSLog(@"%s", __func__);
//
//    CATextLayer *lary = [CATextLayer layer];
//    lary.string = @"dasfasa";
//    lary.bounds = CGRectMake(0, 0, 320, 20);
//    lary.font = CFBridgingRetain(@"HiraKakuProN-W3");//字体的名字 不是 UIFont
//    lary.fontSize = 12.f;//字体的大小
//    //或者
//    //UIFont *font = [UIFont systemFontOfSize:14];
//    //    CFStringRef fontCFString = (__bridge CFStringRef)font.fontName;
//    //       CGFontRef fontRef = CGFontCreateWithFontName(fontCFString);
//    //       textLayer.font = fontRef;
//    //       textLayer.fontSize = font.pointSize;
//    //       CGFontRelease(fontRef); //与CFRelease的功能相当 当字体的null的时候不会引起程序出错
//
//    lary.wrapped = YES;//默认为No.  当Yes时，字符串自动适应layer的bounds大小
//    lary.alignmentMode = kCAAlignmentCenter;//字体的对齐方式
//    lary.position = CGPointMake(160, 410);//layer在view的位置 适用于跟随摸一个不固定长的的控件后面需要的
//    lary.contentsScale = [UIScreen mainScreen].scale;//解决文字模糊 以Retina方式来渲染，防止画出来的文本像素化
//    lary.foregroundColor =[UIColor redColor].CGColor;//字体的颜色 文本颜色
//    [self.view.layer addSublayer:lary];
//
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.videoUrl = [NSURL fileURLWithPath:@"/Users/jay/Downloads/20180503102411_460.mp4"];
    // Do any additional setup after loading the view.
    
    self.videoUrl = [NSURL fileURLWithPath:@"/Users/jay/Downloads/20180503102411_460.mp4"];
    
    UIButton * btn = [UIButton buttonWithType:0];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.frame = CGRectMake(30 , 150, 200, 40);
    [btn setTitle:@"微信支付" forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    btn.tag = 10086 ;
    [btn addTarget:self action:@selector(_addwater:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}
-(void)_addwater:(UIButton *)btn
{
    [self showLoadIng];
    //1 创建AVAsset实例 AVAsset包含了video的所有信息 self.videoUrl输入视频的路径
    self.videoAsset = [AVAsset assetWithURL:self.videoUrl];
    //2 创建AVMutableComposition实例. apple developer 里边的解释 【AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.】
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    //3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration)
                        ofTrack:[[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration)
                        ofTrack:[[self.videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];

    
    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    AVAssetTrack *videoAssetTrack = [[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:self.videoAsset.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    //AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    [self applyVideoEffectsToComposition:mainCompositionInst size:naturalSize];
    
    // 4 - 输出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = @"/Users/jay/Desktop";//[paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"FinalVideo-%d.mov",arc4random() % 1000]];
    self.videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    // 5 - 视频文件输出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetMediumQuality];
    exporter.outputURL=self.videoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里是输出视频之后的操作，做你想做的
            [self exportDidFinish:exporter];
        });
    }];

}

- (void)exportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    } else {
                        [self stopLoadIng];

//                        [self stopLoadIng];
//                        AVPlayerItem * playeritem = [AVPlayerItem playerItemWithURL:self.videoUrl];
//                        [_player replaceCurrentItemWithPlayerItem:playeritem];
//                        [_player play];
                        
                        //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                        //                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        //                        [alert show];
                    }
                });
            }];
        }
    }
}
- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size
{
    // 1 - Set up the text layer
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    [subtitle1Text setFont:@"Helvetica-Bold"];
    [subtitle1Text setFontSize:36];
    [subtitle1Text setFrame:CGRectMake(0, size.height-100, size.width, 100)];
    [subtitle1Text setString:@"哈哈  这是水印"];
    //    [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
    [subtitle1Text setForegroundColor:[[UIColor redColor] CGColor]];
    [subtitle1Text setBackgroundColor:[UIColor blueColor].CGColor];

    
    CALayer *imgLayer = [CALayer layer];
    UIImage *overlayImage  = [UIImage imageNamed:@"微信支付"];
    [imgLayer setContents:(id)[overlayImage CGImage]];
    imgLayer.frame = CGRectMake(0, 0, 100, 100);
    
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:subtitle1Text];
    [overlayLayer addSublayer:imgLayer];
    
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
    
    
    CALayer *parentLayer = [CALayer layer];
    
    CALayer *videoLayer = [CALayer layer];
    
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    //*********** For A Special Time
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setDuration:0];
    [animation setFromValue:[NSNumber numberWithFloat:1.0]];
    [animation setToValue:[NSNumber numberWithFloat:0.0]];
    [animation setBeginTime:5];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    [overlayLayer addAnimation:animation forKey:@"animateOpacity"];
    
    
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
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
