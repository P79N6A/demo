/**
 * date : 2018/08/06
 * date : 2018/08/09 直播隐藏快进
 * date : 2018/08/09 3秒自动隐藏工具菜单
 */

#import <UIKit/UIKit.h>


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

