//
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

//--------------------------------------------------------------------------------------
// 进度view
@interface SPVideoSlider : UISlider
@property (nonatomic, strong) UIImage *thumbBackgroundImage;
@end

//--------------------------------------------------------------------------------------
// 快进快退的view,快进快退时显示在中间
@interface SPVideoPlayerFastView : UIView
@property (nonatomic, strong) UIImageView *backgroundImageView; // 背景图
@property (nonatomic, strong) UILabel *fastTimeLabel;          // 时间
@property (nonatomic, strong) UIImageView *fastIconView;       // 快进快退的图标
//@property (nonatomic, strong) UIImageView *fastVideoImageView; // 快进快退的视频图,横屏时显示
@property (nonatomic, strong) UIProgressView *fastProgressView; // 进度条,竖屏时显示

@end


//--------------------------------------------------------------------------------------
// 亮度的view
@interface SPBrightnessView : UIView

@property (nonatomic, assign) CGFloat brightness;

@end

//--------------------------------------------------------------------------------------
// 自带浏览器
@interface WHWebViewController : UIViewController
/**请求的url*/
@property (nonatomic,copy) NSString *urlString;
/**进度条颜色 */
@property (nonatomic,strong) UIColor *loadingProgressColor;
/**是否下拉重新加载*/
@property (nonatomic, assign) BOOL canDownRefresh;
@end

@interface UIImage (Bundle)
+ (UIImage *)imageFromBundleWithName:(NSString *)imageName;
@end

//--------------------------------------------------------------------------------------
// 网速检测
@interface SpeedMonitor : NSObject

@property (nonatomic, copy, readonly) NSString *downloadNetworkSpeed;
@property (nonatomic, copy, readonly) NSString *uploadNetworkSpeed;

- (void)startNetworkSpeedMonitor;
- (void)stopNetworkSpeedMonitor;

@end


