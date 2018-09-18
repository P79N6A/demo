/**
 * date : 2018.08.06
 * date : 2018.08.09 直播隐藏快进
 * date : 2018.08.09 3秒自动隐藏工具菜单
 * date : 2018.08.28 重试和Safari
 * date : 2018.09.15 适配iPhoneX 系列
 * date : 2018.09.17 禁用其他方式创建播放器
 */

#import <UIKit/UIKit.h>


@protocol VVPlayerModel<NSObject>

@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, copy, readonly) NSString *title;

@end

@interface VVVideoModel : NSObject<VVPlayerModel>
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@end

@interface VVPlayerView : UIView

/** 是否隐藏状态栏 */
@property (nonatomic, assign) BOOL statusBarHidden;

@property (nonatomic, assign,readonly) BOOL isPlaying;

@property (nonatomic, assign) BOOL allowSafariPlay;

@property (nonatomic, strong) id<VVPlayerModel> model;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

+ (instancetype)playerView;

- (void)playWithModel:(id<VVPlayerModel>)model;

- (void)stop;

@end


@interface UIView (VVPlayer)
- (UIViewController *)viewController;
- (UIViewController *)topViewController;
@end
@interface UIViewController (VVPlayer)
@property (nonatomic, assign) UIStatusBarStyle spStatusBarStyle;
@property (nonatomic, assign) BOOL spStatusBarHidden;
@property (nonatomic, assign) BOOL spHomeIndicatorAutoHidden;
@end

