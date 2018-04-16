//
//  AnimalCell.m
//  Dog
//
//  Created by czljcb on 2018/4/6.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "AnimalCell.h"
#import "AnimalModel.h"
@interface AnimalCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation AnimalCell
- (void)setModel:(AnimalModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.name;
    self.imageView.image = [UIImage imageNamed:model.image];

}
@end
