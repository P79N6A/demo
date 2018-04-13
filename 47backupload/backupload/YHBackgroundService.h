//
//  YHBackgroundService.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ProgressType)(CGFloat);
typedef void(^CompleteType)(id , NSError*);


@interface YHBackgroundService : NSObject


- (void)uploadFormData:(NSData *)data
                   url:(NSString *)url
            parameters:(NSDictionary*)parameters
                  name:(NSString *)name
              fileName:(NSString *)fileName
       currentProgress:(ProgressType)progress
           didComplete:(CompleteType)complete;

- (void)stop;

@end
