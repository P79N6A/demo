//
//  RadioCell.m
//  HKRadio
//
//  Created by czljcb on 2017/10/17.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "RadioCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LZliveChannelModel.h"
#import "LZData.h"

@interface RadioCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UIButton *heart;
@property (weak, nonatomic) IBOutlet UILabel *main;

@end

@implementation RadioCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    
    self.icon.layer.cornerRadius = 5;
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.borderWidth = 0.5;
    self.icon.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
//    self.selectionStyle = UITableViewCellSelectionStyleNone;   
}

- (IBAction)heartButton:(UIButton *)sender {
    
    
  
}

-(void)setFrame:(CGRect)frame {
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 20;
    frame.size.width -= 20;
    
    [super setFrame:frame];
}


-(void)setModel:(LZliveChannelModel *)model {
    _model = model;
    

    NSString *desc = [[LZData descDict] valueForKey:model.key];
    _des.text = desc.length ? desc : @"暂无相关介绍";
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"logo"]];
    _name.text = model.name;
    _main.text = model.liveSectionName;
    

}



@end
