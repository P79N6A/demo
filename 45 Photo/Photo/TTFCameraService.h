//
//  TTFCameraService.h
//  Photo
//
//  Created by Jay on 2018/3/1.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTFCameraService : NSObject
+ (instancetype)sharedInstance;
- (void)initCamera:(UIView *)preview;
- (void)takePhotoSuccess:(void(^)(UIImage *obj))success
                 failure:(void(^)(NSString *error))failure;
- (void)cannelCompletion:(void (^)(void))completion;
@end
