//
//  ListCell.h
//  VipPlay
//
//  Created by Jay on 28/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SPLabel : UILabel
@end
@interface ListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *indexView;
@property (weak, nonatomic) IBOutlet UILabel *tilteLB;
@end
