//
//  baseViewController.h
//  Coin3658
//
//  Created by 川何 on 2017/6/26.
//  Copyright © 2017年 hechuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NetWorkStatus) {
    
    NetWorkStatusNoInternet,//没有网络
    NetWorkStatusFlow,//流量连接
    NetWorkStatusWifi //wifi链接
};

@interface baseViewController : UIViewController
@property(nonatomic,assign) NetWorkStatus netStatus;

//添加没有网络界面
- (void)addEmptyViewWithFrame:(CGRect)frame;

//移除没有网络界面
- (void)removeEmptyView;

//点击空白视图回调
- (void)clickEmptyView;

//监测网络状态的方法
- (void)monitorNetStateChanged:(NSInteger)netState;

@end
