//
//  ViewController.m
//  Video_edit
//
//  Created by xiaoke_mh on 16/4/7.
//  Copyright © 2016年 m-h. All rights reserved.
//

#import "ViewController.h"
#import "ZYQAssetPickerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

#import "VideoImage.h"
#import "AddWaterVC.h"
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate>
{
    NSURL *_videoUrl;//视频路径
    UIView * _playView;
    AVPlayerItem * _playerItem;
    AVPlayer * _player;
    AVPlayerLayer * _playerLayer;
    
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"选取视频" style:UIBarButtonItemStylePlain target:self action:@selector(choose_video)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    _playView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 300)];
    _playView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_playView];
    
    NSArray * btnTitle = @[@"播放",@"暂停",@"",@"",@"添加水印",@"视频裁剪",@"合并视频",@"添加背景音乐",@"",@"",@"",@"",];
    for (int i = 0; i < btnTitle.count; i++) {
        NSInteger index = i % 4;
        NSInteger page = i / 4;
        UIButton * btn = [UIButton buttonWithType:0];
        btn.backgroundColor = [UIColor lightGrayColor];
        btn.frame = CGRectMake(screen_width/4 * index + 5, 370 + page*60, screen_width/4-10, 40);
        [btn setTitle:btnTitle[i] forState:0];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        btn.tag = 10086 + i;
        [btn addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }

}
-(void)btn_click:(UIButton *)btn
{
    switch (btn.tag - 10086) {
        case 0:
        {
            //播放
            if (_videoUrl) {
                [_playerLayer removeFromSuperlayer];
                _playerItem = [AVPlayerItem playerItemWithURL:_videoUrl];
                _player = [AVPlayer playerWithPlayerItem:_playerItem];
                _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
                _playerLayer.frame = _playView.bounds;
                [_playView.layer addSublayer:_playerLayer];
                [_player play];
            }

        }
            break;
        case 1:
        {
            //暂停
            if (_videoUrl) {
                if ([btn.titleLabel.text isEqualToString:@"暂停"]) {
                    [_player pause];
                    [btn setTitle:@"继续" forState:0];
                }else{
                    [_player  play];
                    [btn setTitle:@"暂停" forState:0];
                }
                
            }
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            //添加水印
//            if (_videoUrl) {
                AddWaterVC * edit = [[AddWaterVC alloc] init];
//                edit.videoUrl = _videoUrl;
                [self.navigationController pushViewController:edit animated:YES];
//            }
        }
            break;
        case 5:
        {
            //视频裁剪
            Class class = NSClassFromString(@"CaiJianVC");
            [self.navigationController pushViewController:(UIViewController *)[[class alloc] init] animated:YES];
        }
            break;
        case 6:
        {
            //视频合成
            Class class = NSClassFromString(@"MergaHeBingVC");
            [self.navigationController pushViewController:(UIViewController *)[[class alloc] init] animated:YES];
        }
            break;
        case 7:
        {
         //添加背景音乐
            Class class = NSClassFromString(@"AddBagMusicVC");
            [self.navigationController pushViewController:(UIViewController *)[[class alloc] init] animated:YES];
        }
            break;
        case 8:
        {
            
        }
            break;
        default:
            break;
    }
}
-(void)addWater
{
    AVAsset *asset = [[AVURLAsset alloc] initWithURL:_videoUrl options:nil];
    CGSize videoSize;
    
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    // Check if the asset contains video and audio tracks
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    CMTime insertionPoint = kCMTimeZero;
    NSError *error = nil;

    // Step 1
    // Create a composition with the given asset and insert audio and video tracks into it from the asset
    // Check if a composition already exists, else create a composition using the input asset
    AVMutableComposition *mutableComposition = [AVMutableComposition composition];
    
    // Insert the video and audio tracks from AVAsset
    if (assetVideoTrack != nil) {
        AVMutableCompositionTrack *compositionVideoTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:assetVideoTrack atTime:insertionPoint error:&error];
    }
    if (assetAudioTrack != nil) {
        AVMutableCompositionTrack *compositionAudioTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:assetAudioTrack atTime:insertionPoint error:&error];
    }
    // Step 2
    // Create a water mark layer of the same size as that of a video frame from the asset
    if ([[mutableComposition tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        
        
            // build a pass through video composition
            AVMutableVideoComposition *mutableVideoComposition = [AVMutableVideoComposition videoComposition];
            mutableVideoComposition.frameDuration = CMTimeMake(1, 30); // 30 fps
            mutableVideoComposition.renderSize = assetVideoTrack.naturalSize;
            
            AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            passThroughInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mutableComposition duration]);
            
            AVAssetTrack *videoTrack = [mutableComposition tracksWithMediaType:AVMediaTypeVideo][0];
            AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
            
            passThroughInstruction.layerInstructions = @[passThroughLayer];
            mutableVideoComposition.instructions = @[passThroughInstruction];
            
        
        
        videoSize = mutableVideoComposition.renderSize;
        CALayer *watermarkLayer = [self watermarkLayerForSize:videoSize];
        
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        parentLayer.frame = CGRectMake(0, 0, mutableVideoComposition.renderSize.width, mutableVideoComposition.renderSize.height);
        videoLayer.frame = CGRectMake(0, 0, mutableVideoComposition.renderSize.width, mutableVideoComposition.renderSize.height);
        [parentLayer addSublayer:videoLayer];
        watermarkLayer.position = CGPointMake(mutableVideoComposition.renderSize.width/2, mutableVideoComposition.renderSize.height/4);
        [parentLayer addSublayer:watermarkLayer];
        mutableVideoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    }


}
- (CALayer*)watermarkLayerForSize:(CGSize)videoSize
{
    // Create a layer for the title
    CALayer *_watermarkLayer = [CALayer layer];
    
    // Create a layer for the text of the title.
    CATextLayer *titleLayer = [CATextLayer layer];
    titleLayer.string = @"AVSE";
    titleLayer.foregroundColor = [[UIColor whiteColor] CGColor];
    titleLayer.shadowOpacity = 0.5;
    titleLayer.alignmentMode = kCAAlignmentCenter;
    titleLayer.bounds = CGRectMake(0, 0, videoSize.width/2, videoSize.height/2);
    
    // Add it to the overall layer.
    [_watermarkLayer addSublayer:titleLayer];
    
    return _watermarkLayer;
}
-(void)selectImageFromCamera
{
    //NSLog(@"相机");
    UIImagePickerController * _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
//    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    _imagePickerController.videoMaximumDuration = 20;
    //相机类型（拍照、录像...）
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    //视频上传质量
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    //设置摄像头模式（拍照，录制视频）
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];

}
-(void)selectImageFromAlbum
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 1;//只选择一个视频
    picker.assetsFilter = [ALAssetsFilter allVideos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
        for (int i=0; i<assets.count; i++) {
            NSLog(@"%@",assets[i]);
            ALAsset * asset = assets[i];
            NSURL * url = asset.defaultRepresentation.url;
            _videoUrl = url;
        }


}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        
    }else{
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        _videoUrl = url;
        //保存视频至相册（异步线程）
        NSString *urlStr = [url path];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                
                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        });
        
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextIn {
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}
-(void)choose_video
{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:@"选择图片来源" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromCamera];
        NSLog(@"选取视频 相机");
        
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromAlbum];
        NSLog(@"选取视频 相册");
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:cameraAction];
    [alertVc addAction:photoAction];
    [alertVc addAction:cancelAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
