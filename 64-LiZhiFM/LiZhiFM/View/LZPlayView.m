//
//  LZPlayView.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/21.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZPlayView.h"

#import "LZCommon.h"
#import "TTZPlayer.h"
#import "UIView+Loading.h"

#import "LZliveChannelModel.h"

#import <UIImageView+WebCache.h>

@interface LZPlayView()

@property (weak, nonatomic) IBOutlet UIButton *lockBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *desLB;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) LZPlayViewState state;

@end

@implementation LZPlayView

+ (instancetype)playView{
    return [[NSBundle mainBundle] loadNibNamed:@"LZPlayView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    kViewRadius(self.imgIV, 5);
    
    /**
     *   模糊效果的三种风格
     *
     UIBlurEffectStyleExtraLight,//额外亮度，（高亮风格）
     UIBlurEffectStyleLight,//亮风格
     UIBlurEffectStyleDark//暗风格
     *
     */
    //实现模糊效果
//    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    //毛玻璃视图
//    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
//    
//    visualEffectView.frame = CGRectMake(0, 0, 300, 500);
//    
//    visualEffectView.alpha = 0.9;
//    
//    [self addSubview:visualEffectView];
}

- (IBAction)lockAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        
        if (self.state != LZPlayViewStateShow) {
            self.state = LZPlayViewStateShow;
            !(_move)? : _move(LZPlayViewStateShow);
        }
    }else{
        [self timer];
    }
}
- (IBAction)play:(UIButton *)sender {
    
    
    if (![TTZPlayer defaultPlayer].model) {
        return;
    }
    
    sender.selected = !sender.isSelected;
    sender.isSelected? [[TTZPlayer defaultPlayer] pause] : [[TTZPlayer defaultPlayer] play];
    
}


- (void)setModel:(LZliveChannelModel <TTZPlayerModel>*)model{
    _model = model;
    [self.imgIV sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"logo"]];
    self.nameLB.text = model.name;
    self.desLB.text = model.liveSectionName;
    
    [[TTZPlayer defaultPlayer] playWithModel:model
                                onStartCache:^{
                                    [self.contentView showLoading:nil];
                                }
                                  onEndCache:^{
                                      [self.contentView hideLoading:nil];
                                  }];
    
    
    if (self.state != LZPlayViewStateShow) {
        self.state = LZPlayViewStateShow;
        !(_move)? : _move(LZPlayViewStateShow);
    }

    
    if (!self.lockBtn.isSelected) {
        if (_timer) {
            [self stopTimer];
        }
        [self timer];
    }
}


- (NSTimer *)timer{
    if (!_timer) {
        __weak typeof(self) weakSelf = self;
        NSTimer *timer = [NSTimer timerWithTimeInterval:3.0 target:weakSelf selector:@selector(timeChange:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (! newSuperview && _timer) {
        [self stopTimer];
    }
}

- (void)timeChange:(NSTimer *)sender{
    [self stopTimer];
    if(self.lockBtn.isSelected) return;
    if (self.state != LZPlayViewStateNotShow) {
        self.state = LZPlayViewStateNotShow;
        !(_move)? : _move(LZPlayViewStateNotShow);
    }
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.lockBtn.isSelected) {
        self.state = !self.state;
        !(_move)? : _move(self.state);
        if (self.state == LZPlayViewStateShow) {
            [self timer];
        }else{
            [self stopTimer];
        }
    }
}

@end
