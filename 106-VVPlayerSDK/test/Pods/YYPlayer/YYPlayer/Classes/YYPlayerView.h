/**
 * date : 2018.08.06
 * date : 2018.08.09 直播隐藏快进
 * date : 2018.08.09 3秒自动隐藏工具菜单
 * date : 2018.08.28 重试和Safari
 * date : 2018.09.15 适配iPhoneX 系列
 * date : 2018.09.17 禁用其他方式创建播放器
 * date : 2018.09.28 优化
 */

#import <UIKit/UIKit.h>


@protocol YYPlayerModel<NSObject>

@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, copy, readonly) NSString *title;

@end

@interface YYVideoModel : NSObject<YYPlayerModel>
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@end

@interface YYPlayerView : UIView

/** 是否隐藏状态栏 */
@property (nonatomic, assign) BOOL statusBarHidden;

@property (nonatomic, assign,readonly) BOOL isPlaying;

@property (nonatomic, assign) BOOL allowSafariPlay;

@property (nonatomic, strong) id<YYPlayerModel> model;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

+ (instancetype)playerView;

- (void)playWithModel:(id<YYPlayerModel>)model;

- (void)stop;

@end


@interface UIView (YYPlayer)
- (UIViewController *)viewController;
- (UIViewController *)topViewController;
@end
@interface UIViewController (YYPlayer)
@property (nonatomic, assign) UIStatusBarStyle spStatusBarStyle;
@property (nonatomic, assign) BOOL spStatusBarHidden;
@property (nonatomic, assign) BOOL spHomeIndicatorAutoHidden;
@end

