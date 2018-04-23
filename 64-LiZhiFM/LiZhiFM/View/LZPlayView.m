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


@end

@implementation LZPlayView

+ (instancetype)playView{
    return [[NSBundle mainBundle] loadNibNamed:@"LZPlayView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    kViewRadius(self.imgIV, 5);
}

- (IBAction)lockAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        !(_move)? : _move(ScreenHeight - 70+45);
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
    !(_move)? : _move(ScreenHeight - 70+45);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     if (!self.lockBtn.isSelected) !(_move)? : _move(self.frame.origin.y);
}

@end
