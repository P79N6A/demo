//
//  EnglishCell.m
//  English
//
//  Created by czljcb on 2018/4/13.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "EnglishCell.h"
#import "EnglishItemCell.h"

@interface EnglishCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end

@implementation EnglishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"EnglishItemCell" bundle:nil] forCellWithReuseIdentifier:@"EnglishItemCell"];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    self.layout.itemSize = CGSizeMake((w - 15)* 0.5, (w -15)* 0.5);
    
    self.layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    
    EnglishItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EnglishItemCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    NSDictionary *dic = self.dics[indexPath.item];
    cell.titleLB.text = [dic valueForKey:@"title"];
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
