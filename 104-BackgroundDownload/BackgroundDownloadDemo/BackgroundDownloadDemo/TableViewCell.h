//
//  TableViewCell.h
//  BackgroundDownloadDemo
//
//  Created by Jay on 7/9/18.
//  Copyright © 2018年 hkhust. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *speed;

@end
