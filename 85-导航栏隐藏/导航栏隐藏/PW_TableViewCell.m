//
//  PW_TableViewCell.m
//  导航栏隐藏
//
//  Created by DFSJ on 17/3/15.
//  Copyright © 2017年 Oriental Horizon. All rights reserved.
//

#import "PW_TableViewCell.h"

@implementation PW_TableViewCell


+(instancetype) cellWithTableView:(UITableView *)tableView{


static NSString *identifer = @"PW_TableViewCell";
    
    PW_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    
    if (cell == nil) {
        
        cell = [[PW_TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        
    }

    return cell;
}

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *label = [[UILabel alloc]init];
        
        label.frame = CGRectMake(10, 0, self.frame.size.width, self.frame.size.height);
        
        label.text = @"哈哈哈哈哈哈";
        [self.contentView addSubview:label];
        
        
        
    }

    return self;
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
