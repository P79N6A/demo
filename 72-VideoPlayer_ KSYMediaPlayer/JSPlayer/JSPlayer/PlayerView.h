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

@property (nonatomic, copy, readonly) NSString *live_stream;
@property (nonatomic, copy, readonly) NSString *name;

@end

@interface VideoModel : NSObject<TTZPlayerModel>
@property (nonatomic, copy) NSString *live_stream;
@property (nonatomic, copy) NSString *name;
@end

@interface PlayerView : UIView

/** 是否隐藏状态栏 */
@property (nonatomic, assign) BOOL statusBarHidden;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) BOOL allowSafariPlay;

@property (nonatomic, strong) id<TTZPlayerModel> model;

+ (instancetype)playerView;

- (void)playWithModel:(id<TTZPlayerModel>)model;

- (void)stop;

@end


@interface UIView (Player)
- (UIViewController *)viewController;
- (UIViewController *)topViewController;
@end

@interface UIImage (Bundle)
+ (UIImage *)imageFromBundleWithName:(NSString *)imageName;
@end

