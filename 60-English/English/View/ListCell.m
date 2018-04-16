//
//  ListCell.m
//  English
//
//  Created by czljcb on 2018/4/15.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (IBAction)playAction:(UIButton *)sender {
    !(_playBlock)? : _playBlock(self.model);
}

- (void)setModel:(NSDictionary *)model{
    _model = model;
    self.titleLB.text = [model valueForKey:@"title"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
