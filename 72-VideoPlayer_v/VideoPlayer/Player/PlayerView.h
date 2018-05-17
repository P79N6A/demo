//
//  PlayView.h
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PlayViewState) {
    PlayViewStateSmall,
    PlayViewStateAnimating,
    PlayViewStateFullScreenRight,
    PlayViewStateFullScreenLeft,
};

@protocol TTZPlayerModel<NSObject>

@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSString *name;

@end

@interface PlayerView : UIView

/** 是否隐藏状态栏 */
@property (nonatomic, assign) BOOL prefersStatusBarHidden;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) id<TTZPlayerModel> model;

+ (instancetype)playerView;

- (void)playWithModel:(id<TTZPlayerModel>)model;

- (void)stop;

@end

