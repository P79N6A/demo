//
//  ViewController.m
//  FreeStreamerDemo
//
//  Created by FEIWU888 on 2017/10/11.
//  Copyright © 2017年 FEIWU888. All rights reserved.
//

#import "ViewController.h"
#import "FreeStreamerPlayer.h"
#import "UIImage+ImageEffects.h"

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <FreeStreamer/FSAudioStream.h>
#import "FSPlayer.h"
#import "HLHttpTool.h"
#import "PlayItem.h"
#import <MJExtension.h>

@interface ViewController ()<FSPCMAudioStreamDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UISlider *playProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *loadProgress;


@property (nonatomic, strong) NSArray<PlayItem *> *lists;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController
{
    FSAudioStream *_audioStream;
}
- (IBAction)nextAction {
    [[FSPlayer defaultPlayer] next];
}
- (IBAction)pre:(id)sender {
     [[FSPlayer defaultPlayer] previous];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //
     NSURL *url = [NSURL URLWithString:@"http://api.ishare.bthost.top/?c=loveq&a=program&debug=9"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [[HLHttpTool sharedInstance] getRequest:@"http://api.ishare.bthost.top/?c=loveq&a=program&debug=9"
                                 parameters:nil
                                    success:^(id respones) {
                                        self.lists = [PlayItem mj_objectArrayWithKeyValuesArray:respones[@"data"]];
                                        [[FSPlayer defaultPlayer] playItemAtIndex:0 itemList:self.lists];

                                    }
                                    failure:^(NSError *error) {
                                        
                                    }];
    
    [FSPlayer defaultPlayer].updateBufferedProgressBlock = ^(CGFloat currentPosition) {
        self.loadProgress.progress = currentPosition;
    };
    [FSPlayer defaultPlayer].updateProgressBlock = ^(CGFloat currentPosition, CGFloat totalPosition) {
        self.playProgress.value = currentPosition/totalPosition;
    };
    
    
    return;
    FSStreamConfiguration *config = [[FSStreamConfiguration alloc] init];
    config.cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    config.cacheEnabled = YES;
    
    _audioStream = [[FSAudioStream alloc] initWithConfiguration:config];
    [_audioStream playFromURL:url];
    [_audioStream setOutputFile:[NSURL fileURLWithPath:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject]];
    _audioStream.delegate = self;
    _audioStream.onStateChange = ^(FSAudioStreamState state) {
        NSLog(@"FSAudioStreamState:%ld",state);
        if (state==kFsAudioStreamPlaying) {
            
            /**
             * Playing.播放中
             */
            NSLog(@"播放中");
            
            
        }else if (state==kFsAudioStreamPlaybackCompleted){
            
            /**
             * Playback completed.*播放完成。
             */
            NSLog(@"播放完成");
            
            
        }else if (state==kFsAudioStreamBuffering)
        {
            //Buffering.*缓冲。
            NSLog(@"缓冲");
            
        }else if (state==kFsAudioStreamRetrievingURL)
        {
            // Retrieving URL.*检索URL。
            NSLog(@"检索URL");
            
        }else if (state==kFsAudioStreamUnknownState)
        {
            
            /**
             * Unknown state.*未知状态。
             */
            NSLog(@"未知状态");
            
        }else if (state==kFsAudioStreamRetryingFailed)
        {
            
            /**
             * Retrying failed.*重新尝试失败了。
             */
            NSLog(@"重新尝试失败了");
        }
        else if (state==kFsAudioStreamRetryingSucceeded)
        {
            
            /**
             * Retrying succeeded.*重新尝试成功了。
             */
            NSLog(@"重新尝试成功了");
        }
        else if (state==kFsAudioStreamRetryingStarted)
        {
            
            /**
             * Started retrying.*开始进行重试。
             */
            NSLog(@"开始进行重试");
        }
        else if (state==kFsAudioStreamFailed)
        {
            /**
             * Failed.*失败了。
             */
            NSLog(@"失败了");
        }
        else if (state==kFSAudioStreamEndOfFile)
        {
            /**
             * The stream has received all the data for a file.*流已经收到了所有的数据文件。
             */
            NSLog(@"流已经收到了所有的数据文件");
            
            
            
        }
        else if (state==kFsAudioStreamSeeking)
        {
            
            /**
             * Seeking.*寻求。
             */
            NSLog(@"寻求");
            
        }
        else if(kFsAudioStreamPaused==state){
            //暂停
            
            NSLog(@"暂停");
            
        }else if(kFsAudioStreamStopped==state){
            
            
            //停止
            
            NSLog(@"停止");
            
        }
        
        
        
    };
    _audioStream.onFailure = ^(FSAudioStreamError error, NSString *errorDescription) {
        NSLog(@"%s--失败---%ld-----%@", __func__,(long)error,errorDescription);
        
    };
    _audioStream.onCompletion = ^{
        
        NSLog(@"%s--完毕", __func__);
    };
    _audioStream.onMetaDataAvailable = ^(NSDictionary *metadata) {
        NSLog(@"%@------", metadata);
    };
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"----%f", _audioStream.currentTimePlayed.playbackTimeInSeconds);
    
    NSLog(@"---%f", _audioStream.duration.playbackTimeInSeconds);
    
    [self cachesize];
    
    
}

- (CGFloat)cachesize {
    
    _audioStream = [[FSAudioStream alloc]init];
    float totalCacheSize = 0;
    NSMutableArray *cachedFiles = [[NSMutableArray alloc] init];
    NSMutableDictionary *cacheObj = [NSMutableDictionary dictionary];
    
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_audioStream.configuration.cacheDirectory error:nil]) {
        if ([file hasPrefix:@"FSCache-"]) {
            cacheObj[@"name"] = file;
            cacheObj[@"path"] = [NSString stringWithFormat:@"%@/%@", _audioStream.configuration.cacheDirectory, file];
            cacheObj[@"attributes"] = [[NSFileManager defaultManager] attributesOfItemAtPath:cacheObj[@"path"] error:nil];
            
            totalCacheSize += [cacheObj fileSize];
            
            if (![file hasSuffix:@".metadata"]) {
                [cachedFiles addObject:cacheObj];
            }
        }
    }
    
    return totalCacheSize/1000000;
}

- (void)audioStream:(FSAudioStream *)audioStream samplesAvailable:(AudioBufferList *)samples frames:(UInt32)frames description: (AudioStreamPacketDescription)description{
    
    //    NSLog(@"--%d---%d--%d-%@",samples->mNumberBuffers,samples->mBuffers->mNumberChannels,samples->mBuffers->mDataByteSize,[[NSString alloc] initWithBytes:samples->mBuffers->mData length:samples->mBuffers->mDataByteSize encoding:NSUTF8StringEncoding]);
    //
    //    NSLog(@"--%d---%d--%d-%@",frames,description.mStartOffset,description.mVariableFramesInPacket,description.mVariableFramesInPacket,description.mDataByteSize);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loadProgress.progress = audioStream.prebufferedByteCount * 1.0/audioStream.contentLength;
        self.playProgress.value = audioStream.currentTimePlayed.playbackTimeInSeconds/audioStream.duration.playbackTimeInSeconds;
    });
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [FSPlayer defaultPlayer].cacheLists.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    PlayItem *item = [FSPlayer defaultPlayer].cacheLists[indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}

@end
