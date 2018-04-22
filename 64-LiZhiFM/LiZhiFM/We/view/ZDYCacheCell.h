//
//  ZDYCacheCell.h
//  BuDeJie
//
//  Created by czljcb on 16/9/13.
//  Copyright © 2016年 czljcb. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ZDYCacheCell : UITableViewCell
- (void)removeCache;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *cacheLabel;
@property (nonatomic, assign) BOOL update;
@end
