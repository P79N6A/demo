//
//  EnglishCell.m
//  English
//
//  Created by czljcb on 2018/4/13.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZEnglishCell.h"
#import "EnglishItemCell.h"

#import "Common.h"

#import <UIImageView+WebCache.h>

@interface TTZEnglishCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end

@implementation TTZEnglishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"EnglishItemCell" bundle:nil] forCellWithReuseIdentifier:@"EnglishItemCell"];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    self.layout.itemSize = CGSizeMake((w - 3)* 0.5, (w -3)* 0.5);
    
    self.layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    self.collectionView.backgroundColor = kBackgroundColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)seeAction:(UIButton *)sender {
    !(_seeAllBlock)? : _seeAllBlock(self.dics);
}

- (void)setDics:(NSArray *)dics{
    _dics = dics;
    [self.collectionView reloadData];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    
    EnglishItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EnglishItemCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dics[indexPath.item];
    cell.titleLB.text = [dic valueForKey:@"title"];
    [cell.imageIV sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"img"]] placeholderImage:nil];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return 4;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    !(_didSelect)? : _didSelect(indexPath.item,self.dics);
}

@end
