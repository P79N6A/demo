//
//  EmptyView.m
//  bbox
//
//  Created by 何川 on 2018/3/15.
//  Copyright © 2018年 何川. All rights reserved.
//

#import "EmptyView.h"
// 定义这个常量,就可以在使用Masonry不必总带着前缀 `mas_`:
//#define MAS_SHORTHAND

@interface EmptyView()

@property(nonatomic,strong) UIImageView *placeImageView;
@property(nonatomic,strong) UILabel *loadFailedLabel;
@property(nonatomic,strong) UILabel *retryLoadlabel;
@end

@implementation EmptyView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self settingView];
    }
    return self;
}


-(void)settingView{
    //占位图片
    _placeImageView = [[UIImageView alloc ]init];
    _placeImageView.image = [UIImage imageNamed:@"无网络"];
    [self addSubview:_placeImageView];
    
    //加载失败的文字
    _loadFailedLabel = [[UILabel alloc] init];
    _loadFailedLabel.text = @"网络已断开，请检查网络";
    _loadFailedLabel.textColor = [UIColor blackColor];
    _loadFailedLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_loadFailedLabel];
    
    //重新加载文字
    _retryLoadlabel = [[UILabel alloc] init];
    _retryLoadlabel.text = @"点击屏幕重新加载";
    _retryLoadlabel.font = [UIFont systemFontOfSize:14];
    _retryLoadlabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_retryLoadlabel];
    
    //布局
    [self layoutView];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickACtion:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (void)layoutView {
    
    [_placeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self).offset(-80);
        make.width.mas_equalTo(393/2);
        make.height.mas_equalTo(258/2);
        make.centerX.equalTo(self).offset(0);
    }];
    
    [_loadFailedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_placeImageView.mas_bottom).offset(0);
        make.width.equalTo(self);
        make.height.mas_equalTo(21);
        make.centerX.equalTo(self).offset(0);
        
    }];
    
    //    [_retryLoadlabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.top.equalTo(_loadFailedLabel.bottom).offset(10);
    //        make.width.equalTo(self.width);
    //        make.height.equalTo(21);
    //        make.centerX.equalTo(self).offset(0);
    //    }];
}
- (void)clickACtion:(UITapGestureRecognizer *)sender {
    
    if (self.delegates && [self.delegates respondsToSelector:@selector(clickEmptyViewWithAction:)]) {
        
        [self.delegates clickEmptyViewWithAction:sender.view];
    }
    
}
@end
