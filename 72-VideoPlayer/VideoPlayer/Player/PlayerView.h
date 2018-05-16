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
    PlayViewStateFullScreen,
};

@protocol TTZPlayerModel<NSObject>

@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, copy, readonly) NSString *name;

@end

@interface PlayerView : UIView

/** 记录小屏时的parentView */
@property (nonatomic, weak) UIView *playViewParentView;

/** 记录小屏时的frame */
@property (nonatomic, assign) CGRect playViewSmallFrame;

@property (nonatomic, assign) PlayViewState state;

/** 加载中 */
//@property (nonatomic, copy) void (^playerLoading)(void);
/** 加载完毕 */
//@property (nonatomic, copy) void (^playerCompletion)(void);
//@property (nonatomic, copy) void (^statusBarAppearanceUpdate)(void);

/** 是否隐藏状态栏 */
@property (nonatomic, assign) BOOL prefersStatusBarHidden;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) id<TTZPlayerModel> model;

+ (instancetype)playerView;

- (void)playWithModel:(id<TTZPlayerModel>)model;

- (void)stop;

@end

