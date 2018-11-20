//
//  JDAdModalView.h
//  JDAdSDKDemo
//
//  Created by Ben Miao on 15/11/7.
//  Copyright © 2015年 com.jd.dm. All rights reserved.
//

#import "JDAdView.h"

@interface JDModalAdView : JDAdView
@property(nonatomic,strong) UIWebView* webView;
@property(nonatomic,strong) UIButton* closeButton;
@property(nonatomic,assign) BOOL canClose;


- (void)setModalViewFrame:(CGRect)frame;


- (void)showView;
- (void)popView;//show the view


- (void)dismissView;

@end
