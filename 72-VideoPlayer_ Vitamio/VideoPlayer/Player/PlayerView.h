/**
 * date : 2018/08/06
 * date : 2018/08/09 直播隐藏快进
 * date : 2018/08/09 3秒自动隐藏工具菜单
 * date : 2018/08/15 网速／加载进度／模式切换
 */

#import <UIKit/UIKit.h>


@protocol TTZPlayerModel<NSObject>

@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, copy, readonly) NSString *name;
/** 是否是点播*/
@property (nonatomic, assign, readonly) BOOL isVod;

@end

@interface VideoModel : NSObject<TTZPlayerModel>
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isVod;

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

@interface UIImage (Bundle)
+ (UIImage *)imageFromBundleWithName:(NSString *)imageName;
@end

