/**
 * date : 2018/08/06
 * date : 2018/08/09 直播隐藏快进
 * date : 2018/08/09 3秒自动隐藏工具菜单
 * date : 2018/08/28 重试和Safari
 * date : 2018/09/15 适配iPhoneX 系列
 * date : 2018/10/05 优化WebView
 * date : 2018/10/08 优化errorReload
 * date : 2018/10/09 适配iOS12
 * date : 2018/10/16 优化播放
 */

#import <UIKit/UIKit.h>


@protocol TTZPlayerModel<NSObject>

@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, copy, readonly) NSString *title;

@end

@interface VideoModel : NSObject<TTZPlayerModel>
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@end

@interface PlayerView : UIView

/** 是否隐藏状态栏 */
@property (nonatomic, assign) BOOL statusBarHidden;

@property (nonatomic, assign,readonly) BOOL isPlaying;

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
@interface UIViewController (Player)
@property (nonatomic, assign) UIStatusBarStyle spStatusBarStyle;
@property (nonatomic, assign) BOOL spStatusBarHidden;
@property (nonatomic, assign) BOOL spHomeIndicatorAutoHidden;
@end

