//
//  MergaHeBingVC.m
//  Video_edit
//
//  Created by xiaoke_mh on 16/4/7.
//  Copyright © 2016年 m-h. All rights reserved.
//

#import "MergaHeBingVC.h"

@interface MergaHeBingVC ()
{
    AVPlayerItem * _playerItem;
    AVPlayer * _player;
    AVPlayerLayer * _playerLayer;

}
@end

@implementation MergaHeBingVC

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
    [btn setTitle:@"视频合并" forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    btn.tag = 10086 ;
    [btn addTarget:self action:@selector(mergeAndSave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}
-(void)choose
{
    [self choose_video];
}

-(void)mergeAndSave
{
    AVAsset *firstAsset = [AVAsset assetWithURL:self.videoUrl];
    AVAsset *secondAsset = [AVAsset assetWithURL:self.videoUrl];
    
    // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    // 2 - Video track
    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration)
                        ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration)
                        ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:firstAsset.duration error:nil];
    // 3 - Audio track
    //这一段貌似是添加背景音乐的
    //    if (audioAsset!=nil){
    //        AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
    //                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
    //        [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration))
    //                            ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    //    }
    
    
    // 4 - Get path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
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
                        AVPlayerItem * playeritem = [AVPlayerItem playerItemWithURL:outputURL];
                        [_player replaceCurrentItemWithPlayerItem:playeritem];
                        [_player play];
                        
                        //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                        //                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        //                        [alert show];
                    }
                });
            }];
        }
    }
}
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
