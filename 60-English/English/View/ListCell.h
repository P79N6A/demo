//
//  ListCell.h
//  English
//
//  Created by czljcb on 2018/4/15.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (nonatomic, strong) NSDictionary *model;

@property (nonatomic, copy) void (^playBlock)(NSDictionary *);

@end
