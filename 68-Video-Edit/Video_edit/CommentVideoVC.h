//
//  CommentVideoVC.h
//  Video_edit
//
//  Created by xiaoke_mh on 16/4/7.
//  Copyright © 2016年 m-h. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYQAssetPickerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

#import "MBProgressHUD+MJ.h"
#import "VideoImage.h"
@interface CommentVideoVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate>

@property(nonatomic,copy)NSURL * videoUrl;
/**
 *  @author mmmmh, 16-04-07 16:04:38
 *
 *  选取视频
 */
-(void)choose_video;

-(void)showLoadIng;
-(void)stopLoadIng;
@end
