//
//  DownItem.h
//  BackgroundDownloadDemo
//
//  Created by Jay on 7/9/18.
//  Copyright © 2018年 hkhust. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownItem : NSObject
@property (nonatomic, copy) NSString *down;
@property (nonatomic, copy) NSString *zhuti;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) void (^progressBolck)(CGFloat progress,NSString *url);
@property (nonatomic, copy) void (^speedBolck)(NSString *speed,NSString *url);
@property (nonatomic, weak) UIProgressView *progress;
@property (nonatomic, weak) UILabel *speed;
@end
