//
//  ShareItemCell.m
//  ShareUI
//
//  Created by pkss on 2017/5/11.
//  Copyright © 2017年 J. All rights reserved.
//
#import "ActivityController.h"
#import "ShareMenuCell.h"

@implementation CannelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layer.cornerRadius = 12.f;
    self.layer.masksToBounds = YES;
}
@end

@interface ShareItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@end

@implementation ShareItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _logoIV.layer.cornerRadius = 10.f;
    _logoIV.layer.masksToBounds = YES;
}

- (void)setItem:(ItemModel *)item
{
    _item = item;
    _logoIV.image = [UIImage imageNamed:item.logo];
    _nameL.text = item.name;
}

@end


@interface ShareMenuCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end

@implementation ShareMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _layout.itemSize = CGSizeMake(_collectionView.bounds.size.height*0.6, _collectionView.bounds.size.height);
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"ShareItemCell" bundle:nil] forCellWithReuseIdentifier:@"ShareItemCell"];
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    [self.collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    (!_didSelect)? :_didSelect(indexPath.item);

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShareItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareItemCell" forIndexPath:indexPath];
    cell.item = _items[indexPath.item];
    return cell;
}

@end
