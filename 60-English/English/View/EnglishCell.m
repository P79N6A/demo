//
//  EnglishCell.m
//  fzdm
//
//  Created by czljcb on 2018/3/16.
//  Copyright © 2018年 Ward Wong. All rights reserved.
//

#import "EnglishCell.h"

#import "Common.h"

@interface EnglishCell ()

@end


@implementation EnglishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    kViewRadius(self.logoLabel, 10);
    kViewRadius(self.topLabel, 10);
}


@end
