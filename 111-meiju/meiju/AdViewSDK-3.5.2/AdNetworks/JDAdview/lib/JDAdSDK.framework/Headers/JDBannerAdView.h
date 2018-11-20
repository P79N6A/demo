//
//  JDAdBannerView.h
//  JDAdSDKDemo
//
//  Created by Ben Miao on 15/11/7.
//  Copyright © 2015年 com.jd.dm. All rights reserved.
//

#import "JDAdView.h"
#import "JDAdConfigration.h"

@interface JDBannerAdView : JDAdView
@property(nonatomic,strong) UIWebView* webView;
@property(nonatomic,strong) UIButton* closeButton;
@property(nonatomic,assign) BOOL canClose;

- (void)bannerFrameModel:(CGRect)frame parentView:(UIView*)parentView;

- (void)bannerAutoLayOutAdaptorWithPosition:(BannerPosition)position parentView:(UIView*)parentView andConstraits:(NSArray*)constraits;

@end
