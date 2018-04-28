//
//  ViewController.m
//  GPUImage
//
//  Created by Jay on 27/4/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

#import "UIView+Loading.h"

#import <GPUImage.h>
#import <Photos/Photos.h>

@interface ViewController ()
{
    GPUImageNormalBlendFilter *filter;
    GPUImageMovie *movieFile;
    GPUImageMovieWriter*movieWriter;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self useGpuimage];
}

-(void)useGpuimage{
    NSURL *videoPath = [NSURL fileURLWithPath:@"/Users/jay/Desktop/1.mp4"];//[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"selfS" ofType:@"MOV"]];
    [self saveVedioPath:videoPath WithWaterImg:[UIImage imageNamed:@"1"] WithCoverImage:[UIImage imageNamed:@"2"] WithQustion:@"文字水印：hudongdongBlog" WithFileName:@"waterVideo"];
}

/**
 使用GPUImage加载水印
 
 @param vedioPath 视频路径
 @param img 水印图片
 @param coverImg 水印图片二
 @param question 字符串水印
 @param fileName 生成之后的视频名字
 */
-(void)saveVedioPath:(NSURL*)vedioPath
        WithWaterImg:(UIImage*)img
      WithCoverImage:(UIImage*)coverImg
         WithQustion:(NSString*)question
        WithFileName:(NSString*)fileName
{
    //[SVProgressHUD showWithStatus:@"生成水印视频到系统相册"];
    [self.view showLoading:@"生成水印视频到系统相册"];
    // 滤镜
    //    filter = [[GPUImageDissolveBlendFilter alloc] init];
    //    [(GPUImageDissolveBlendFilter *)filter setMix:0.0f];
    //也可以使用透明滤镜
    //    filter = [[GPUImageAlphaBlendFilter alloc] init];
    //    //mix即为叠加后的透明度,这里就直接写1.0了
    //    [(GPUImageDissolveBlendFilter *)filter setMix:1.0f];
    
    filter = [[GPUImageNormalBlendFilter alloc] init];
    
    NSURL *sampleURL  = vedioPath;
    AVAsset *asset = [AVAsset assetWithURL:sampleURL];
    CGSize size = asset.naturalSize;
    
    movieFile = [[GPUImageMovie alloc] initWithAsset:asset];
    movieFile.playAtActualSpeed = NO;
    
    // 文字水印
    UILabel *label = [[UILabel alloc] init];
    label.text = question;
    label.font = [UIFont systemFontOfSize:30];
    label.textColor = [UIColor whiteColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label sizeToFit];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 18.0f;
    [label setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [label setFrame:CGRectMake(50, 100, label.frame.size.width+20, label.frame.size.height)];
    
    //图片水印
    UIImage *coverImage1 = [img copy];
    UIImageView *coverImageView1 = [[UIImageView alloc] initWithImage:coverImage1];
    [coverImageView1 setFrame:CGRectMake(0, 100, 210, 50)];
    
    //第二个图片水印
    UIImage *coverImage2 = [coverImg copy];
    UIImageView *coverImageView2 = [[UIImageView alloc] initWithImage:coverImage2];
    [coverImageView2 setFrame:CGRectMake(270, 100, 210, 50)];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    subView.backgroundColor = [UIColor clearColor];
    
    [subView addSubview:coverImageView1];
    [subView addSubview:coverImageView2];
    [subView addSubview:label];
    
    
    GPUImageUIElement *uielement = [[GPUImageUIElement alloc] initWithView:subView];
    NSString *pathToMovie = @"/Users/jay/Desktop/188.mp4";//[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.mp4",fileName]];
    
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720.0, 1280.0)];
    
    GPUImageFilter* progressFilter = [[GPUImageFilter alloc] init];
    [progressFilter addTarget:filter];
    [movieFile addTarget:progressFilter];
    [uielement addTarget:filter];
    movieWriter.shouldPassthroughAudio = YES;
    //    movieFile.playAtActualSpeed = true;
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] > 0){
        movieFile.audioEncodingTarget = movieWriter;
    } else {//no audio
        movieFile.audioEncodingTarget = nil;
    }
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    // 显示到界面
    [filter addTarget:movieWriter];
    
    [movieWriter startRecording];
    [movieFile startProcessing];
    
    //    dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    //    [dlink setFrameInterval:15];
    //    [dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //    [dlink setPaused:NO];
    
    __weak typeof(self) weakSelf = self;
    //渲染
    [progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
       
        NSLog(@"%s", __func__);
//        dispatch_async(dispatch_get_main_queue(), ^{
            //水印可以移动
            CGRect frame = coverImageView1.frame;
            frame.origin.x += 1;
            frame.origin.y += 1;
            coverImageView1.frame = frame;
            //第5秒之后隐藏coverImageView2
            if (time.value/time.timescale>=5.0) {
                [coverImageView2 removeFromSuperview];
            }
            [uielement update];

//        });
     
    }];
    //保存相册
    [movieWriter setCompletionBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf->filter removeTarget:strongSelf->movieWriter];
            [strongSelf->movieWriter finishRecording];
            __block PHObjectPlaceholder *placeholder;
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie))
            {
                NSError *error;
                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                    PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:movieURL];
                    placeholder = [createAssetRequest placeholderForCreatedAsset];
                } error:&error];
                if (error) {
                    [strongSelf.view hideLoading:[NSString stringWithFormat:@"%@",error]];
                    //[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
                }
                else{
                    [strongSelf.view hideLoading:@"视频已经保存到相册"];
                    //[SVProgressHUD showSuccessWithStatus:@"视频已经保存到相册"];
                }
            }
        });
    }];
}



@end
