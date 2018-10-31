/**
 * date : 2018/08/23 5秒自动隐藏工具菜单
 * date : 2018/10/26 修复WebView播放视频弹不出
 * date : 2018/10/26 修复快进
 * date : 2018/10/29 优化出错文案
 * date : 2018/10/30 修复停止后杀退
 */

#import <UIKit/UIKit.h>



@protocol SPPlayerModel<NSObject>

@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, copy, readonly) NSString *title;

@end

@interface VideoModel : NSObject<SPPlayerModel>
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@end

@interface PlayerView : UIView

/** 是否隐藏状态栏 */
@property (nonatomic, assign) BOOL statusBarHidden;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) BOOL allowSafariPlay;

@property (nonatomic, strong) id<SPPlayerModel> model;


+ (instancetype)playerView;

- (void)playWithModel:(id<SPPlayerModel>)model;

- (void)stop;

@end


@interface UIViewController (Player)
@property (nonatomic, assign) UIStatusBarStyle spStatusBarStyle;
@property (nonatomic, assign) BOOL spStatusBarHidden;
@property (nonatomic, assign) BOOL spHomeIndicatorAutoHidden;
@end
@interface UIView (Player)
- (UIViewController *)viewController;
- (UIViewController *)topViewController;
@end


