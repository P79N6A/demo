//
//  EnglishCell.h
//  English
//
//  Created by czljcb on 2018/4/13.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTZEnglishCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (nonatomic, strong) NSArray *dics;
@property (nonatomic, copy) void (^didSelect)(NSInteger selectIndex,NSArray * dics);
@property (nonatomic, copy) void (^seeAllBlock)(NSArray * dics);

@end
