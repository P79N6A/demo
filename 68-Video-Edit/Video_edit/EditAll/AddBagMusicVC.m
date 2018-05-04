//
//  AddBagMusicVC.m
//  Video_edit
//
//  Created by xiaoke_mh on 16/4/7.
//  Copyright © 2016年 m-h. All rights reserved.
//

#import "AddBagMusicVC.h"
#define AUDIO_URL [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"月半弯" ofType:@"mp3"]]

@interface AddBagMusicVC ()
{
    AVPlayerItem * _playerItem;
    AVPlayer * _player;
    AVPlayerLayer * _playerLayer;
    
    
    NSMutableArray * audioMixParams;
}
@property(nonatomic,copy)NSURL * mixURL;
@property(nonatomic,copy)NSURL * theEndVideoURL;
@end

@implementation AddBagMusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _playerItem = [AVPlayerItem playerItemWithURL:self.videoUrl];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:_playerLayer];
    
    UIButton * btnw = [UIButton buttonWithType:0];
    btnw.backgroundColor = [UIColor lightGrayColor];
    btnw.frame = CGRectMake(30 , 100, 200, 40);
    [btnw setTitle:@"选取视频" forState:0];
    [btnw setTitleColor:[UIColor blackColor] forState:0];
    [btnw addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnw];
    
    
    
    UIButton * btn = [UIButton buttonWithType:0];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.frame = CGRectMake(30 , 150, 200, 40);
    [btn setTitle:@"添加背景音乐" forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    btn.tag = 10086 ;
    [btn addTarget:self action:@selector(addmusic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
//-(void)opopopopop
//{
////    [self lpppp];
//}
-(void)choose
{
    [self choose_video];
}
-(void)addmusic
{
    if (!self.videoUrl) {
        return;
    }
    [self showLoadIng];
    //视频 声音 来源
    NSURL * videoInputUrl = self.videoUrl;
    NSURL * audioInputUrl = AUDIO_URL;
    //合成之后的输出路径
    NSString *outPutPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
    //混合后的视频输出路径
    NSURL *outPutUrl = [NSURL fileURLWithPath:outPutPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outPutPath error:nil];
    }

    //时间起点
    CMTime nextClistartTime = kCMTimeZero;
    //创建可变的音视频组合
    AVMutableComposition * comosition = [AVMutableComposition composition];
    
    //视频采集
    AVURLAsset * videoAsset = [[AVURLAsset alloc] initWithURL:videoInputUrl options:nil];
    //视频时间范围
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    // 视频通道 枚举 kCMPersistentTrackID_Invalid = 0
    AVMutableCompositionTrack * videoTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //视频采集通道
    AVAssetTrack * videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    //把采集轨道数据加入到可变轨道中
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:nextClistartTime error:nil];
    
    
    
    //声音采集
    AVURLAsset * audioAsset = [[AVURLAsset alloc] initWithURL:audioInputUrl options:nil];
    //因为视频较短 所以直接用了视频的长度 如果想要自动化需要自己写判断
    CMTimeRange audioTimeRange = videoTimeRange;
    //音频通道
    AVMutableCompositionTrack * audioTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //音频采集通道
    AVAssetTrack * audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    //加入合成轨道中
    [audioTrack insertTimeRange:audioTimeRange ofTrack:audioAssetTrack atTime:nextClistartTime error:nil];
    
    
    
#warning test
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
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
    [videolayerInstruction setOpacity:0.0 atTime:videoAsset.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
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
#warning test end 如果没有这段代码，合成后的视频会旋转90度
    
    //创建输出
    AVAssetExportSession * assetExport = [[AVAssetExportSession alloc] initWithAsset:comosition presetName:AVAssetExportPresetMediumQuality];
    assetExport.outputURL = outPutUrl;//输出路径
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;//输出类型
    assetExport.shouldOptimizeForNetworkUse = YES;//是否优化   不太明白
    assetExport.videoComposition = mainCompositionInst;
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:assetExport];
        });
    }];
    
    
    
    
    
//    //AVURLAsset此类主要用于获取媒体信息，包括视频、声音等
//    AVURLAsset* audioAsset = [[AVURLAsset alloc] initWithURL:AUDIO_URL options:nil];
//    AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:self.videoUrl options:nil];
//    //创建AVMutableComposition对象来添加视频音频资源的AVMutableCompositionTrack
//    AVMutableComposition* mixComposition = [AVMutableComposition composition];
//    
//    //CMTimeRangeMake(start, duration),start起始时间，duration时长，都是CMTime类型
//    //CMTimeMake(int64_t value, int32_t timescale)，返回CMTime，value视频的一个总帧数，timescale是指每秒视频播放的帧数，视频播放速率，（value / timescale）才是视频实际的秒数时长，timescale一般情况下不改变，截取视频长度通过改变value的值
//    //CMTimeMakeWithSeconds(Float64 seconds, int32_t preferredTimeScale)，返回CMTime，seconds截取时长（单位秒），preferredTimeScale每秒帧数
//    //开始位置startTime
//    CMTime startTime = CMTimeMakeWithSeconds(0, videoAsset.duration.timescale);
//    //截取长度videoDuration
//    CMTime videoDuration = CMTimeMakeWithSeconds(0, videoAsset.duration.timescale);
//    
//    CMTimeRange videoTimeRange = CMTimeRangeMake(startTime, videoDuration);
//    
//    //视频采集compositionVideoTrack
//    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//    //TimeRange截取的范围长度
//    //ofTrack来源
//    //atTime插放在视频的时间位置
//    [compositionVideoTrack insertTimeRange:videoTimeRange ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeVideo].count>0) ? [videoAsset tracksWithMediaType:AVMediaTypeVideo].firstObject : nil atTime:kCMTimeZero error:nil];
//    /*
//     //视频声音采集(也可不执行这段代码不采集视频音轨，合并后的视频文件将没有视频原来的声音)
//     
//     AVMutableCompositionTrack *compositionVoiceTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//     
//     [compositionVoiceTrack insertTimeRange:videoTimeRange ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeAudio].count>0)?[videoAsset tracksWithMediaType:AVMediaTypeAudio].firstObject:nil atTime:kCMTimeZero error:nil];
//     
//     */
//    //声音长度截取范围==视频长度
//    CMTimeRange audioTimeRange = CMTimeRangeMake(kCMTimeZero, videoDuration);
//    
//    //音频采集compositionCommentaryTrack
//    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//    
//    [compositionAudioTrack insertTimeRange:audioTimeRange ofTrack:([audioAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) ? [audioAsset tracksWithMediaType:AVMediaTypeAudio].firstObject : nil atTime:kCMTimeZero error:nil];
//
//    //AVAssetExportSession用于合并文件，导出合并后文件，presetName文件的输出类型
//    AVAssetExportSession *assetExportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetPassthrough];
//    NSString *outPutPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"mixVideo-%d.mov",arc4random() % 1000]];
//    //混合后的视频输出路径
//    NSURL *outPutUrl = [NSURL fileURLWithPath:outPutPath];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutPath])
//    {
//        [[NSFileManager defaultManager] removeItemAtPath:outPutPath error:nil];
//    }
//    assetExportSession.outputURL=outPutUrl;
//    assetExportSession.outputFileType = AVFileTypeQuickTimeMovie;
//    assetExportSession.shouldOptimizeForNetworkUse = YES;
//    [assetExportSession exportAsynchronouslyWithCompletionHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self exportDidFinish:assetExportSession];
//        });
//    }];

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
                        AVPlayerItem * playeritem = [AVPlayerItem playerItemWithURL:outputURL];
                        [_player replaceCurrentItemWithPlayerItem:playeritem];
                        [_player play];
                        
                    }
                });
            }];
        }
    }
}
//-(void)lpppp
//{
//    AVMutableComposition *composition =[AVMutableComposition composition];
//   audioMixParams =[[NSMutableArray alloc] initWithObjects:nil];
//    
//    //录制的视频
//    NSURL *video_inputFileUrl =self.videoUrl;
//    AVURLAsset *songAsset =[AVURLAsset URLAssetWithURL:AUDIO_URL options:nil];
//    CMTime startTime =CMTimeMakeWithSeconds(0,songAsset.duration.timescale);
//    CMTime trackDuration =songAsset.duration;
//    
//    //获取视频中的音频素材
//    [self setUpAndAddAudioAtPath:video_inputFileUrl toComposition:composition start:startTime dura:trackDuration offset:CMTimeMake(14*44100,44100)];
//    
//    //本地要插入的音乐
//    NSString *bundleDirectory =[[NSBundle mainBundle] bundlePath];
//    NSString *path = [bundleDirectory stringByAppendingPathComponent:@"30secs.mp3"];
//    NSURL *assetURL2 =AUDIO_URL;
//    //获取设置完的本地音乐素材
//    [self setUpAndAddAudioAtPath:assetURL2 toComposition:composition start:startTime dura:trackDuration offset:CMTimeMake(0,44100)];
//    
//    //创建一个可变的音频混合
//    AVMutableAudioMix *audioMix =[AVMutableAudioMix audioMix];
//    audioMix.inputParameters =[NSArray arrayWithArray:audioMixParams];//从数组里取出处理后的音频轨道参数
//    
//    //创建一个输出
//    AVAssetExportSession *exporter =[[AVAssetExportSession alloc]
//                                     initWithAsset:composition
//                                     presetName:AVAssetExportPresetAppleM4A];
//    exporter.audioMix = audioMix;
//    exporter.outputFileType=@"com.apple.m4a-audio";
//    NSString* fileName =[NSString stringWithFormat:@"%@.mov",@"overMix"];
//    //输出路径
//    NSString *exportFile =[NSString stringWithFormat:@"%@/%@",[self getLibarayPath], fileName];
//    
//    if([[NSFileManager defaultManager]fileExistsAtPath:exportFile]) {
//        [[NSFileManager defaultManager]removeItemAtPath:exportFile error:nil];
//    }
//    NSLog(@"是否在主线程1%d",[NSThread isMainThread]);
//    NSLog(@"输出路径===%@",exportFile);
//    
//    NSURL *exportURL =[NSURL fileURLWithPath:exportFile];
//    exporter.outputURL = exportURL;
//    self.mixURL =exportURL;
//    
//    [exporter exportAsynchronouslyWithCompletionHandler:^{
//        int exportStatus =(int)exporter.status;
//        switch (exportStatus){
//            caseAVAssetExportSessionStatusFailed:{
//                NSError *exportError =exporter.error;
//                NSLog(@"错误，信息: %@", exportError);
//                break;
//            }
//            caseAVAssetExportSessionStatusCompleted:{
//                NSLog(@"是否在主线程2%d",[NSThread isMainThread]);
//                NSLog(@"成功");
//                //最终混合
//                [self theVideoWithMixMusic];
//                break;  
//            }  
//        }  
//    }];
//}
////最终音频和视频混合
//-(void)theVideoWithMixMusic
//{
//    NSError *error =nil;
//    NSFileManager *fileMgr =[NSFileManager defaultManager];
//    NSString *documentsDirectory =[NSHomeDirectory()
//                                   stringByAppendingPathComponent:@"Documents"];
//    NSString *videoOutputPath =[documentsDirectory stringByAppendingPathComponent:@"test_output.mp4"];
//    if ([fileMgr removeItemAtPath:videoOutputPath error:&error]!=YES) {
//        NSLog(@"无法删除文件，错误信息：%@",[error localizedDescription]);
//    }
//    
//    //声音来源路径（最终混合的音频）
//    NSURL   *audio_inputFileUrl =self.mixURL;
//    
//    //视频来源路径
//    NSURL   *video_inputFileUrl = self.videoUrl;
//    
//    //最终合成输出路径
//    NSString *outputFilePath =[documentsDirectory stringByAppendingPathComponent:@"final_video.mp4"];
//    NSURL   *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
//    
//    if([[NSFileManager defaultManager]fileExistsAtPath:outputFilePath])
//        [[NSFileManager defaultManager]removeItemAtPath:outputFilePath error:nil];
//    
//    CMTime nextClipStartTime =kCMTimeZero;
//    
//    //创建可变的音频视频组合
//    AVMutableComposition* mixComposition =[AVMutableComposition composition];
//    
//    //视频采集
//    AVURLAsset* videoAsset =[[AVURLAsset alloc]initWithURL:video_inputFileUrl options:nil];
//    CMTimeRange video_timeRange =CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
//    AVMutableCompositionTrack*a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//    [a_compositionVideoTrack insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0] atTime:nextClipStartTime error:nil];
//    
//    //声音采集
//    AVURLAsset* audioAsset =[[AVURLAsset alloc]initWithURL:audio_inputFileUrl options:nil];
//    CMTimeRange audio_timeRange =CMTimeRangeMake(kCMTimeZero,videoAsset.duration);//声音长度截取范围==视频长度
//    AVMutableCompositionTrack*b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//    [b_compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0] atTime:nextClipStartTime error:nil];
//    
//    //创建一个输出
//    AVAssetExportSession* _assetExport =[[AVAssetExportSession alloc]initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
//    _assetExport.outputFileType =AVFileTypeQuickTimeMovie;
//    _assetExport.outputURL =outputFileUrl;
//    _assetExport.shouldOptimizeForNetworkUse=YES;
//    self.theEndVideoURL=outputFileUrl;
//    
//    [_assetExport exportAsynchronouslyWithCompletionHandler:
//     ^(void ) {
//         //播放
//         NSURL*url = [NSURL fileURLWithPath:outputFilePath];
////         MPMoviePlayerViewController *theMovie =[[MPMoviePlayerViewControlleralloc]initWithContentURL:url];
////         [selfpresentMoviePlayerViewControllerAnimated:theMovie];
////         theMovie.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
////         [theMovie.moviePlayerplay];
//     }
//     ];
//    NSLog(@"完成！输出路径==%@",outputFilePath);  
//}
////通过文件路径建立和添加音频素材
//- (void)setUpAndAddAudioAtPath:(NSURL*)assetURL toComposition:(AVMutableComposition*)composition  start:(CMTime)start dura:(CMTime)dura offset:(CMTime)offset{
//    
//    AVURLAsset *songAsset =[[AVURLAsset alloc] initWithURL:assetURL options:nil];
//    
//    AVMutableCompositionTrack *track =[composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//    AVAssetTrack *sourceAudioTrack =[[songAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
//    
//    NSError *error =nil;
//    BOOL ok =NO;
//    
//    CMTime startTime = start;
//    CMTime trackDuration = dura;
//    CMTimeRange tRange =CMTimeRangeMake(startTime,trackDuration);
//    
//    //设置音量
//    //AVMutableAudioMixInputParameters（输入参数可变的音频混合）
//    //audioMixInputParametersWithTrack（音频混音输入参数与轨道）
//    AVMutableAudioMixInputParameters *trackMix =[AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
//    [trackMix setVolume:0.8f atTime:startTime];
//    
//    //素材加入数组
//    [audioMixParams addObject:trackMix];
//    
//    //Insert audio into track  //offsetCMTimeMake(0, 44100)
//    ok = [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:kCMTimeInvalid error:&error];
//}
//
//#pragma mark - 保存路径
//-(NSString*)getLibarayPath
//{
//    NSFileManager *fileManager =[NSFileManager defaultManager];
//    
//    NSArray* paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString* path = [paths objectAtIndex:0];
//    
//    NSString *movDirectory = [path stringByAppendingPathComponent:@"tmpMovMix"];
//    
//    [fileManager createDirectoryAtPath:movDirectory withIntermediateDirectories:YES attributes:nil error:nil];
//    
//    return movDirectory;
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
