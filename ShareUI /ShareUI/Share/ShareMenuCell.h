//
//  ShareItemCell.h
//  ShareUI
//
//  Created by pkss on 2017/5/11.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareMenuCell : UITableViewCell
@property(nonatomic, strong)NSArray <ItemModel *>*items;
@property(nonatomic, copy)void (^didSelect)(NSInteger);
@end


@interface CannelCell : UITableViewCell

@end


@class ItemModel;
@interface ShareItemCell : UICollectionViewCell
@property(nonatomic, strong)ItemModel *item;
@end
