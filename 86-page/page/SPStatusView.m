//
//  SPStatusView.m
//  page
//
//  Created by Jay on 8/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "SPStatusView.h"
#import "SPBatteryView.m"


@interface SPStatusView ()
@property (nonatomic, weak)  SPBatteryView *batteryView;
@property (nonatomic, weak)  UILabel *timeLabel;
@property (nonatomic, weak)  UILabel *titleLabel;
@property (nonatomic, weak)  NSTimer *timer;

@end
@implementation SPStatusView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
//        self.backgroundColor = [];
        
        [self addSubview:({
            
            SPBatteryView *batteryView = [[SPBatteryView alloc] init];
            _batteryView = batteryView;
            batteryView.tintColor = [UIColor colorWithRed:127/255.0 green:136/255.0 blue:138/255.0 alpha:1.0];
            [UIDevice currentDevice].batteryMonitoringEnabled = YES;
            batteryView.batteryLevel = [UIDevice currentDevice].batteryLevel;
            batteryView;
        })];

        
    }
    return self;
}
//
//override func addSubviews() {
//    
//    super.addSubviews()
//    
//    // 背景颜色
//    backgroundColor = DZMColor_1.withAlphaComponent(0.4)
//    
//    // 电池
//    batteryView = DZMBatteryView()
//    batteryView.tintColor = DZMColor_3
//    addSubview(batteryView)
//    
//    // 时间
//    timeLabel = UILabel()
//    timeLabel.textAlignment = .center
//    timeLabel.font = DZMFont_12
//    timeLabel.textColor = DZMColor_3
//    addSubview(timeLabel)
//    
//    // 标题
//    titleLabel = UILabel()
//    titleLabel.font = DZMFont_12
//    titleLabel.textColor = DZMColor_3
//    addSubview(titleLabel)
//    
//    // 初始化调用
//    didChangeTime()
//    
//    // 添加定时器
//    addTimer()
//}
//
//override func layoutSubviews() {
//    
//    super.layoutSubviews()
//    
//    // 适配间距
//    let space = isX ? DZMSpace_1 : 0
//    
//    // 电池
//    batteryView.origin = CGPoint(x: width - DZMBatterySize.width - space, y: (height - DZMBatterySize.height)/2)
//    
//    // 时间
//    let timeLabelW:CGFloat = DZMSizeW(50)
//    timeLabel.frame = CGRect(x: batteryView.frame.minX - timeLabelW, y: 0, width: timeLabelW, height: height)
//    
//    // 标题
//    titleLabel.frame = CGRect(x: space, y: 0, width: timeLabel.frame.minX - space, height: height)
//}
//
//// MARK: -- 时间相关
//
///// 添加定时器
//func addTimer() {
//    
//    if timer == nil {
//        
//        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(didChangeTime), userInfo: nil, repeats: true)
//        
//        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
//    }
//}
//
///// 删除定时器
//func removeTimer() {
//    
//    if timer != nil {
//        
//        timer!.invalidate()
//        
//        timer = nil
//    }
//}
//
///// 时间变化
//@objc func didChangeTime() {
//    
//    timeLabel.text = GetCurrentTimerString(dateFormat: "HH:mm")
//    
//    batteryView.batteryLevel = UIDevice.current.batteryLevel
//}
//
///// 销毁
//deinit {
//    
//    removeTimer()
//}

@end
