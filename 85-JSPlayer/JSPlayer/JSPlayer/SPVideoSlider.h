//
//  SPVideoSlider.h
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPVideoSlider : UISlider

@property (nonatomic, strong) UIImage *thumbBackgroundImage;

@end



@interface WHWebViewController : UIViewController

/**
 请求的url
 */
@property (nonatomic,copy) NSString *urlString;


/**
 进度条颜色
 */
@property (nonatomic,strong) UIColor *loadingProgressColor;

/**
 是否下拉重新加载
 */
@property (nonatomic, assign) BOOL canDownRefresh;

@end


