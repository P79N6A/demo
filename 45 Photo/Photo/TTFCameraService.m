//
//  TTFCameraService.m
//  Photo
//
//  Created by Jay on 2018/3/1.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTFCameraService.h"
#import <AVFoundation/AVFoundation.h>

static id instance = nil;


@interface TTFCameraService ()

@property (nonatomic ,weak)UIView *focusView;
@property (nonatomic ,weak)UIView *contentView;
@property (nonatomic ,weak)UIImageView *imageView;

@property (nonatomic,assign)BOOL canCa;


//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic,strong)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic,strong)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic,strong)AVCaptureMetadataOutput *output;

@property (nonatomic,strong)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic,strong)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;


@end


@implementation TTFCameraService



+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}


- (void)initCamera:(UIView *)preview{
    
    [self canUserCamear];

    
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:NULL];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
        
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = preview.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [preview.layer addSublayer:self.previewLayer];
    
    [self.session startRunning];
    if ([self.device lockForConfiguration:nil]) {
        //自动闪光
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [self.device unlockForConfiguration];
    }
    
    
    //
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [preview addGestureRecognizer:tapGesture];
    
    UIView * focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    focusView.layer.borderWidth = 1.0;
    focusView.layer.borderColor =[UIColor greenColor].CGColor;
    focusView.backgroundColor = [UIColor clearColor];
    focusView.hidden = YES;
    [preview addSubview:focusView];
    _contentView = preview;
    _focusView = focusView;


}


- (void)cannelCompletion:(void (^)(void))completion {
    [self.imageView removeFromSuperview];
    [self.session startRunning];
    !(completion)? : completion();
}


- (void)takePhotoSuccess:(void (^)(UIImage *))success failure:(void (^)(NSString *))failure {
    
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        !(failure)? : failure(@"take photo failed!");

        return;
    }

    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        [self.session stopRunning];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.previewLayer.frame];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.image = [UIImage imageWithData:imageData];
        NSLog(@"image size = %@",NSStringFromCGSize([UIImage imageWithData:imageData].size));
        !(success)? : success(imageView.image);

    }];
    
    
}


- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point{
    
    CGSize size = self.contentView.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
    
}


#pragma mark - 检查相机权限
- (BOOL)canUserCamear{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;

}



@end
